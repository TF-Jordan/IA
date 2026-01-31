import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

/// Password strength levels.
enum PasswordStrength { none, weak, fair, good, strong }

/// Visual indicator that shows password strength as a colored bar + label.
///
/// Updates in real time as the user types.
class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    final strength = _calculateStrength(password);
    if (strength == PasswordStrength.none) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final config = _getConfig(strength, context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Bar ───
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 4,
              child: Row(
                children: List.generate(4, (index) {
                  final isActive = index < config.filledSegments;
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
                      decoration: BoxDecoration(
                        color: isActive
                            ? config.color
                            : theme.dividerColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 6),

          // ─── Label ───
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              config.label,
              key: ValueKey(config.label),
              style: theme.textTheme.bodySmall?.copyWith(
                color: config.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  PasswordStrength _calculateStrength(String password) {
    if (password.isEmpty) return PasswordStrength.none;
    if (password.length < 4) return PasswordStrength.weak;

    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score == 3) return PasswordStrength.fair;
    if (score == 4) return PasswordStrength.good;
    return PasswordStrength.strong;
  }

  _StrengthConfig _getConfig(PasswordStrength strength, BuildContext context) {
    switch (strength) {
      case PasswordStrength.none:
        return _StrengthConfig(Colors.transparent, '', 0);
      case PasswordStrength.weak:
        return _StrengthConfig(
          AppColors.error,
          context.tr('password_strength_weak'),
          1,
        );
      case PasswordStrength.fair:
        return _StrengthConfig(
          AppColors.warning,
          context.tr('password_strength_fair'),
          2,
        );
      case PasswordStrength.good:
        return _StrengthConfig(
          AppColors.info,
          context.tr('password_strength_good'),
          3,
        );
      case PasswordStrength.strong:
        return _StrengthConfig(
          AppColors.success,
          context.tr('password_strength_strong'),
          4,
        );
    }
  }
}

class _StrengthConfig {
  final Color color;
  final String label;
  final int filledSegments;

  _StrengthConfig(this.color, this.label, this.filledSegments);
}
