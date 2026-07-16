import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/providers.dart';

class MedicalView extends ConsumerStatefulWidget {
  const MedicalView({super.key});

  @override
  ConsumerState<MedicalView> createState() => _MedicalViewState();
}

class _MedicalViewState extends ConsumerState<MedicalView> {
  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final medicalAsync = ref.watch(medicalProfileProvider);
    return Scaffold(
      backgroundColor: context.colorScheme.background,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: profileAsync.when(
            data: (profile) => CircleAvatar(
              backgroundColor: context.colorScheme.surface,
              backgroundImage: profile.photoPath.isNotEmpty && File(profile.photoPath).existsSync()
                  ? FileImage(File(profile.photoPath))
                  : null,
              child: profile.photoPath.isEmpty || !File(profile.photoPath).existsSync()
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            ),
            loading: () => const CircleAvatar(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, __) => const CircleAvatar(
              child: Icon(Icons.person, color: Colors.grey),
            ),
          ),
        ),
        title: const Text('LifeCard SOS'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            // User Avatar Section
            profileAsync.when(
              data: (profile) => Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: context.colorScheme.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.colorScheme.surface,
                            width: 4,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x11000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: profile.photoPath.isNotEmpty && File(profile.photoPath).existsSync()
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  File(profile.photoPath),
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              )
                            : const Center(
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.primaryRed,
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              size: 14,
                              color: Colors.white,
                            ),
                            onPressed: () => context.push('/profile/edit'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile.fullName.isEmpty ? 'Username' : profile.fullName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Guest'),
            ),
            const SizedBox(height: 24),

            // Blood Group & Critical Note side-by-side
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: profileAsync.when(
                    data: (profile) => _buildSummaryCard(
                      context: context,
                      title: 'BLOOD GROUP',
                      value: profile.bloodGroup.isEmpty
                          ? 'Unknown'
                          : profile.bloodGroup,
                      isRedValue: !profile.bloodGroup.isEmpty,
                      icon: Icons.bloodtype,
                      iconColor: profile.bloodGroup.isEmpty
                          ? Colors.grey
                          : AppColors.primaryRed,
                    ),
                    loading: () => const SizedBox(height: 120),
                    error: (_, __) => const SizedBox(height: 120),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: medicalAsync.when(
                    data: (med) => _buildSummaryCard(
                      context: context,
                      title: 'CRITICAL NOTE',
                      value: med.emergencyNotes.isEmpty
                          ? 'None'
                          : med.emergencyNotes,
                      isRedValue: false,
                      icon: Icons.warning_amber_rounded,
                      iconColor: Colors.amber,
                      isItalic: med.emergencyNotes.isEmpty,
                    ),
                    loading: () => const SizedBox(height: 120),
                    error: (_, __) => const SizedBox(height: 120),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),
            const SizedBox(height: 16),

            // Medical Profile Fields List
            medicalAsync.when(
              data: (med) => Column(
                children: [
                  _buildSectionCard(
                    context: context,
                    icon: Icons.personal_injury_rounded,
                    color: AppColors.primaryRed,
                    title: 'Medical Conditions',
                    items: med.medicalConditions.isEmpty
                        ? ['None Specified']
                        : med.medicalConditions,
                  ),
                  const SizedBox(height: 12),
                  _buildSectionCard(
                    context: context,
                    icon: Icons.vaccines_rounded,
                    color: AppColors.cameraGreen,
                    title: 'Allergies (Food & Medicine)',
                    items: med.allergies.isEmpty
                        ? ['None Specified']
                        : med.allergies,
                  ),
                  const SizedBox(height: 12),
                  _buildSectionCard(
                    context: context,
                    icon: Icons.medication_liquid_rounded,
                    color: AppColors.phoneOrange,
                    title: 'Current Medications',
                    items: med.currentMedicines.isEmpty
                        ? ['None Specified']
                        : med.currentMedicines,
                  ),
                  const SizedBox(height: 12),
                  _buildSectionCard(
                    context: context,
                    icon: Icons.local_hospital_rounded,
                    color: AppColors.locationBlue,
                    title: 'Preferred Primary Care',
                    items: [
                      'Doctor: ${med.doctorName.isEmpty ? "Not Specified" : med.doctorName}',
                      'Hospital: ${med.hospitalName.isEmpty ? "Not Specified" : med.hospitalName}',
                      'Insurance: ${med.insuranceProvider.isEmpty ? "Not Specified" : med.insuranceProvider}',
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.05, end: 0),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error loading medical profile'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/medical/edit'),
        backgroundColor: AppColors.locationBlue,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard({
    required BuildContext context,
    required String title,
    required String value,
    required bool isRedValue,
    required IconData icon,
    required Color iconColor,
    bool isItalic = false,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isRedValue ? AppColors.primaryRed : Colors.grey,
                  ),
                ),
                Icon(icon, color: iconColor, size: 16),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isRedValue
                    ? AppColors.primaryRed
                    : context.colorScheme.onSurface,
                fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required List<String> items,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0, left: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 13,
                          color: context.colorScheme.onSurface.withOpacity(0.8),
                          height: 1.3,
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
    );
  }
}
