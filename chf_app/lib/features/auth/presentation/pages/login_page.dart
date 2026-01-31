import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/language_selector.dart';
import '../../../../shared/widgets/theme_selector.dart';
import '../widgets/animated_button.dart';
import '../widgets/auth_header.dart';
import '../widgets/custom_text_field.dart';
import '../../domain/validators.dart';

/// Login page for the CHF application.
///
/// Layout (top → bottom):
///   1. Settings bar (language + theme selectors)
///   2. Animated header (logo, title, subtitle)
///   3. Email field
///   4. Password field with visibility toggle
///   5. "Forgot password?" link
///   6. Login button
///   7. Divider "or"
///   8. "Create account" link
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate network call – replace with actual API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // TODO: Navigate to home on success
  }

  void _navigateToRegister() {
    Navigator.of(context).pushReplacementNamed(AppConstants.routeRegister);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppTheme.spacingMd),

                  // ─── Settings bar ───
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LanguageSelector(),
                      ThemeSelector(),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingLg),

                  // ─── Header ───
                  AuthHeader(
                    title: context.tr('login_title'),
                    subtitle: context.tr('login_subtitle'),
                  ),

                  // ─── Email ───
                  CustomTextField(
                    label: context.tr('email'),
                    hintText: context.tr('email_hint'),
                    prefixIcon: Icons.email_outlined,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      final key = Validators.email(value);
                      return key != null ? context.tr(key) : null;
                    },
                  ),

                  // ─── Password ───
                  CustomTextField(
                    label: context.tr('password'),
                    hintText: context.tr('password_hint'),
                    prefixIcon: Icons.lock_outline_rounded,
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                    validator: (value) {
                      final key = Validators.required(value);
                      return key != null ? context.tr(key) : null;
                    },
                  ),

                  // ─── Forgot password ───
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Navigate to forgot password
                      },
                      child: Text(context.tr('forgot_password')),
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingSm),

                  // ─── Login button ───
                  AnimatedButton(
                    label: context.tr('login_button'),
                    isLoading: _isLoading,
                    onPressed: _handleLogin,
                  ),

                  const SizedBox(height: AppTheme.spacingLg),

                  // ─── Divider ───
                  Row(
                    children: [
                      Expanded(child: Divider(color: theme.dividerColor)),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMd,
                        ),
                        child: Text(
                          context.tr('or'),
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      Expanded(child: Divider(color: theme.dividerColor)),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingLg),

                  // ─── Create account ───
                  AnimatedButton(
                    label: context.tr('login_create_account'),
                    onPressed: _navigateToRegister,
                    isOutlined: true,
                  ),

                  const SizedBox(height: AppTheme.spacingXxl),

                  // ─── Version ───
                  Center(
                    child: Text(
                      'v${AppConstants.appVersion}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.4),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingMd),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
