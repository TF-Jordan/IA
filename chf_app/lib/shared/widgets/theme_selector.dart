import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_provider.dart';

/// Compact theme switcher displayed in the auth screens.
///
/// Shows a row of three colored dots. The active one is enlarged with a ring.
/// Tap any dot to switch theme instantly.
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  static const _themeConfigs = [
    _ThemeConfig(AppThemeMode.light, AppColors.lightPrimary, 'theme_light'),
    _ThemeConfig(AppThemeMode.dark, AppColors.darkBackground, 'theme_dark'),
    _ThemeConfig(AppThemeMode.ocean, AppColors.oceanPrimary, 'theme_ocean'),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            themeProvider.icon,
            size: 16,
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(width: 8),
          ..._themeConfigs.map((config) {
            final isActive = themeProvider.themeMode == config.mode;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: GestureDetector(
                onTap: () => themeProvider.setTheme(config.mode),
                child: Tooltip(
                  message: context.tr(config.labelKey),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    width: isActive ? 20 : 14,
                    height: isActive ? 20 : 14,
                    decoration: BoxDecoration(
                      color: config.color,
                      shape: BoxShape.circle,
                      border: isActive
                          ? Border.all(
                              color: theme.colorScheme.secondary,
                              width: 2.5,
                            )
                          : Border.all(
                              color: theme.dividerColor,
                              width: 1,
                            ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: config.color.withValues(alpha: 0.4),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ThemeConfig {
  final AppThemeMode mode;
  final Color color;
  final String labelKey;

  const _ThemeConfig(this.mode, this.color, this.labelKey);
}
