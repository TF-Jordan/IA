import '../../../core/constants/app_constants.dart';

/// Centralized validation logic for authentication forms.
///
/// Each method returns `null` on success or a translation key on failure.
/// The UI layer resolves the key via [context.tr(key)].
///
/// Keeping validators in the domain layer means they are:
/// - Testable without Flutter dependencies
/// - Reusable across different form widgets
/// - Consistent across login, registration, and profile editing
class Validators {
  Validators._();

  /// Validates that a field is not empty.
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation_required';
    }
    return null;
  }

  /// Validates a name (first name or last name).
  static String? name(String? value) {
    final base = required(value);
    if (base != null) return base;

    final trimmed = value!.trim();
    if (trimmed.length < AppConstants.nameMinLength) {
      return 'validation_name_short';
    }
    if (trimmed.length > AppConstants.nameMaxLength) {
      return 'validation_name_long';
    }
    return null;
  }

  /// Validates an email address.
  static String? email(String? value) {
    final base = required(value);
    if (base != null) return base;

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value!.trim())) {
      return 'validation_email_invalid';
    }
    return null;
  }

  /// Validates a password against security requirements.
  ///
  /// Requirements:
  /// - At least 8 characters
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one digit
  /// - At least one special character
  static String? password(String? value) {
    final base = required(value);
    if (base != null) return base;

    final pwd = value!;
    if (pwd.length < AppConstants.passwordMinLength) {
      return 'validation_password_short';
    }
    if (!pwd.contains(RegExp(r'[A-Z]'))) {
      return 'validation_password_uppercase';
    }
    if (!pwd.contains(RegExp(r'[a-z]'))) {
      return 'validation_password_lowercase';
    }
    if (!pwd.contains(RegExp(r'[0-9]'))) {
      return 'validation_password_digit';
    }
    if (!pwd.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'validation_password_special';
    }
    return null;
  }

  /// Validates that a confirmation password matches the original.
  static String? confirmPassword(String? value, String original) {
    final base = required(value);
    if (base != null) return base;

    if (value != original) {
      return 'validation_password_mismatch';
    }
    return null;
  }

  /// Validates that a date has been selected.
  static String? dateOfBirth(DateTime? value) {
    if (value == null) {
      return 'validation_date_required';
    }
    return null;
  }

  /// Validates that a school has been selected.
  static String? school(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation_school_required';
    }
    return null;
  }

  /// Validates that terms have been accepted.
  static String? terms(bool accepted) {
    if (!accepted) {
      return 'validation_terms_required';
    }
    return null;
  }
}
