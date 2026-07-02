// lib/features/auth/presentation/screens/lock_screen.dart
//
// LockScreen — Premium screen for authentication (PIN + Biometrics).
//
// Design: Apple-like glassmorphic backdrop, clean keyboard, and smooth micro-animations.
// Support modes:
//   1. unlock — standard app guard on startup or resume.
//   2. setup — enabling app lock for the first time.
//   3. confirmSetup — verifying the newly entered PIN.
//   4. verifyCurrent — confirming PIN before changing or removing it.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../providers/app_lock_provider.dart';

enum LockScreenMode {
  unlock,
  setup,
  confirmSetup,
  verifyCurrent,
}

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({
    super.key,
    this.mode = LockScreenMode.unlock,
    this.setupPinLength = 4,
    this.tempPin = '',
    this.redirectUri = '/',
    this.onVerified,
  });

  final LockScreenMode mode;
  final int setupPinLength;
  final String tempPin;
  final String redirectUri;
  final ValueChanged<String>? onVerified;

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  String _inputPin = '';
  int _pinLength = 4;
  bool _isError = false;
  int _shakeCount = 0;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _pinLength = widget.mode == LockScreenMode.unlock || widget.mode == LockScreenMode.verifyCurrent
        ? 4 // Will adjust based on stored PIN or state later
        : widget.setupPinLength;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkStoredPinLength();
      _triggerBiometricsIfNeeded();
    });
  }

  Future<void> _checkStoredPinLength() async {
    if (widget.mode == LockScreenMode.unlock || widget.mode == LockScreenMode.verifyCurrent) {
      final len = await ref.read(appLockRepositoryProvider).getPinLength();
      if (mounted) {
        setState(() {
          _pinLength = len;
        });
      }
    }
  }

  Future<void> _triggerBiometricsIfNeeded() async {
    if (widget.mode == LockScreenMode.unlock) {
      final lockState = ref.read(appLockStateProvider);
      if (lockState.isBiometricsEnabled && lockState.isBiometricsSupported) {
        final success = await ref.read(appLockStateProvider.notifier).authenticateWithBiometrics();
        if (success) {
          setState(() => _isSuccess = true);
          await Future.delayed(const Duration(milliseconds: 300));
          if (mounted) {
            context.go(widget.redirectUri);
          }
        }
      }
    }
  }

  void _onKeyPress(String val) {
    if (_isSuccess || _isError) return;

    setState(() {
      if (_inputPin.length < _pinLength) {
        _inputPin += val;
      }
    });

    if (_inputPin.length == _pinLength) {
      _verifyInput();
    }
  }

  void _onBackspace() {
    if (_inputPin.isEmpty || _isSuccess || _isError) return;
    setState(() {
      _inputPin = _inputPin.substring(0, _inputPin.length - 1);
    });
  }

  Future<void> _verifyInput() async {
    if (widget.mode == LockScreenMode.setup) {
      final pin = _inputPin;
      setState(() => _isSuccess = true);
      await Future.delayed(const Duration(milliseconds: 250));
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LockScreen(
              mode: LockScreenMode.confirmSetup,
              setupPinLength: _pinLength,
              tempPin: pin,
              redirectUri: widget.redirectUri,
              onVerified: widget.onVerified,
            ),
          ),
        );
      }
    } else if (widget.mode == LockScreenMode.confirmSetup) {
      if (_inputPin == widget.tempPin) {
        setState(() => _isSuccess = true);
        await Future.delayed(const Duration(milliseconds: 250));
        if (widget.onVerified != null) {
          widget.onVerified!(_inputPin);
        }
      } else {
        _triggerError();
      }
    } else if (widget.mode == LockScreenMode.unlock) {
      final success = await ref.read(appLockStateProvider.notifier).verifyPin(_inputPin);
      if (success) {
        setState(() => _isSuccess = true);
        await Future.delayed(const Duration(milliseconds: 250));
        if (mounted) {
          context.go(widget.redirectUri);
        }
      } else {
        _triggerError();
      }
    } else if (widget.mode == LockScreenMode.verifyCurrent) {
      final isValid = await ref.read(appLockRepositoryProvider).verifyPin(_inputPin);
      if (isValid) {
        setState(() => _isSuccess = true);
        await Future.delayed(const Duration(milliseconds: 250));
        if (mounted) {
          if (widget.onVerified != null) {
            widget.onVerified!(_inputPin);
          } else {
            Navigator.of(context).pop(true);
          }
        }
      } else {
        _triggerError();
      }
    }
  }

  void _triggerError() {
    setState(() {
      _isError = true;
      _shakeCount++;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _inputPin = '';
          _isError = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final title = switch (widget.mode) {
      LockScreenMode.unlock => 'Welcome Back',
      LockScreenMode.setup => 'Create PIN',
      LockScreenMode.confirmSetup => 'Confirm PIN',
      LockScreenMode.verifyCurrent => 'Enter Current PIN',
    };

    final subtitle = switch (widget.mode) {
      LockScreenMode.unlock => 'Enter security PIN to access your notes',
      LockScreenMode.setup => 'Choose a secure PIN to lock Orynta',
      LockScreenMode.confirmSetup => 'Re-enter your PIN to verify',
      LockScreenMode.verifyCurrent => 'Verify identity to change settings',
    };

    return PopScope(
      canPop: widget.mode != LockScreenMode.unlock,
      child: Scaffold(
        extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: widget.mode != LockScreenMode.unlock
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          : null,
      body: Stack(
        children: [
          // ── Background Wallpaper Backdrop ────────────────────────────────
          Container(
            color: isDark ? Colors.black : Colors.white,
          ),

          // ── Frosted Overlay ──────────────────────────────────────────────
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: (isDark
                        ? Colors.black.withValues(alpha: 0.7)
                        : Colors.white.withValues(alpha: 0.85))
                    .withValues(alpha: 0.9),
              ),
            ),
          ),

          // ── Core Layout ──────────────────────────────────────────────────
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),

                      // Lock Icon / Success Check
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(AppSizes.md),
                        decoration: BoxDecoration(
                          color: _isSuccess
                              ? theme.colorScheme.primaryContainer
                              : (_isError
                                  ? theme.colorScheme.errorContainer
                                  : theme.colorScheme.surfaceContainerHigh),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isSuccess
                              ? Icons.lock_open_rounded
                              : (_isError
                                  ? Icons.lock_rounded
                                  : Icons.lock_outline_rounded),
                          size: 40,
                          color: _isSuccess
                              ? theme.colorScheme.onPrimaryContainer
                              : (_isError
                                  ? theme.colorScheme.onErrorContainer
                                  : theme.colorScheme.primary),
                        ),
                      )
                          .animate(target: _shakeCount.toDouble())
                          .shake(duration: 400.ms, curve: Curves.easeInOut),

                      const SizedBox(height: AppSizes.lg),

                      // Title
                      Text(
                        title,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: AppSizes.xs),

                      // Subtitle
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: AppSizes.xl),

                      // Length Selector in Setup Mode
                      if (widget.mode == LockScreenMode.setup) ...[
                        SegmentedButton<int>(
                          segments: const [
                            ButtonSegment(value: 4, label: Text('4 Digits')),
                            ButtonSegment(value: 6, label: Text('6 Digits')),
                          ],
                          selected: {_pinLength},
                          showSelectedIcon: false,
                          onSelectionChanged: (set) {
                            setState(() {
                              _pinLength = set.first;
                              _inputPin = '';
                            });
                          },
                        ),
                        const SizedBox(height: AppSizes.xl),
                      ],

                      // PIN Indicators / Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pinLength,
                          (index) {
                            final isFilled = index < _inputPin.length;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isSuccess
                                    ? theme.colorScheme.primary
                                    : (_isError
                                        ? theme.colorScheme.error
                                        : (isFilled
                                            ? theme.colorScheme.onSurface
                                            : theme.colorScheme.outlineVariant)),
                              ),
                            );
                          },
                        ),
                      )
                          .animate(target: _shakeCount.toDouble())
                          .shake(duration: 400.ms, curve: Curves.easeInOut),

                      const Spacer(),

                      // Keyboard / Grid
                      _buildKeyboard(theme),

                      const SizedBox(height: AppSizes.xxl),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),);
  }

  Widget _buildKeyboard(ThemeData theme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKey('1'),
            _buildKey('2'),
            _buildKey('3'),
          ],
        ),
        const SizedBox(height: AppSizes.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKey('4'),
            _buildKey('5'),
            _buildKey('6'),
          ],
        ),
        const SizedBox(height: AppSizes.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKey('7'),
            _buildKey('8'),
            _buildKey('9'),
          ],
        ),
        const SizedBox(height: AppSizes.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Left Action: Biometrics (only in unlock mode if enabled)
            _buildLeftActionKey(),
            _buildKey('0'),
            // Right Action: Backspace
            _buildBackspaceKey(theme),
          ],
        ),
      ],
    );
  }

  Widget _buildKey(String value) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onKeyPress(value),
        customBorder: const CircleBorder(),
        child: Ink(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
          ),
          child: Center(
            child: Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeftActionKey() {
    final theme = Theme.of(context);
    final lockState = ref.watch(appLockStateProvider);

    final showBiometrics = widget.mode == LockScreenMode.unlock &&
        lockState.isBiometricsEnabled &&
        lockState.isBiometricsSupported;

    if (!showBiometrics) {
      return const SizedBox(width: 72, height: 72);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _triggerBiometricsIfNeeded,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 72,
          height: 72,
          child: Icon(
            Icons.fingerprint_rounded,
            size: 32,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceKey(ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onBackspace,
        onLongPress: () => setState(() => _inputPin = ''),
        customBorder: const CircleBorder(),
        child: Ink(
          width: 72,
          height: 72,
          child: Icon(
            Icons.backspace_outlined,
            size: 24,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
