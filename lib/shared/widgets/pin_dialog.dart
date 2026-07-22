import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';

/// Reusable Security PIN Verification & Setup Dialog
class PinDialog {
  /// Prompt user to verify their 4-digit PIN.
  /// Returns `true` if entered PIN matches [correctPin], otherwise `false`.
  static Future<bool> verifyPin(
    BuildContext context,
    String correctPin, {
    String title = 'Enter Security PIN',
    String subtitle = 'Verify 4-digit PIN to access edit screen',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _PinVerificationDialog(
        correctPin: correctPin,
        title: title,
        subtitle: subtitle,
      ),
    );
    return result ?? false;
  }

  /// Prompt user to set a new 4-digit PIN or update existing PIN.
  /// Returns the new 4-digit PIN string, empty string to remove PIN, or `null` if canceled.
  static Future<String?> setupPin(
    BuildContext context, {
    String existingPin = '',
  }) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => _PinSetupDialog(existingPin: existingPin),
    );
  }
}

class _PinVerificationDialog extends StatefulWidget {
  final String correctPin;
  final String title;
  final String subtitle;

  const _PinVerificationDialog({
    required this.correctPin,
    required this.title,
    required this.subtitle,
  });

  @override
  State<_PinVerificationDialog> createState() => _PinVerificationDialogState();
}

class _PinVerificationDialogState extends State<_PinVerificationDialog> {
  String _enteredPin = '';
  bool _isError = false;

  void _onKeyPress(String digit) {
    if (_enteredPin.length < 4) {
      HapticFeedback.lightImpact();
      setState(() {
        _enteredPin += digit;
        _isError = false;
      });

      if (_enteredPin.length == 4) {
        _checkPin();
      }
    }
  }

  void _onBackspace() {
    if (_enteredPin.isNotEmpty) {
      HapticFeedback.lightImpact();
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _isError = false;
      });
    }
  }

  void _checkPin() {
    if (_enteredPin == widget.correctPin) {
      HapticFeedback.mediumImpact();
      Navigator.pop(context, true);
    } else {
      HapticFeedback.vibrate();
      setState(() {
        _isError = true;
        _enteredPin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_rounded, color: AppColors.primaryRed, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _isError ? 'Incorrect PIN code. Try again.' : widget.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: _isError ? AppColors.primaryRed : Colors.grey,
                fontWeight: _isError ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 24),

            // 4 Indicator Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isFilled = index < _enteredPin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled
                        ? AppColors.primaryRed
                        : context.colorScheme.onSurface.withValues(alpha: 0.2),
                    border: Border.all(
                      color: isFilled ? AppColors.primaryRed : Colors.grey.shade400,
                      width: 1.5,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 28),

            // Keypad
            _buildKeypad(),

            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['1', '2', '3'].map(_buildKeypadButton).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['4', '5', '6'].map(_buildKeypadButton).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['7', '8', '9'].map(_buildKeypadButton).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 60, height: 60),
            _buildKeypadButton('0'),
            SizedBox(
              width: 60,
              height: 60,
              child: IconButton(
                onPressed: _onBackspace,
                icon: const Icon(Icons.backspace_rounded, color: Colors.grey),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKeypadButton(String digit) {
    return SizedBox(
      width: 60,
      height: 60,
      child: OutlinedButton(
        onPressed: () => _onKeyPress(digit),
        style: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
          side: BorderSide(color: context.colorScheme.onSurface.withValues(alpha: 0.15)),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          digit,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: context.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _PinSetupDialog extends StatefulWidget {
  final String existingPin;

  const _PinSetupDialog({required this.existingPin});

  @override
  State<_PinSetupDialog> createState() => _PinSetupDialogState();
}

class _PinSetupDialogState extends State<_PinSetupDialog> {
  String _firstPin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  String _errorText = '';

  void _onKeyPress(String digit) {
    HapticFeedback.lightImpact();
    setState(() {
      _errorText = '';
      if (!_isConfirming) {
        if (_firstPin.length < 4) {
          _firstPin += digit;
          if (_firstPin.length == 4) {
            _isConfirming = true;
          }
        }
      } else {
        if (_confirmPin.length < 4) {
          _confirmPin += digit;
          if (_confirmPin.length == 4) {
            _verifyAndSave();
          }
        }
      }
    });
  }

  void _onBackspace() {
    HapticFeedback.lightImpact();
    setState(() {
      _errorText = '';
      if (_isConfirming) {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        } else {
          _isConfirming = false;
          _firstPin = '';
        }
      } else {
        if (_firstPin.isNotEmpty) {
          _firstPin = _firstPin.substring(0, _firstPin.length - 1);
        }
      }
    });
  }

  void _verifyAndSave() {
    if (_firstPin == _confirmPin) {
      HapticFeedback.mediumImpact();
      Navigator.pop(context, _firstPin);
    } else {
      HapticFeedback.vibrate();
      setState(() {
        _errorText = 'PINs do not match. Try again.';
        _firstPin = '';
        _confirmPin = '';
        _isConfirming = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final activePin = _isConfirming ? _confirmPin : _firstPin;

    return Dialog(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.locationBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.security_rounded, color: AppColors.locationBlue, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              widget.existingPin.isNotEmpty ? 'Change Security PIN' : 'Set Security PIN',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _errorText.isNotEmpty
                  ? _errorText
                  : (_isConfirming ? 'Re-enter 4-digit PIN to confirm' : 'Enter a 4-digit Security PIN'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: _errorText.isNotEmpty ? AppColors.primaryRed : Colors.grey,
                fontWeight: _errorText.isNotEmpty ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 24),

            // 4 Indicator Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isFilled = index < activePin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled
                        ? AppColors.locationBlue
                        : context.colorScheme.onSurface.withValues(alpha: 0.2),
                    border: Border.all(
                      color: isFilled ? AppColors.locationBlue : Colors.grey.shade400,
                      width: 1.5,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 28),

            // Keypad
            _buildKeypad(),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.existingPin.isNotEmpty)
                  TextButton(
                    onPressed: () => Navigator.pop(context, ''), // empty string removes PIN
                    child: const Text('Remove PIN', style: TextStyle(color: AppColors.primaryRed)),
                  )
                else
                  const SizedBox(),
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['1', '2', '3'].map(_buildKeypadButton).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['4', '5', '6'].map(_buildKeypadButton).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['7', '8', '9'].map(_buildKeypadButton).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 60, height: 60),
            _buildKeypadButton('0'),
            SizedBox(
              width: 60,
              height: 60,
              child: IconButton(
                onPressed: _onBackspace,
                icon: const Icon(Icons.backspace_rounded, color: Colors.grey),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKeypadButton(String digit) {
    return SizedBox(
      width: 60,
      height: 60,
      child: OutlinedButton(
        onPressed: () => _onKeyPress(digit),
        style: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
          side: BorderSide(color: context.colorScheme.onSurface.withValues(alpha: 0.15)),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          digit,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: context.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
