import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/l10n/app_localizations.dart';
import 'core/theme/theme_provider.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/registration_page.dart';

/// Root widget of the CHF application.
///
/// Responsibilities:
/// - Injects [ThemeProvider] and [LocaleProvider] via Provider
/// - Wraps the tree with [LocaleScope] for the `context.tr()` extension
/// - Defines named routes
/// - Applies the active theme
class ChfApp extends StatelessWidget {
  const ChfApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return LocaleScope(
      provider: localeProvider,
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,

        // ─── Theme ───
        theme: themeProvider.themeData,

        // ─── Locale ───
        locale: localeProvider.flutterLocale,
        supportedLocales: const [Locale('fr'), Locale('en')],

        // ─── Routes ───
        initialRoute: AppConstants.routeLogin,
        routes: {
          AppConstants.routeLogin: (_) => const LoginPage(),
          AppConstants.routeRegister: (_) => const RegistrationPage(),
        },
      ),
    );
  }
}
