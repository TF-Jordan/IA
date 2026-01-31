/// Application-wide constants that do not change at runtime.
class AppConstants {
  AppConstants._();

  // ──────────────────────────────────────────────
  //  BRANDING
  // ──────────────────────────────────────────────
  static const String appName = 'CHF';
  static const String appFullName = 'Clubs des Hommes de Foi';
  static const String appTagline = 'Biblical Club Management';
  static const String appVersion = '1.0.0';

  // ──────────────────────────────────────────────
  //  VALIDATION RULES
  // ──────────────────────────────────────────────
  static const int passwordMinLength = 8;
  static const int nameMinLength = 2;
  static const int nameMaxLength = 50;

  // ──────────────────────────────────────────────
  //  REGISTRATION STEPS
  // ──────────────────────────────────────────────
  static const int registrationTotalSteps = 3;

  // ──────────────────────────────────────────────
  //  ANIMATION DURATIONS (ms)
  // ──────────────────────────────────────────────
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 600);
  static const Duration animPageTransition = Duration(milliseconds: 400);

  // ──────────────────────────────────────────────
  //  SCHOOLS LIST  (fetched from API in production,
  //  fallback hardcoded for offline / demo)
  // ──────────────────────────────────────────────
  static const List<String> defaultSchools = [
    'Université de Douala',
    'Université de Yaoundé I',
    'Université de Yaoundé II - Soa',
    'Université de Dschang',
    'Université de Buéa',
    'Université de Bamenda',
    'Université de Maroua',
    'Université de Ngaoundéré',
    'Université de Bertoua',
    'Université de Ebolowa',
    'Institut Universitaire de la Côte (IUC)',
    'Institut SIANTOU',
    'Université Catholique d\'Afrique Centrale (UCAC)',
    'Université Protestante d\'Afrique Centrale (UPAC)',
    'Institut Supérieur de Management (ISMA)',
    'Collège Polyvalent le Jourdain',
    'Lycée Bilingue de Deido',
    'Lycée Général Leclerc',
    'Lycée de la Cité des Palmiers',
    'Lycée Bilingue de Bonabéri',
    'Autre',
  ];

  // ──────────────────────────────────────────────
  //  ROUTES (in-app navigation)
  // ──────────────────────────────────────────────
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeHome = '/home';
  static const String routeForgotPassword = '/forgot-password';
  static const String routeWorkshop = '/workshop';
}
