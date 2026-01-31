import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

/// Application entry point.
///
/// To preview a widget in isolation during development,
/// temporarily replace [ChfApp] with [WidgetWorkshop] from
/// `workshop/widget_workshop.dart`.  See GUIDE.md §4 for details.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait on mobile (no effect on desktop/web)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(initialTheme: AppThemeMode.light),
        ),
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(initialLocale: AppLocale.fr),
        ),
      ],
      child: const ChfApp(),
    ),
  );
}
