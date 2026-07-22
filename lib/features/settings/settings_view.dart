import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/app_settings.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/pin_dialog.dart';
import 'package:home_widget/home_widget.dart';

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
        content: RadioGroup<String>(
          groupValue: settings.themeMode,
          onChanged: (val) {
            if (val != null) {
              ref.read(settingsProvider.notifier).updateSettings(
                    settings.copyWith(themeMode: val),
                  );
              Navigator.pop(context);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeOption('system', 'System Default'),
              _buildThemeOption('light', 'Light Mode'),
              _buildThemeOption('dark', 'Dark Mode'),
              _buildThemeOption('amoled', 'AMOLED Pure Black'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    String value,
    String label,
  ) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
    );
  }

  void _showCountdownDialog(AppSettings settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SOS Countdown Duration'),
        content: RadioGroup<int>(
          groupValue: settings.sosCountdownSeconds,
          onChanged: (val) {
            if (val != null) {
              ref.read(settingsProvider.notifier).updateSettings(
                    settings.copyWith(sosCountdownSeconds: val),
                  );
              Navigator.pop(context);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCountdownOption(1, '1 Seconds'),
              _buildCountdownOption(3, '3 Seconds'),
              _buildCountdownOption(5, '5 Seconds'),
              _buildCountdownOption(10, '10 Seconds'),
              _buildCountdownOption(15, '15 Seconds'),
              _buildCountdownOption(30, '30 Seconds'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountdownOption(
    int value,
    String label,
  ) {
    return RadioListTile<int>(
      title: Text(label),
      value: value,
    );
  }


  Future<void> _pinSosWidget() async {
    try {
      final isSupported = await HomeWidget.isRequestPinWidgetSupported();
      if (isSupported == true) {
        await HomeWidget.requestPinWidget(
          qualifiedAndroidName: 'com.example.life_card_and_sos.SosWidgetProvider',
        );
      } else {
        if (mounted) {
          context.showSnackBar('Pinning widgets is not supported on this device/launcher.');
        }
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Could not pin widget: $e');
      }
    }
  }

  void _showWidgetSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.dashboard_rounded, color: AppColors.phoneOrange),
            SizedBox(width: 8),
            Text('Home Screen Widgets'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Trigger emergency SOS alerts or view your Medical Card directly from your mobile home screen using widgets or shortcuts.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              const Text(
                '1. Home Screen App Widget',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.phoneOrange),
              ),
              const SizedBox(height: 6),
              const Text(
                '• Go to your mobile Home Screen.\n'
                '• Long-press on any empty space.\n'
                '• Tap "Widgets" / "Add Widget".\n'
                '• Find "LifeCard SOS" and drag the circular "SOS" widget to your screen.',
                style: TextStyle(fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _pinSosWidget();
                },
                icon: const Icon(Icons.add_to_home_screen_rounded),
                label: const Text('Pin SOS Widget Automatically'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.phoneOrange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '2. Launcher Shortcuts',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.phoneOrange),
              ),
              const SizedBox(height: 6),
              const Text(
                '• Long-press the LifeCard SOS app icon.\n'
                '• You will see quick actions: "Trigger SOS" and "Medical Card".\n'
                '• Drag either option onto your home screen to create a dedicated shortcut icon.',
                style: TextStyle(fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it', style: TextStyle(color: AppColors.phoneOrange, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _manageSecurityPin(AppSettings settings) async {
    if (settings.pinCode.isNotEmpty) {
      final verified = await PinDialog.verifyPin(
        context,
        settings.pinCode,
        title: 'Current PIN Required',
        subtitle: 'Enter current 4-digit PIN to update security',
      );
      if (!verified) return;
    }
    if (!mounted) return;
    final newPin = await PinDialog.setupPin(
      context,
      existingPin: settings.pinCode,
    );
    if (newPin != null) {
      await ref.read(settingsProvider.notifier).updateSettings(
            settings.copyWith(pinCode: newPin),
          );
      if (mounted) {
        context.showSnackBar(
          newPin.isNotEmpty ? 'Security PIN saved successfully.' : 'Security PIN removed.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    return settingsAsync.when(
      data: (settings) => Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          children: [
            // PROFILE & SECURITY
            _buildSectionHeader('PROFILE & SECURITY'),
            _buildSettingTile(
              icon: Icons.person,
              color: AppColors.primaryRed,
              title: 'Personal Profile',
              subtitle: 'Medical ID & Basic Info',
              onTap: () => context.push('/profile/edit'),
            ),
            _buildSettingTile(
              icon: Icons.lock_outline_rounded,
              color: AppColors.primaryRed,
              title: 'Security PIN',
              subtitle: settings.pinCode.isNotEmpty
                  ? 'PIN Active (Protecting Profile & Medical Edit)'
                  : 'Not Set (Tap to protect Edit Profile & Medical screen)',
              onTap: () => _manageSecurityPin(settings),
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
            _buildSettingTileWithSwitch(
              icon: Icons.flashlight_on_rounded,
              color: AppColors.phoneOrange,
              title: 'Auto Flashlight on SOS',
              subtitle: 'Flash camera light when SOS is triggered',
              value: settings.autoFlashlightOnSos,
              onChanged: (val) {
                ref.read(settingsProvider.notifier).updateSettings(
                      settings.copyWith(autoFlashlightOnSos: val),
                    );
              },
            ),
            _buildSettingTileWithSwitch(
              icon: Icons.volume_up_rounded,
              color: AppColors.phoneOrange,
              title: 'Auto Siren Alarm on SOS',
              subtitle: 'Play loud siren alarm when SOS is triggered',
              value: settings.autoAlarmOnSos,
              onChanged: (val) {
                ref.read(settingsProvider.notifier).updateSettings(
                      settings.copyWith(autoAlarmOnSos: val),
                    );
              },
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
              onTap: _showWidgetSettingsDialog,
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
      error: (err, stack) => const Scaffold(body: Center(child: Text('Error loading settings'))),
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
            color: color.withValues(alpha: 0.1),
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
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.colorScheme.onSurface)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primaryRed,
        ),
      ),
    );
  }


}
