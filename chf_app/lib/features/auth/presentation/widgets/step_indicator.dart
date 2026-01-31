import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Visual progress indicator for multi-step registration.
///
/// Displays numbered circles connected by lines. Completed steps are filled,
/// the current step has a ring, and future steps are dimmed.
///
/// ```
///  (1) ──── (2) ──── (3)
///   ✓      current   dim
/// ```
class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> labels;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingLg,
      ),
      child: Row(
        children: List.generate(totalSteps * 2 - 1, (index) {
          // Odd indices = connector lines
          if (index.isOdd) {
            final stepBefore = index ~/ 2;
            final isCompleted = stepBefore < currentStep;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 2.5,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }

          // Even indices = step circles
          final step = index ~/ 2;
          final isCompleted = step < currentStep;
          final isCurrent = step == currentStep;
          final label = step < labels.length ? labels[step] : '';

          return _StepCircle(
            step: step + 1,
            label: label,
            isCompleted: isCompleted,
            isCurrent: isCurrent,
          );
        }),
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int step;
  final String label;
  final bool isCompleted;
  final bool isCurrent;

  const _StepCircle({
    required this.step,
    required this.label,
    required this.isCompleted,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color circleColor;
    final Color contentColor;
    final List<BoxShadow> shadows;
    final Border? border;

    if (isCompleted) {
      circleColor = colorScheme.primary;
      contentColor = colorScheme.onPrimary;
      shadows = [
        BoxShadow(
          color: colorScheme.primary.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
      border = null;
    } else if (isCurrent) {
      circleColor = colorScheme.primary.withValues(alpha: 0.1);
      contentColor = colorScheme.primary;
      shadows = [
        BoxShadow(
          color: colorScheme.primary.withValues(alpha: 0.15),
          blurRadius: 12,
          spreadRadius: 2,
        ),
      ];
      border = Border.all(color: colorScheme.primary, width: 2);
    } else {
      circleColor = colorScheme.onSurface.withValues(alpha: 0.08);
      contentColor = colorScheme.onSurface.withValues(alpha: 0.35);
      shadows = [];
      border = null;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: isCurrent ? 42 : 36,
          height: isCurrent ? 42 : 36,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
            border: border,
            boxShadow: shadows,
          ),
          child: Center(
            child: isCompleted
                ? Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: contentColor,
                  )
                : Text(
                    '$step',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: contentColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: (isCompleted || isCurrent)
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.4),
            fontWeight:
                isCurrent ? FontWeight.w600 : FontWeight.w400,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
