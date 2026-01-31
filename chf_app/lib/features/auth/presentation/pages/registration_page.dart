import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/language_selector.dart';
import '../../../../shared/widgets/theme_selector.dart';
import '../widgets/animated_button.dart';
import '../widgets/auth_header.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/password_strength_indicator.dart';
import '../widgets/school_dropdown.dart';
import '../widgets/step_indicator.dart';
import '../../domain/validators.dart';

/// Multi-step registration page.
///
/// Uses a [PageView] with 3 steps:
///   1. Personal info  – first name, last name, date of birth
///   2. Academic info   – school (dropdown), email
///   3. Security        – password, confirm password, terms
///
/// Each step has its own [GlobalKey<FormState>] for isolated validation.
/// Transition between steps is animated via the [PageController].
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  // ─── Form keys (one per step) ───
  final _formKeys = List.generate(3, (_) => GlobalKey<FormState>());

  // ─── Step 1 controllers ───
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  DateTime? _dateOfBirth;

  // ─── Step 2 controllers ───
  String? _selectedSchool;
  final _emailController = TextEditingController();

  // ─── Step 3 controllers ───
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptedTerms = false;
  String _passwordText = '';

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ════════════════════════════════════════════════
  //  NAVIGATION
  // ════════════════════════════════════════════════

  void _nextStep() {
    if (!_formKeys[_currentStep].currentState!.validate()) return;

    // Extra validation for step-specific non-form fields
    if (_currentStep == 0 && _dateOfBirth == null) {
      _showSnackBar(context.tr('validation_date_required'));
      return;
    }
    if (_currentStep == 1 && (_selectedSchool == null || _selectedSchool!.isEmpty)) {
      _showSnackBar(context.tr('validation_school_required'));
      return;
    }

    if (_currentStep < AppConstants.registrationTotalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: AppConstants.animPageTransition,
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: AppConstants.animPageTransition,
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKeys[_currentStep].currentState!.validate()) return;
    if (!_acceptedTerms) {
      _showSnackBar(context.tr('validation_terms_required'));
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call – replace with actual registration
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // TODO: Navigate to login or home on success
    _showSnackBar('Account created!');
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacementNamed(AppConstants.routeLogin);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════
  //  DATE PICKER
  // ════════════════════════════════════════════════

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(now.year - 18),
      firstDate: DateTime(1950),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  // ════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final stepLabels = [
      context.tr('step1_title'),
      context.tr('step2_title'),
      context.tr('step3_title'),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppTheme.spacingMd),

            // ─── Settings bar ───
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LanguageSelector(),
                  ThemeSelector(),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingSm),

            // ─── Step indicator ───
            StepIndicator(
              currentStep: _currentStep,
              totalSteps: AppConstants.registrationTotalSteps,
              labels: stepLabels,
            ),

            // ─── Page view ───
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1(context),
                  _buildStep2(context),
                  _buildStep3(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════
  //  STEP 1 – Personal info
  // ════════════════════════════════════════════════

  Widget _buildStep1(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Form(
          key: _formKeys[0],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(
                title: context.tr('step1_title'),
                subtitle: context.tr('step1_subtitle'),
              ),

              // Last name
              CustomTextField(
                label: context.tr('last_name'),
                hintText: context.tr('last_name_hint'),
                prefixIcon: Icons.person_outline_rounded,
                controller: _lastNameController,
                validator: (v) {
                  final key = Validators.name(v);
                  return key != null ? context.tr(key) : null;
                },
              ),

              // First name
              CustomTextField(
                label: context.tr('first_name'),
                hintText: context.tr('first_name_hint'),
                prefixIcon: Icons.person_outline_rounded,
                controller: _firstNameController,
                validator: (v) {
                  final key = Validators.name(v);
                  return key != null ? context.tr(key) : null;
                },
              ),

              // Date of birth
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('date_of_birth'),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  GestureDetector(
                    onTap: _pickDateOfBirth,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMd,
                        vertical: AppTheme.spacingMd,
                      ),
                      decoration: BoxDecoration(
                        color: theme.inputDecorationTheme.fillColor,
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _dateOfBirth != null
                                ? DateFormat.yMMMMd(
                                    context.tr('lang_fr') == 'Français'
                                        ? 'fr'
                                        : 'en',
                                  ).format(_dateOfBirth!)
                                : context.tr('date_of_birth_hint'),
                            style: _dateOfBirth != null
                                ? theme.textTheme.bodyLarge
                                : theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.6),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.spacingXl),

              // Next button
              AnimatedButton(
                label: context.tr('continue_text'),
                onPressed: _nextStep,
              ),

              const SizedBox(height: AppTheme.spacingMd),

              // Already have account
              AuthLinkButton(
                prefix: '${context.tr('register_has_account')} ',
                linkText: context.tr('register_sign_in'),
                onTap: _navigateToLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════
  //  STEP 2 – Academic info
  // ════════════════════════════════════════════════

  Widget _buildStep2(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Form(
          key: _formKeys[1],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(
                title: context.tr('step2_title'),
                subtitle: context.tr('step2_subtitle'),
              ),

              // School dropdown
              SchoolDropdown(
                label: context.tr('school'),
                hintText: context.tr('school_hint'),
                searchHint: context.tr('school_search_hint'),
                schools: AppConstants.defaultSchools,
                selectedSchool: _selectedSchool,
                onSelected: (school) {
                  setState(() => _selectedSchool = school);
                },
                validator: (v) {
                  final key = Validators.school(v);
                  return key != null ? context.tr(key) : null;
                },
              ),

              // Email
              CustomTextField(
                label: context.tr('email'),
                hintText: context.tr('email_hint'),
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  final key = Validators.email(v);
                  return key != null ? context.tr(key) : null;
                },
              ),

              const SizedBox(height: AppTheme.spacingLg),

              // Navigation buttons
              Row(
                children: [
                  Expanded(
                    child: AnimatedButton(
                      label: context.tr('back'),
                      onPressed: _previousStep,
                      isOutlined: true,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    flex: 2,
                    child: AnimatedButton(
                      label: context.tr('continue_text'),
                      onPressed: _nextStep,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════
  //  STEP 3 – Security
  // ════════════════════════════════════════════════

  Widget _buildStep3(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Form(
          key: _formKeys[2],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(
                title: context.tr('step3_title'),
                subtitle: context.tr('step3_subtitle'),
              ),

              // Password
              CustomTextField(
                label: context.tr('password'),
                hintText: context.tr('password_hint'),
                prefixIcon: Icons.lock_outline_rounded,
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                onChanged: (value) {
                  setState(() => _passwordText = value);
                },
                validator: (v) {
                  final key = Validators.password(v);
                  return key != null ? context.tr(key) : null;
                },
              ),

              // Password strength indicator
              PasswordStrengthIndicator(password: _passwordText),

              // Confirm password
              CustomTextField(
                label: context.tr('password_confirm'),
                hintText: context.tr('password_confirm_hint'),
                prefixIcon: Icons.lock_outline_rounded,
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                textInputAction: TextInputAction.done,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () {
                    setState(() => _obscureConfirm = !_obscureConfirm);
                  },
                ),
                validator: (v) {
                  final key = Validators.confirmPassword(
                    v,
                    _passwordController.text,
                  );
                  return key != null ? context.tr(key) : null;
                },
              ),

              // Terms checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _acceptedTerms,
                    onChanged: (v) {
                      setState(() => _acceptedTerms = v ?? false);
                    },
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _acceptedTerms = !_acceptedTerms);
                      },
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium,
                          children: [
                            TextSpan(text: context.tr('accept_terms')),
                            TextSpan(
                              text: context.tr('terms_and_conditions'),
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.spacingLg),

              // Navigation buttons
              Row(
                children: [
                  Expanded(
                    child: AnimatedButton(
                      label: context.tr('back'),
                      onPressed: _previousStep,
                      isOutlined: true,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    flex: 2,
                    child: AnimatedButton(
                      label: context.tr('register_button'),
                      isLoading: _isLoading,
                      onPressed: _handleRegister,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.spacingXl),
            ],
          ),
        ),
      ),
    );
  }
}
