import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/providers.dart';

// Subviews
import 'dashboard_view.dart';
import '../medical/medical_view.dart';
import '../contacts/contacts_view.dart';
import '../settings/settings_view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentTab = 0;

  final List<Widget> _views = [
    const DashboardView(),
    const MedicalView(),
    const ContactsView(),
    const SettingsView(),
  ];

  @override
  void initState() {
    super.initState();
    // Enable background status notification
    ref.read(settingsProvider).whenData((settings) {
      if (settings.persistentNotificationEnabled) {
        // Trigger background notification service
        // NotificationService.showPersistentNotification();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: IndexedStack(
          index: _currentTab,
          children: _views,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: context.colorScheme.surface,
        elevation: 10,
        height: 72,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home Tab
            _buildTabItem(
              index: 0,
              icon: Icons.home_filled,
              label: 'Home',
            ),
            // Medical Tab
            _buildTabItem(
              index: 1,
              icon: Icons.medical_information,
              label: 'Medical',
            ),
            
            // Central SOS FAB Placeholder
            const SizedBox(width: 60),

            // Contacts Tab
            _buildTabItem(
              index: 2,
              icon: Icons.people_alt_rounded,
              label: 'Contacts',
            ),
            // Settings Tab
            _buildTabItem(
              index: 3,
              icon: Icons.settings_rounded,
              label: 'Settings',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: GestureDetector(
          onTap: () => context.push('/sos'),
          child: Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.primaryRed,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x66D32F2F),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                  spreadRadius: 2,
                )
              ],
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sensors_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                  SizedBox(height: 2),
                  Text(
                    'SOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isActive = _currentTab == index;
    final color = isActive ? AppColors.primaryRed : Colors.grey.shade400;

    return InkWell(
      onTap: () {
        setState(() {
          _currentTab = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
