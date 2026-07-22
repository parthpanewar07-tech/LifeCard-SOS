import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_profile.dart';
import '../../models/medical_profile.dart';
import '../../shared/providers.dart';

/// 5-Step First Time User Onboarding Flow
/// Step 1: Splash Screen
/// Step 2: Privacy Screen
/// Step 3: Access / Permissions Screen
/// Step 4: Profile Edit Screen
/// Step 5: Medical Edit Screen
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

  // Profile Form Controllers (Step 4)
  final _profileFormKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _nicknameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _profileNotesController;
  String _gender = 'Male';
  String _bloodGroup = 'Unknown';
  String _photoPath = '';

  // Medical Form Controllers (Step 5)
  final _medicalFormKey = GlobalKey<FormState>();
  late TextEditingController _conditionsController;
  late TextEditingController _allergiesController;
  late TextEditingController _medicinesController;
  late TextEditingController _disabilitiesController;
  late TextEditingController _bloodPressureController;
  late TextEditingController _medicalNotesController;

  String _rhFactor = 'Positive';
  bool _organDonor = false;
  bool _diabetes = false;
  bool _asthma = false;
  bool _heartDisease = false;
  bool _kidneyDisease = false;
  bool _cancer = false;
  bool _epilepsy = false;
  bool _pregnancy = false;

  @override
  void initState() {
    super.initState();
    // Initialize profile form defaults
    final profile = ref.read(profileProvider).value ?? const UserProfile();
    _photoPath = profile.photoPath;
    _nameController = TextEditingController(text: profile.fullName);
    _nicknameController = TextEditingController(text: profile.nickname);
    _heightController = TextEditingController(text: profile.height > 0 ? profile.height.toString() : '');
    _weightController = TextEditingController(text: profile.weight > 0 ? profile.weight.toString() : '');
    _profileNotesController = TextEditingController(text: profile.emergencyNotes);
    if (profile.gender.isNotEmpty) _gender = profile.gender;
    if (profile.bloodGroup.isNotEmpty) _bloodGroup = profile.bloodGroup;

    // Initialize medical profile form defaults
    final med = ref.read(medicalProfileProvider).value ?? const MedicalProfile();
    _conditionsController = TextEditingController(text: med.medicalConditions.join(', '));
    _allergiesController = TextEditingController(text: med.allergies.join(', '));
    _medicinesController = TextEditingController(text: med.currentMedicines.join(', '));
    _disabilitiesController = TextEditingController(text: med.disabilities.join(', '));
    _bloodPressureController = TextEditingController(text: med.bloodPressure);
    _medicalNotesController = TextEditingController(text: med.emergencyNotes);

    _organDonor = med.organDonor;
    _diabetes = med.diabetes;
    _asthma = med.asthma;
    _heartDisease = med.heartDisease;
    _kidneyDisease = med.kidneyDisease;
    _cancer = med.cancer;
    _epilepsy = med.epilepsy;
    _pregnancy = med.pregnancy;
    if (med.rhFactor.isNotEmpty) _rhFactor = med.rhFactor;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _nicknameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _profileNotesController.dispose();

    _conditionsController.dispose();
    _allergiesController.dispose();
    _medicinesController.dispose();
    _disabilitiesController.dispose();
    _bloodPressureController.dispose();
    _medicalNotesController.dispose();
    super.dispose();
  }

  List<String> _parseCsv(String text) {
    if (text.isEmpty) return [];
    return text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
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

    _goToNextPage();
  }

  Future<void> _saveProfileStep() async {
    if (!_profileFormKey.currentState!.validate()) return;

    final current = ref.read(profileProvider).value ?? const UserProfile();
    final updated = current.copyWith(
      photoPath: _photoPath,
      fullName: _nameController.text.trim(),
      nickname: _nicknameController.text.trim(),
      gender: _gender,
      bloodGroup: _bloodGroup == 'Unknown' ? '' : _bloodGroup,
      height: double.tryParse(_heightController.text) ?? 0.0,
      weight: double.tryParse(_weightController.text) ?? 0.0,
      emergencyNotes: _profileNotesController.text.trim(),
    );

    await ref.read(profileProvider.notifier).updateProfile(updated);
    _goToNextPage();
  }

  Future<void> _saveMedicalStepAndFinish() async {
    if (!_medicalFormKey.currentState!.validate()) return;
    final router = GoRouter.of(context);

    final currentMed = ref.read(medicalProfileProvider).value ?? const MedicalProfile();
    final updatedMed = currentMed.copyWith(
      rhFactor: _rhFactor,
      medicalConditions: _parseCsv(_conditionsController.text),
      allergies: _parseCsv(_allergiesController.text),
      currentMedicines: _parseCsv(_medicinesController.text),
      disabilities: _parseCsv(_disabilitiesController.text),
      organDonor: _organDonor,
      bloodPressure: _bloodPressureController.text.trim(),
      diabetes: _diabetes,
      asthma: _asthma,
      heartDisease: _heartDisease,
      kidneyDisease: _kidneyDisease,
      cancer: _cancer,
      epilepsy: _epilepsy,
      pregnancy: _pregnancy,
      emergencyNotes: _medicalNotesController.text.trim(),
    );

    await ref.read(medicalProfileProvider.notifier).updateMedicalProfile(updatedMed);
    await ref.read(settingsProvider.notifier).completeSetup();
    router.go('/');
  }

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar & Step Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'LifeCard SOS',
                        style: TextStyle(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Step ${_currentPage + 1} of 5',
                        style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if (_currentPage < 4)
                    TextButton(
                      onPressed: () async {
                        final router = GoRouter.of(context);
                        await ref.read(settingsProvider.notifier).completeSetup();
                        router.go('/');
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
            
            // Step Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: LinearProgressIndicator(
                value: (_currentPage + 1) / 5.0,
                backgroundColor: context.colorScheme.onSurface.withValues(alpha: 0.1),
                color: AppColors.primaryRed,
                minHeight: 4,
                borderRadius: BorderRadius.circular(2),
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
                physics: const NeverScrollableScrollPhysics(), // Force navigation via step buttons
                children: [
                  _buildSplashPage(),
                  _buildPrivacyPage(),
                  _buildPermissionsPage(),
                  _buildProfileOnboardingPage(),
                  _buildMedicalOnboardingPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // SCREEN 1: Splash Screen
  Widget _buildSplashPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            width: 130,
            height: 130,
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
                Icons.medical_services_rounded,
                size: 64,
                color: AppColors.primaryRed,
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
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
            'PERSONAL HEALTH VAULT & SOS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              letterSpacing: 2.0,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideY(begin: 0.1, end: 0),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: _goToNextPage,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  // SCREEN 2: Privacy Screen
  Widget _buildPrivacyPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0x114CAF50),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield_rounded, size: 36, color: AppColors.activeGreen),
          ),
          const SizedBox(height: 16),
          Text(
            'Privacy is a Right',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 8),
          const Text(
            'Your medical details are stored securely on your device. Zero tracking, offline first.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
          const SizedBox(height: 20),
          
          _buildInfoCard(
            icon: Icons.wifi_off_rounded,
            color: AppColors.primaryRed,
            title: 'Offline First',
            description: 'Your life-saving medical data is accessible even without active internet.',
          ),
          const SizedBox(height: 10),
          _buildInfoCard(
            icon: Icons.visibility_off_rounded,
            color: AppColors.phoneOrange,
            title: 'Zero Tracking',
            description: 'No cookies or user tracking. Your profile belongs strictly to you.',
          ),
          const SizedBox(height: 10),
          _buildInfoCard(
            icon: Icons.lock_rounded,
            color: AppColors.cameraGreen,
            title: 'Encrypted Local Storage',
            description: 'Protected by local device security and encryption.',
          ),
          
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              onPressed: _goToNextPage,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('I Understand & Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SCREEN 3: Access / Permissions Screen
  Widget _buildPermissionsPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0x112196F3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.gpp_good_rounded, size: 36, color: AppColors.locationBlue),
          ),
          const SizedBox(height: 16),
          Text(
            'Life-Saving Access',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 8),
          const Text(
            'We require these permissions to locate and alert responders during emergencies.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              children: [
                _buildPermissionToggle(
                  icon: Icons.location_on_rounded,
                  color: AppColors.locationBlue,
                  title: 'Location Access',
                  description: 'Allows sharing precise GPS coordinates during emergency broadcasts.',
                  value: _locationGranted,
                  onChanged: (val) async {
                    final status = await Permission.location.request();
                    setState(() => _locationGranted = status.isGranted);
                  },
                ),
                const SizedBox(height: 10),
                _buildPermissionToggle(
                  icon: Icons.phone_android_rounded,
                  color: AppColors.phoneOrange,
                  title: 'Phone & SMS',
                  description: 'Enables sending direct emergency SMS alerts to chosen contacts.',
                  value: _smsGranted,
                  onChanged: (val) async {
                    final statusSms = await Permission.sms.request();
                    final statusPhone = await Permission.phone.request();
                    setState(() => _smsGranted = statusSms.isGranted && statusPhone.isGranted);
                  },
                ),
                const SizedBox(height: 10),
                _buildPermissionToggle(
                  icon: Icons.notifications_active_rounded,
                  color: AppColors.vitalCyan,
                  title: 'Notifications',
                  description: 'Shows active emergency alerts and lock screen emergency cards.',
                  value: _vitalsGranted,
                  onChanged: (val) async {
                    final status = await Permission.notification.request();
                    setState(() => _vitalsGranted = status.isGranted);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              onPressed: _requestPermissions,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text(
                'Grant & Continue to Profile',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SCREEN 4: Profile Edit Screen
  Widget _buildProfileOnboardingPage() {
    return Form(
      key: _profileFormKey,
      child: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Text(
            'Personal Profile Setup',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Enter your basic emergency details for your LifeCard ID.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Photo picker
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 46,
                  backgroundColor: context.colorScheme.surface,
                  backgroundImage: _photoPath.isNotEmpty && File(_photoPath).existsSync()
                      ? FileImage(File(_photoPath))
                      : null,
                  child: _photoPath.isEmpty || !File(_photoPath).existsSync()
                      ? const Icon(Icons.person, size: 46, color: Colors.grey)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.primaryRed,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                      onPressed: _pickProfilePhoto,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _buildTextField(_nameController, 'Full Name *', validator: (v) => v!.isEmpty ? 'Name is required' : null),
          const SizedBox(height: 10),
          _buildTextField(_nicknameController, 'Nickname'),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: 'Gender',
                  value: _gender,
                  items: ['Male', 'Female', 'Other'],
                  onChanged: (val) => setState(() => _gender = val!),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildDropdownField(
                  label: 'Blood Group',
                  value: _bloodGroup,
                  items: ['Unknown', 'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
                  onChanged: (val) => setState(() => _bloodGroup = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _buildTextField(_heightController, 'Height (cm)', keyboardType: TextInputType.number),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildTextField(_weightController, 'Weight (kg)', keyboardType: TextInputType.number),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildTextField(_profileNotesController, 'Emergency Profile Note', maxLines: 2),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              onPressed: _saveProfileStep,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Save & Continue to Medical Setup', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SCREEN 5: Medical Edit Screen
  Widget _buildMedicalOnboardingPage() {
    return Form(
      key: _medicalFormKey,
      child: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Text(
            'Medical Profile Setup',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Configure known medical conditions and critical health statuses.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          _buildDropdownField(
            label: 'RH Factor',
            value: _rhFactor,
            items: ['Positive', 'Negative', 'Not Specified'],
            onChanged: (val) => setState(() => _rhFactor = val!),
          ),
          const SizedBox(height: 10),

          _buildTextField(_conditionsController, 'Medical Conditions (comma separated)', maxLines: 2),
          const SizedBox(height: 10),
          _buildTextField(_allergiesController, 'Allergies (comma separated)', maxLines: 2),
          const SizedBox(height: 10),
          _buildTextField(_medicinesController, 'Current Medications (comma separated)', maxLines: 2),
          const SizedBox(height: 10),
          _buildTextField(_disabilitiesController, 'Disabilities (comma separated)'),
          const SizedBox(height: 10),
          _buildTextField(_bloodPressureController, 'Usual Blood Pressure (e.g. 120/80)'),

          const Divider(height: 28),
          const Text('Known Illnesses / Statuses', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
          _buildSwitchTile('Asthma', _asthma, (val) => setState(() => _asthma = val)),
          _buildSwitchTile('Cancer', _cancer, (val) => setState(() => _cancer = val)),
          _buildSwitchTile('Diabetes', _diabetes, (val) => setState(() => _diabetes = val)),
          _buildSwitchTile('Epilepsy', _epilepsy, (val) => setState(() => _epilepsy = val)),
          _buildSwitchTile('Heart Disease', _heartDisease, (val) => setState(() => _heartDisease = val)),
          _buildSwitchTile('Kidney Disease', _kidneyDisease, (val) => setState(() => _kidneyDisease = val)),
          _buildSwitchTile('Pregnancy', _pregnancy, (val) => setState(() => _pregnancy = val)),
          _buildSwitchTile('Organ Donor', _organDonor, (val) => setState(() => _organDonor = val)),

          const SizedBox(height: 10),
          _buildTextField(_medicalNotesController, 'Critical Emergency Note', maxLines: 2),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              onPressed: _saveMedicalStepAndFinish,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Complete & Finish Setup', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Icon(Icons.check_circle_rounded, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Helper UI Widgets
  Widget _buildInfoCard({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
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
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.3),
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
        padding: const EdgeInsets.all(14.0),
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
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.3),
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

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 13),
        filled: true,
        fillColor: context.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.colorScheme.onSurface.withValues(alpha: 0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 13),
        filled: true,
        fillColor: context.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.colorScheme.onSurface.withValues(alpha: 0.12)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _buildSwitchTile(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.colorScheme.onSurface)),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primaryRed,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  Future<void> _pickProfilePhoto() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512, imageQuality: 85);
      if (pickedFile != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'onboarding_avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedFile = await File(pickedFile.path).copy('${appDir.path}/$fileName');
        setState(() {
          _photoPath = savedFile.path;
        });
      }
    } catch (_) {}
  }
}
