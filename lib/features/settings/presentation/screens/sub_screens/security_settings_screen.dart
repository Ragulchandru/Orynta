// lib/features/settings/presentation/screens/sub_screens/security_settings_screen.dart
//
// Orynta 2.0 — Privacy & Security Settings Screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/design_system/design_system.dart';
import '../../../../auth/presentation/providers/app_lock_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/settings_widgets.dart';

class SecuritySettingsScreen extends ConsumerWidget {
  const SecuritySettingsScreen({super.key});

  void _showSetPinDialog(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final pinController = TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: theme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: theme.outlineVariant, width: 1.0),
              ),
              title: Text(
                'Set 4-Digit App Lock PIN',
                style: context.typography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: pinController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 4,
                    autofocus: true,
                    style: TextStyle(
                      letterSpacing: 8,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: '••••',
                      errorText: errorMessage,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final pin = pinController.text.trim();
                    if (pin.length != 4) {
                      setState(() {
                        errorMessage = 'PIN must be 4 digits';
                      });
                      return;
                    }
                    await ref.read(appLockStateProvider.notifier).enableAppLock(pin);
                    await ref.read(settingsStateProvider.notifier).updateAppLockEnabled(true);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('App Lock PIN Enabled Successfully!')),
                      );
                    }
                  },
                  child: const Text('Save PIN'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsStateProvider);
    final settingsNotifier = ref.read(settingsStateProvider.notifier);
    final appLockState = ref.watch(appLockStateProvider);
    final theme = context.appTheme;

    return Scaffold(
      backgroundColor: theme.surfaceDim,
      appBar: AppBar(
        backgroundColor: theme.surface,
        title: Text(
          'Privacy & Security',
          style: context.typography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.isDark ? const Color(0xFFEFEFF8) : const Color(0xFF11111C),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          physics: const BouncingScrollPhysics(),
          children: [
            PremiumSection(
              title: 'APPLICATION LOCK',
              children: [
                PremiumListTile(
                  title: 'App Lock Screen',
                  subtitle: settings.appLockEnabled
                      ? 'PIN Lock Active (Guarded on Launch & Resume)'
                      : 'Disabled',
                  icon: Icons.lock_outline_rounded,
                  iconColor: settings.appLockEnabled ? Colors.green : Colors.orange,
                  trailing: PremiumSwitch(
                    value: settings.appLockEnabled,
                    onChanged: (val) async {
                      if (val) {
                        _showSetPinDialog(context, ref);
                      } else {
                        await ref.read(appLockStateProvider.notifier).disableAppLock();
                        await settingsNotifier.updateAppLockEnabled(false);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('App Lock Disabled')),
                          );
                        }
                      }
                    },
                  ),
                ),
                if (settings.appLockEnabled) ...[
                  PremiumListTile(
                    title: 'Biometric Authentication',
                    subtitle: appLockState.isBiometricsSupported
                        ? 'Unlock with Fingerprint / Face ID'
                        : 'Biometrics unavailable on this device',
                    icon: Icons.fingerprint_rounded,
                    iconColor: Colors.blue,
                    trailing: PremiumSwitch(
                      value: settings.biometricsEnabled && appLockState.isBiometricsSupported,
                      onChanged: appLockState.isBiometricsSupported
                          ? (val) async {
                              await ref.read(appLockStateProvider.notifier).setBiometricsEnabled(val);
                              await settingsNotifier.updateBiometricsEnabled(val);
                            }
                          : null,
                    ),
                  ),
                  PremiumListTile(
                    title: 'Change App Lock PIN',
                    subtitle: 'Update your 4-digit security code',
                    icon: Icons.key_rounded,
                    iconColor: Colors.purple,
                    onTap: () => _showSetPinDialog(context, ref),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
