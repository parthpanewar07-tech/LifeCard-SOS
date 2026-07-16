import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Permissions state
  bool _locationGranted = false;
  bool _smsGranted = false;
  bool _vitalsGranted = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.sms,
      Permission.phone,
      Permission.notification,
    ].request();

    setState(() {
      _locationGranted = statuses[Permission.location]?.isGranted ?? false;
      _smsGranted = (statuses[Permission.sms]?.isGranted ?? false) &&
          (statuses[Permission.phone]?.isGranted ?? false);
      _vitalsGranted = statuses[Permission.notification]?.isGranted ?? false;
    });

    // Complete setup in providers
    await ref.read(settingsProvider.notifier).completeSetup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
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
                    style: TextStyle(
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  if (_currentPage < 2)
                    TextButton(
                      onPressed: () async {
                        await ref.read(settingsProvider.notifier).completeSetup();
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
            
            // Content PageView
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                physics: const NeverScrollableScrollPhysics(), // Force navigation via buttons
                children: [
                  _buildSplashPage(),
                  _buildPrivacyPage(),
                  _buildPermissionsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSplashPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Central Star of life logo
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x11000000),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                )
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.medical_services,
                size: 70,
                color: AppColors.primaryRed,
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .scale(begin: const Offset(0.96, 0.96), end: const Offset(1.04, 1.04), duration: 1500.ms, curve: Curves.easeInOut),
          const SizedBox(height: 24),
          Text(
            'LifeCard SOS',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 8),
          const Text(
            'PERSONAL HEALTH VAULT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              letterSpacing: 2.0,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideY(begin: 0.1, end: 0),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          // Shield badge illustration
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0x114CAF50),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield,
              size: 40,
              color: AppColors.activeGreen,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Privacy is a Right.',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 8),
          const Text(
            'At LifeCard SOS, your medical data belongs to you. We\'ve built our platform to be as private as a sealed envelope.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.4),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
          const SizedBox(height: 24),
          
          // Cards for privacy points
          _buildInfoCard(
            icon: Icons.wifi_off,
            color: AppColors.primaryRed,
            title: 'Offline First',
            description: 'Your life-saving information is stored directly on your device. It\'s accessible even without an internet connection.',
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.visibility_off,
            color: AppColors.phoneOrange,
            title: 'No Tracking',
            description: 'We don\'t use cookies, analytics, or trackers. Your movements and medical lookups are never recorded or shared.',
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.lock,
            color: AppColors.cameraGreen,
            title: 'Encrypted Storage',
            description: 'Data is protected by secure encryption on your device.',
          ),
          
          const SizedBox(height: 32),
          const Text(
            'By continuing, you agree to our Privacy Policy and Terms of Service. LifeCard SOS does not store your private keys on our servers.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.3),
          ),
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'I Understand & Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0x112196F3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.gpp_good,
              size: 40,
              color: AppColors.locationBlue,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Life-Saving Access',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 8),
          const Text(
            'We need these permissions to protect you in an emergency.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.4),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
          const SizedBox(height: 24),

          // Permissions toggles
          Expanded(
            child: ListView(
              children: [
                _buildPermissionToggle(
                  icon: Icons.location_on,
                  color: AppColors.locationBlue,
                  title: 'Location',
                  description: 'Allows emergency responders to pinpoint your exact coordinates.',
                  value: _locationGranted,
                  onChanged: (val) async {
                    final status = await Permission.location.request();
                    setState(() => _locationGranted = status.isGranted);
                  },
                ),

                const SizedBox(height: 12),
                _buildPermissionToggle(
                  icon: Icons.phone_android,
                  color: AppColors.phoneOrange,
                  title: 'Phone & SMS',
                  description: 'Enables automatically texting emergency contacts when SOS is triggered.',
                  value: _smsGranted,
                  onChanged: (val) async {
                    final statusSms = await Permission.sms.request();
                    final statusPhone = await Permission.phone.request();
                    setState(() => _smsGranted = statusSms.isGranted && statusPhone.isGranted);
                  },
                ),
                const SizedBox(height: 12),
                _buildPermissionToggle(
                  icon: Icons.notifications_active,
                  color: AppColors.vitalCyan,
                  title: 'Vital Statistics / Notifications',
                  description: 'Used for showing active cards on the lock screen lock and persistent statuses.',
                  value: _vitalsGranted,
                  onChanged: (val) async {
                    final status = await Permission.notification.request();
                    setState(() => _vitalsGranted = status.isGranted);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Text(
            'You can change these anytime in Settings.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: _requestPermissions,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Grant Permissions & Finish',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionToggle({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.3),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: AppColors.primaryRed,
            ),
          ],
        ),
      ),
    );
  }
}
