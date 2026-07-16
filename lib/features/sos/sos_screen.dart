import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/providers.dart';
import '../../services/audio_service.dart';
import '../../services/location_service.dart';
import '../../services/notification_service.dart';
import '../../services/sms_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class SosScreen extends ConsumerStatefulWidget {
  const SosScreen({super.key});

  @override
  ConsumerState<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends ConsumerState<SosScreen> {
  static const MethodChannel _channel = MethodChannel('com.lifecard.sos/device');

  bool _isCountdownActive = true;
  int _countdownSeconds = 5;
  Timer? _countdownTimer;

  bool _isFlashlightActive = false;

  bool _isAlarmActive = false;

  LocationData? _locationData;
  bool _isLoadingLocation = true;
  String _broadcastStatus = 'Preparing emergency alerts...';
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _fetchLocation();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _stopFlashlightBlink();
    AudioService.stopSiren();
    super.dispose();
  }

  void _startCountdown() {
    ref.read(settingsProvider).whenData((settings) {
      setState(() {
        _countdownSeconds = settings.sosCountdownSeconds;
      });
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 1) {
        setState(() {
          _countdownSeconds--;
        });
        HapticFeedback.vibrate();
      } else {
        timer.cancel();
        _triggerSosAlerts();
      }
    });
  }

  Future<void> _fetchLocation() async {
    final data = await LocationService.getCurrentLocation();
    if (mounted) {
      setState(() {
        _locationData = data;
        _isLoadingLocation = false;
      });
      if (data != null) {
        _mapController.move(LatLng(data.latitude, data.longitude), 15.0);
      }
    }
  }

  void _triggerSosAlerts() {
    setState(() {
      _isCountdownActive = false;
      _isAlarmActive = true;
    });

    // Start siren
    AudioService.playSiren();

    // Start flashlight blink
    _startFlashlightBlink();

    // Display SOS Notification
    NotificationService.showSosNotification();

    // Broadcast SMS emergency messages and location
    _sendEmergencyBroadcast();
  }

  Future<void> _sendEmergencyBroadcast() async {
    if (!mounted) return;
    
    // Check & request SMS runtime permission dynamically
    var smsStatus = await Permission.sms.status;
    if (smsStatus.isDenied) {
      if (mounted) {
        setState(() {
          _broadcastStatus = 'Requesting SMS permission...';
        });
      }
      smsStatus = await Permission.sms.request();
    }

    if (smsStatus.isPermanentlyDenied) {
      if (mounted) {
        setState(() {
          _broadcastStatus = 'SMS permission denied. Enable in Settings.';
        });
      }
      return;
    }

    if (!smsStatus.isGranted) {
      if (mounted) {
        setState(() {
          _broadcastStatus = 'SMS failed: Permission Denied.';
        });
      }
      return;
    }

    setState(() {
      _broadcastStatus = 'Acquiring emergency coordinates...';
    });

    // 1. Fetch location if not already available
    LocationData? location = _locationData;
    if (location == null) {
      location = await LocationService.getCurrentLocation();
      if (mounted && location != null) {
        setState(() {
          _locationData = location;
          _isLoadingLocation = false;
        });
        _mapController.move(LatLng(location.latitude, location.longitude), 15.0);
      }
    }

    // 2. Fetch contacts and settings
    final contacts = ref.read(contactsProvider).value ?? [];
    final settings = ref.read(settingsProvider).value;
    
    // Filter contacts that have sendSmsOnSos == true
    final smsRecipients = contacts
        .where((c) => c.sendSmsOnSos && c.primaryPhone.isNotEmpty)
        .map((c) => c.primaryPhone)
        .toList();

    if (smsRecipients.isEmpty) {
      if (mounted) {
        setState(() {
          _broadcastStatus = 'No contacts configured for SOS SMS.';
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _broadcastStatus = 'Broadcasting emergency messages...';
      });
    }

    // 3. Build message
    var template = settings?.sosSmsMessageTemplate ?? "HELP ME!! IT'S AN EMERGENCY!!\n\nPlease reach ASAP to the location below";
    if (template.contains("I need emergency assistance")) {
      template = "HELP ME!! IT'S AN EMERGENCY!!\n\nPlease reach ASAP to the location below";
    }
    String message = template;
    if (location != null) {
      message = "$template https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}";
    } else {
      message = "$template (Location unavailable)";
    }

    // 4. Send SMS
    final sent = await SmsService.sendSms(
      recipients: smsRecipients,
      message: message,
    );

    if (mounted) {
      setState(() {
        _broadcastStatus = sent
            ? 'Emergency messages broadcasted successfully!'
            : 'Failed to send SMS programmatically.';
      });
    }
  }

  void _startFlashlightBlink() async {
    _isFlashlightActive = true;
    try {
      await _channel.invokeMethod('startFlashlightBlink');
    } catch (_) {}
  }

  void _stopFlashlightBlink() async {
    _isFlashlightActive = false;
    try {
      await _channel.invokeMethod('stopFlashlightBlink');
    } catch (_) {}
  }

  void _toggleFlashlight() {
    if (_isFlashlightActive) {
      _stopFlashlightBlink();
    } else {
      _startFlashlightBlink();
    }
    setState(() {});
  }

  void _toggleAlarm() {
    if (_isAlarmActive) {
      AudioService.stopSiren();
      _isAlarmActive = false;
    } else {
      AudioService.playSiren();
      _isAlarmActive = true;
    }
    setState(() {});
  }

  void _stopAllSos() {
    _countdownTimer?.cancel();
    _stopFlashlightBlink();
    AudioService.stopSiren();
    NotificationService.cancelSos();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCountdownActive) {
      return Scaffold(
        backgroundColor: AppColors.amoledBlack,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_rounded, color: AppColors.primaryRed, size: 80)
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 600.ms),
              const SizedBox(height: 24),
              const Text(
                'SOS EMERGENCY TRIGGERED',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
              const SizedBox(height: 48),
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryRed, width: 6),
                ),
                child: Center(
                  child: Text(
                    '$_countdownSeconds',
                    style: const TextStyle(color: Colors.white, fontSize: 72, fontWeight: FontWeight.w900),
                  ),
                ),
              ).animate(key: ValueKey(_countdownSeconds)).scale(begin: const Offset(1.2, 1.2), end: const Offset(1.0, 1.0), duration: 300.ms, curve: Curves.easeOut),
              const SizedBox(height: 48),
              const Text(
                'Starting siren and broadcasting location details...',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                height: 56,
                child: OutlinedButton(
                  onPressed: _stopAllSos,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('CANCEL SOS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final profile = ref.watch(profileProvider).value;
    final medical = ref.watch(medicalProfileProvider).value;
    final contacts = ref.watch(contactsProvider).value ?? [];

    return Scaffold(
      backgroundColor: AppColors.amoledBlack,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'LifeCard SOS',
                    style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                    onPressed: _stopAllSos,
                  )
                ],
              ),
            ),

            // Scrollable Emergency Info
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Circular SOS alert beacon
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryRed,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Color(0x77D32F2F), blurRadius: 20, spreadRadius: 5)
                            ],
                          ),
                          child: const Icon(Icons.emergency, color: Colors.white, size: 40),
                        ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                         .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 800.ms, curve: Curves.easeInOut)
                         .boxShadow(begin: const BoxShadow(color: Color(0x33D32F2F), blurRadius: 10, spreadRadius: 2), end: const BoxShadow(color: Color(0x99D32F2F), blurRadius: 30, spreadRadius: 10), duration: 800.ms, curve: Curves.easeInOut),
                        const SizedBox(height: 12),
                        const Text(
                          'Emergency Profile',
                          style: TextStyle(color: Colors.cyan, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'CRITICAL MODE ACTIVE',
                          style: TextStyle(color: AppColors.primaryRed, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // User Detail Card (High Contrast)
                  Card(
                    color: const Color(0xFF1E1E1E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Color(0xFF333333)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              shape: BoxShape.circle,
                              image: profile != null && profile.photoPath.isNotEmpty && File(profile.photoPath).existsSync()
                                  ? DecorationImage(
                                      image: FileImage(File(profile.photoPath)),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: profile == null || profile.photoPath.isEmpty || !File(profile.photoPath).existsSync()
                                ? const Icon(Icons.person, color: Colors.grey, size: 36)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile?.fullName.isEmpty ?? true ? 'Emergency Patient' : profile!.fullName,
                                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: AppColors.primaryRed, borderRadius: BorderRadius.circular(6)),
                                  child: Text(
                                    'BLOOD GROUP: ${profile?.bloodGroup.isEmpty ?? true ? "Unknown" : profile!.bloodGroup}',
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Vitals
                  Card(
                    color: const Color(0xFF1E1E1E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Color(0xFF333333)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Baseline Vitals',
                            style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildVitalText('WEIGHT', '${profile?.weight ?? 78.0} kg'),
                              ),
                              Container(width: 1, height: 30, color: Colors.grey.shade800),
                              Expanded(
                                child: _buildVitalText('HEIGHT', '${profile?.height ?? 175.0} cm'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Medical Alerts Box (Allergies / Conditions)
                  if (medical != null) ...[
                    _buildSosSection('MEDICAL CONDITIONS', medical.medicalConditions.isEmpty ? ['None Specified'] : medical.medicalConditions),
                    const SizedBox(height: 12),
                    _buildSosSection('ALLERGIES & REACTIONS', medical.allergies.isEmpty ? ['None Specified'] : medical.allergies),
                    const SizedBox(height: 12),
                    _buildSosSection('CURRENT MEDICINES', medical.currentMedicines.isEmpty ? ['None Specified'] : medical.currentMedicines),
                    const SizedBox(height: 12),
                  ],

                  // Contacts
                  if (contacts.isNotEmpty) ...[
                    Card(
                      color: const Color(0xFF1E1E1E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Color(0xFF333333)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'EMERGENCY CONTACTS',
                              style: TextStyle(color: AppColors.primaryRed, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                            ),
                            const SizedBox(height: 12),
                            ...contacts.take(2).map((contact) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${contact.name} (${contact.relationship})',
                                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    contact.primaryPhone,
                                    style: const TextStyle(color: Colors.cyan, fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Live Coordinates & Interactive Map Card
                  Card(
                    color: const Color(0xFF1E1E1E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Color(0xFF333333)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      height: 220,
                      child: Stack(
                        children: [
                          // Map Layer
                          if (_isLoadingLocation)
                            const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(color: AppColors.primaryRed),
                                  SizedBox(height: 12),
                                  Text('Locating device...', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            )
                          else if (_locationData != null)
                            FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                initialCenter: LatLng(_locationData!.latitude, _locationData!.longitude),
                                initialZoom: 15.0,
                                minZoom: 3.0,
                                maxZoom: 18.0,
                                interactionOptions: const InteractionOptions(
                                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                                ),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                                  subdomains: const ['a', 'b', 'c', 'd'],
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: LatLng(_locationData!.latitude, _locationData!.longitude),
                                      width: 40,
                                      height: 40,
                                      child: const Icon(
                                        Icons.location_on_rounded,
                                        color: AppColors.primaryRed,
                                        size: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          else
                            const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.location_off_rounded, color: Colors.grey, size: 48),
                                  SizedBox(height: 12),
                                  Text(
                                    'Location coordinates unavailable',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Check device GPS settings',
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),

                          // HUD coordinates overlay
                          if (!_isLoadingLocation && _locationData != null)
                            Positioned(
                              left: 12,
                              bottom: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(180),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade800),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'LAT: ${_locationData!.latitude.toStringAsFixed(6)} / LON: ${_locationData!.longitude.toStringAsFixed(6)}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontFamily: 'monospace',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Accuracy: ±${_locationData!.accuracy.toStringAsFixed(1)}m',
                                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Recenter button
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          if (_locationData != null) {
                                            _mapController.move(
                                              LatLng(_locationData!.latitude, _locationData!.longitude),
                                              15.0,
                                            );
                                          }
                                        },
                                        borderRadius: BorderRadius.circular(20),
                                        child: const Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: Icon(
                                            Icons.my_location_rounded,
                                            color: Colors.cyan,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: _buildControlTile(
                          icon: Icons.flashlight_on_rounded,
                          label: 'FLASHLIGHT',
                          isActive: _isFlashlightActive,
                          onTap: _toggleFlashlight,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildControlTile(
                          icon: Icons.volume_up_rounded,
                          label: 'ALARM',
                          isActive: _isAlarmActive,
                          onTap: _toggleAlarm,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),

            // Persistent bottom status indicator
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF111111),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'EMERGENCY BROADCAST',
                          style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                        ),
                        Text(
                          _broadcastStatus,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 44,
                    child: FilledButton(
                      onPressed: _stopAllSos,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('STOP SOS', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildVitalText(String label, String val) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(val, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSosSection(String title, List<String> items) {
    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF333333)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0),
            ),
            const SizedBox(height: 8),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  const Icon(Icons.circle, color: AppColors.primaryRed, size: 6),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildControlTile({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final bgColor = isActive ? AppColors.primaryRed : const Color(0xFF1E1E1E);
    final borderCol = isActive ? AppColors.primaryRed : const Color(0xFF333333);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderCol),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0),
            ),
          ],
        ),
      ),
    );
  }
}
