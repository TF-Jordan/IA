import 'package:flutter/material.dart';

import 'l10n_en.dart' as english;
import 'l10n_fr.dart' as french;

/// Supported locales in the application.
enum AppLocale {
  en('en', 'English', '🇬🇧'),
  fr('fr', 'Français', '🇫🇷');

  final String code;
  final String label;
  final String flag;

  const AppLocale(this.code, this.label, this.flag);
}

/// Lightweight i18n provider.
///
/// Wraps the application to provide translated strings everywhere:
///
/// ```dart
/// // Read a string
/// final title = context.tr('login_title');
///
/// // Change language
/// context.read<LocaleProvider>().setLocale(AppLocale.en);
/// ```
class LocaleProvider extends ChangeNotifier {
  AppLocale _locale;

  LocaleProvider({AppLocale initialLocale = AppLocale.fr})
      : _locale = initialLocale;

  AppLocale get locale => _locale;
  Locale get flutterLocale => Locale(_locale.code);

  void setLocale(AppLocale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }

  void toggleLocale() {
    setLocale(_locale == AppLocale.fr ? AppLocale.en : AppLocale.fr);
  }

  /// Retrieve a translated string by [key].
  ///
  /// Supports basic placeholder replacement:
  /// ```dart
  /// tr('step_of', {'current': '1', 'total': '3'})
  /// // → "Step 1 of 3"
  /// ```
  String tr(String key, [Map<String, String>? params]) {
    final Map<String, String> translations;
    switch (_locale) {
      case AppLocale.en:
        translations = english.en;
      case AppLocale.fr:
        translations = french.fr;
    }

    String value = translations[key] ?? key;

    if (params != null) {
      params.forEach((paramKey, paramValue) {
        value = value.replaceAll('{$paramKey}', paramValue);
      });
    }

    return value;
  }
}

/// Extension for convenient access from any [BuildContext].
///
/// ```dart
/// Text(context.tr('login_title'))
/// ```
extension LocalizationExtension on BuildContext {
  LocaleProvider get _provider {
    final provider =
        dependOnInheritedWidgetOfExactType<_LocaleInheritedWidget>();
    assert(provider != null, 'No LocaleProvider found in widget tree');
    return provider!.provider;
  }

  String tr(String key, [Map<String, String>? params]) =>
      _provider.tr(key, params);
}

/// InheritedWidget that allows [context.tr()] to work.
///
/// Placed internally; users interact via [LocaleScope].
class _LocaleInheritedWidget extends InheritedWidget {
  final LocaleProvider provider;

  const _LocaleInheritedWidget({
    required this.provider,
    required super.child,
  });

  @override
  bool updateShouldNotify(_LocaleInheritedWidget oldWidget) =>
      provider.locale != oldWidget.provider.locale;
}

/// Wrapper widget that injects [LocaleProvider] into the tree.
///
/// Place at the root, below [MaterialApp] or wrapping it:
///
/// ```dart
/// LocaleScope(
///   provider: localeProvider,
///   child: MaterialApp(...),
/// )
/// ```
class LocaleScope extends StatelessWidget {
  final LocaleProvider provider;
  final Widget child;

  const LocaleScope({
    super.key,
    required this.provider,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: provider,
      builder: (context, _) => _LocaleInheritedWidget(
        provider: provider,
        child: child,
      ),
    );
  }
}
