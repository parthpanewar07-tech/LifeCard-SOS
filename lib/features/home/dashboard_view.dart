import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/providers.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  profileAsync.when(
                    data: (profile) => CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: profile.photoPath.isNotEmpty && File(profile.photoPath).existsSync()
                          ? FileImage(File(profile.photoPath))
                          : null,
                      child: profile.photoPath.isEmpty || !File(profile.photoPath).existsSync()
                          ? const Icon(Icons.person, color: Colors.grey)
                          : null,
                    ),
                    loading: () => const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    error: (_, __) => const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'LifeCard SOS',
                    style: TextStyle(
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star,
                  color: AppColors.primaryRed,
                  size: 20,
                ),
              )
            ],
          ),
          const SizedBox(height: 24),

          // Greeting
          const Text(
            'Good morning,',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.05, end: 0),
          profileAsync.when(
            data: (profile) => Text(
              profile.fullName.isEmpty ? '' : profile.fullName,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onBackground,
                height: 1.2,
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideX(begin: -0.05, end: 0),
            loading: () => const Text('Loading...'),
            error: (_, __) => const Text('Guest'),
          ),
          const SizedBox(height: 20),

          // Blood Group Card
          profileAsync.when(
            data: (profile) => Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Blood Group',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          profile.bloodGroup.isEmpty ? 'Not Specified' : profile.bloodGroup,
                          style: TextStyle(
                            fontSize: profile.bloodGroup.isEmpty ? 20 : 36,
                            color: profile.bloodGroup.isEmpty ? Colors.grey : AppColors.primaryRed,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.bloodtype_rounded,
                      color: AppColors.primaryRed,
                      size: 56,
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.05, end: 0),
            loading: () => const Card(child: SizedBox(height: 100)),
            error: (_, __) => const Card(child: SizedBox(height: 100)),
          ),
          const SizedBox(height: 24),

          // Quick Actions Section
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              _buildActionCard(
                icon: Icons.sensors_rounded,
                color: AppColors.primaryRed,
                title: 'Trigger SOS',
                onTap: () => context.push('/sos'),
                isFullWidth: true,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1.4,
                      child: _buildActionCard(
                        icon: Icons.edit_document,
                        color: AppColors.locationBlue,
                        title: 'Medical Card',
                        onTap: () => context.push('/medical_view'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1.4,
                      child: _buildActionCard(
                        icon: Icons.quick_contacts_dialer_rounded,
                        color: AppColors.phoneOrange,
                        title: 'Contacts',
                        onTap: () => context.push('/contacts_view'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.05, end: 0),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
    bool isFullWidth = false,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isFullWidth
              ? Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 22),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }


}
