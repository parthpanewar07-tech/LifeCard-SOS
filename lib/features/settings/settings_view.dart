import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/app_settings.dart';
import '../../shared/providers.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  void _showThemeDialog(AppSettings settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme Mode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(settings, 'system', 'System Default'),
            _buildThemeOption(settings, 'light', 'Light Mode'),
            _buildThemeOption(settings, 'dark', 'Dark Mode'),
            _buildThemeOption(settings, 'amoled', 'AMOLED Pure Black'),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    AppSettings settings,
    String value,
    String label,
  ) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: settings.themeMode,
      onChanged: (val) {
        if (val != null) {
          ref.read(settingsProvider.notifier).updateSettings(
                settings.copyWith(themeMode: val),
              );
          Navigator.pop(context);
        }
      },
    );
  }

  void _showCountdownDialog(AppSettings settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SOS Countdown Duration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCountdownOption(settings, 1, '1 Seconds'),
            _buildCountdownOption(settings, 3, '3 Seconds'),
            _buildCountdownOption(settings, 5, '5 Seconds'),
            _buildCountdownOption(settings, 10, '10 Seconds'),
            _buildCountdownOption(settings, 15, '15 Seconds'),
            _buildCountdownOption(settings, 30, '30 Seconds'),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownOption(
    AppSettings settings,
    int value,
    String label,
  ) {
    return RadioListTile<int>(
      title: Text(label),
      value: value,
      groupValue: settings.sosCountdownSeconds,
      onChanged: (val) {
        if (val != null) {
          ref.read(settingsProvider.notifier).updateSettings(
                settings.copyWith(sosCountdownSeconds: val),
              );
          Navigator.pop(context);
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    return settingsAsync.when(
      data: (settings) => Scaffold(
        backgroundColor: context.colorScheme.background,
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          children: [
            // PROFILE & SECURITY
            _buildSectionHeader('PROFILE'),
            _buildSettingTile(
              icon: Icons.person,
              color: AppColors.primaryRed,
              title: 'Personal Profile',
              subtitle: 'Medical ID & Basic Info',
              onTap: () => context.push('/profile/edit'),
            ),

            // EMERGENCY PREFERENCES
            const SizedBox(height: 16),
            _buildSectionHeader('EMERGENCY PREFERENCES'),
            _buildSettingTile(
              icon: Icons.timer,
              color: AppColors.phoneOrange,
              title: 'SOS Countdown',
              subtitle: 'Set to ${settings.sosCountdownSeconds} seconds',
              onTap: () => _showCountdownDialog(settings),
            ),
            _buildSettingTile(
              icon: Icons.lock,
              color: AppColors.phoneOrange,
              title: 'Lock Screen Access',
              subtitle: settings.showOnLockScreen ? 'Visible during emergency' : 'Hidden during lock',
              onTap: () {
                ref.read(settingsProvider.notifier).updateSettings(
                      settings.copyWith(showOnLockScreen: !settings.showOnLockScreen),
                    );
              },
            ),
            _buildSettingTile(
              icon: Icons.dashboard_rounded,
              color: AppColors.phoneOrange,
              title: 'Widget Settings',
              subtitle: 'Home screen SOS triggers',
              onTap: () {},
            ),


            // APP PREFERENCES
            const SizedBox(height: 16),
            _buildSectionHeader('APP PREFERENCES'),
            _buildSettingTile(
              icon: Icons.palette_rounded,
              color: AppColors.locationBlue,
              title: 'Theme',
              subtitle: settings.themeMode == 'system'
                  ? 'System Default'
                  : (settings.themeMode == 'light'
                      ? 'Light Mode'
                      : (settings.themeMode == 'dark' ? 'Dark Mode' : 'AMOLED Pure Black')),
              onTap: () => _showThemeDialog(settings),
            ),
            _buildSettingTile(
              icon: Icons.language_rounded,
              color: AppColors.locationBlue,
              title: 'Language',
              subtitle: settings.languageCode == 'en' ? 'English (US)' : 'Hindi',
              onTap: () {
                final nextLang = settings.languageCode == 'en' ? 'hi' : 'en';
                ref.read(settingsProvider.notifier).updateSettings(
                      settings.copyWith(languageCode: nextLang),
                    );
              },
            ),
            _buildSettingTileWithSwitch(
              icon: Icons.notifications_active,
              color: AppColors.locationBlue,
              title: 'Notifications',
              subtitle: 'Persistent active notification',
              value: settings.persistentNotificationEnabled,
              onChanged: (val) {
                ref.read(settingsProvider.notifier).updateSettings(
                      settings.copyWith(persistentNotificationEnabled: val),
                    );
              },
            ),

            // Footer Text
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  const Text(
                    'LIFECARD SOS',
                    style: TextStyle(
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0 (Build 100)',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Scaffold(body: Center(child: Text('Error loading settings'))),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0, top: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.colorScheme.onSurface)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  Widget _buildSettingTileWithSwitch({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.colorScheme.onSurface)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryRed,
        ),
      ),
    );
  }


}
