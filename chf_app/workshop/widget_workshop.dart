// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ─── Import everything you might want to preview ───
import '../lib/core/constants/app_constants.dart';
import '../lib/core/l10n/app_localizations.dart';
import '../lib/core/theme/app_colors.dart';
import '../lib/core/theme/app_theme.dart';
import '../lib/core/theme/theme_provider.dart';
import '../lib/features/auth/presentation/widgets/animated_button.dart';
import '../lib/features/auth/presentation/widgets/auth_header.dart';
import '../lib/features/auth/presentation/widgets/custom_text_field.dart';
import '../lib/features/auth/presentation/widgets/password_strength_indicator.dart';
import '../lib/features/auth/presentation/widgets/school_dropdown.dart';
import '../lib/features/auth/presentation/widgets/step_indicator.dart';
import '../lib/shared/widgets/language_selector.dart';
import '../lib/shared/widgets/theme_selector.dart';

/// ═══════════════════════════════════════════════════════════════
///  WIDGET WORKSHOP
/// ═══════════════════════════════════════════════════════════════
///
///  HOW TO USE:
///
///  1. In `main.dart`, temporarily change the `home` of MaterialApp:
///
///     ```dart
///     // In main.dart, replace:
///     child: const ChfApp(),
///     // With:
///     child: const WidgetWorkshopApp(),
///     ```
///
///  2. Place the widget you're building inside the [_buildPreview] method.
///
///  3. Run the app (`flutter run`) and use HOT RELOAD (Ctrl+S or `r` in terminal)
///     every time you modify the widget you're working on.
///
///  4. When done, revert main.dart to use `ChfApp()`.
///
/// ═══════════════════════════════════════════════════════════════

void main() {
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
      child: const WidgetWorkshopApp(),
    ),
  );
}

class WidgetWorkshopApp extends StatelessWidget {
  const WidgetWorkshopApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return LocaleScope(
      provider: localeProvider,
      child: MaterialApp(
        title: 'Widget Workshop',
        debugShowCheckedModeBanner: false,
        theme: themeProvider.themeData,
        home: const WidgetWorkshop(),
      ),
    );
  }
}

class WidgetWorkshop extends StatelessWidget {
  const WidgetWorkshop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workshop'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: ThemeSelector(),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: LanguageSelector(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: _buildPreview(context),
            ),
          ),
        ),
      ),
    );
  }

  /// ╔═══════════════════════════════════════════════╗
  /// ║  PLACE YOUR WIDGET HERE TO PREVIEW IT         ║
  /// ║  Then save the file → Hot Reload activates     ║
  /// ╚═══════════════════════════════════════════════╝
  Widget _buildPreview(BuildContext context) {
    // ─────────────────────────────────────────────────
    // EXAMPLE: Preview the StepIndicator
    // Change this to preview any widget you're working on.
    // ─────────────────────────────────────────────────
    return Column(
      children: [
        // Example 1: Step Indicator
        const Text('StepIndicator:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const StepIndicator(
          currentStep: 1,
          totalSteps: 3,
          labels: ['Identity', 'School', 'Security'],
        ),
        const SizedBox(height: 32),

        // Example 2: Custom Text Field
        const Text('CustomTextField:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const CustomTextField(
          label: 'Email',
          hintText: 'Enter your email',
          prefixIcon: Icons.email_outlined,
        ),
        const SizedBox(height: 32),

        // Example 3: Animated Button
        const Text('AnimatedButton:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        AnimatedButton(
          label: 'Sign In',
          onPressed: () {},
        ),
        const SizedBox(height: 16),
        AnimatedButton(
          label: 'Create Account',
          onPressed: () {},
          isOutlined: true,
        ),
        const SizedBox(height: 16),
        const AnimatedButton(
          label: 'Loading...',
          onPressed: null,
          isLoading: true,
        ),
        const SizedBox(height: 32),

        // Example 4: Password Strength
        const Text('PasswordStrength:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const PasswordStrengthIndicator(password: 'Ab'),
        const PasswordStrengthIndicator(password: 'Abcdef'),
        const PasswordStrengthIndicator(password: 'Abcdef1'),
        const PasswordStrengthIndicator(password: 'Abcdef1!'),
        const SizedBox(height: 32),

        // Example 5: Auth Header
        const Text('AuthHeader:', style: TextStyle(fontWeight: FontWeight.bold)),
        const AuthHeader(
          title: 'Welcome Back',
          subtitle: 'Sign in to your account',
        ),
      ],
    );
  }
}
