# GUIDE DE CONSTRUCTION – CHF App (Flutter)

## Table des matières

1. [Architecture du projet](#1-architecture-du-projet)
2. [Ordre de construction des fichiers](#2-ordre-de-construction-des-fichiers)
3. [Méthode du Widget Workshop (Hot Reload)](#3-méthode-du-widget-workshop-hot-reload)
4. [Étape par étape : Construction détaillée](#4-étape-par-étape--construction-détaillée)
5. [Concepts clés à maîtriser pour l'entretien](#5-concepts-clés-à-maîtriser-pour-lentretien)
6. [Commandes utiles](#6-commandes-utiles)

---

## 1. Architecture du projet

```
chf_app/
├── pubspec.yaml                        ← Dépendances & config
├── analysis_options.yaml               ← Règles de linting
├── GUIDE.md                            ← Ce fichier
├── workshop/
│   └── widget_workshop.dart            ← Atelier de prévisualisation
└── lib/
    ├── main.dart                       ← Point d'entrée
    ├── app.dart                        ← MaterialApp + routes + providers
    ├── core/                           ← Fondations (aucune UI)
    │   ├── theme/
    │   │   ├── app_colors.dart         ← Palette de couleurs (constantes)
    │   │   ├── app_theme.dart          ← Construction des ThemeData
    │   │   └── theme_provider.dart     ← State management du thème
    │   ├── constants/
    │   │   ├── api_routes.dart         ← Toutes les routes API (1 seul fichier)
    │   │   └── app_constants.dart      ← Constantes globales (écoles, durées, etc.)
    │   └── l10n/
    │       ├── app_localizations.dart  ← Provider + extension context.tr()
    │       ├── l10n_en.dart            ← Traductions anglaises
    │       └── l10n_fr.dart            ← Traductions françaises
    ├── features/                       ← Modules fonctionnels
    │   └── auth/
    │       ├── domain/
    │       │   └── validators.dart     ← Logique de validation pure
    │       └── presentation/
    │           ├── pages/
    │           │   ├── login_page.dart
    │           │   └── registration_page.dart
    │           └── widgets/
    │               ├── auth_header.dart
    │               ├── custom_text_field.dart
    │               ├── animated_button.dart
    │               ├── step_indicator.dart
    │               ├── school_dropdown.dart
    │               └── password_strength_indicator.dart
    └── shared/                         ← Widgets réutilisables cross-feature
        └── widgets/
            ├── language_selector.dart
            └── theme_selector.dart
```

### Pourquoi cette structure ?

- **`core/`** : Zéro dépendance vers `features/`. Contient tout ce qui est transversal (thème, i18n, constantes). Si tu changes de feature, `core/` ne bouge pas.
- **`features/auth/`** : Isolation par domaine métier. Demain, `features/events/`, `features/reports/`, etc. suivront le même pattern.
- **`domain/`** vs **`presentation/`** : Séparation classique Clean Architecture. Les validators sont testables sans Flutter.
- **`shared/`** : Widgets utilisés par plusieurs features.

---

## 2. Ordre de construction des fichiers

**Règle d'or : on construit toujours les fondations avant les murs, et les murs avant le toit.**

| Ordre | Fichier | Pourquoi en premier ? |
|-------|---------|----------------------|
| 1 | `pubspec.yaml` | Définit les dépendances. Sans ça, rien ne compile. |
| 2 | `app_colors.dart` | Les couleurs sont la base atomique de tout le thème. |
| 3 | `app_theme.dart` | Construit les ThemeData à partir des couleurs. |
| 4 | `theme_provider.dart` | State management du thème. Dépend de `app_theme.dart`. |
| 5 | `api_routes.dart` | Indépendant du reste. Autant le poser tôt. |
| 6 | `app_constants.dart` | Constantes utilisées partout (écoles, durées, routes). |
| 7 | `l10n_en.dart` + `l10n_fr.dart` | Les chaînes de traduction brutes. |
| 8 | `app_localizations.dart` | Le provider qui sert les traductions. Dépend de 7. |
| 9 | `validators.dart` | Logique pure, aucune dépendance UI. |
| 10 | `custom_text_field.dart` | Widget de base le plus réutilisé. |
| 11 | `animated_button.dart` | Second widget le plus réutilisé. |
| 12 | `auth_header.dart` | Header avec animation. Utilisé sur chaque page. |
| 13 | `step_indicator.dart` | Spécifique à l'inscription multi-étapes. |
| 14 | `school_dropdown.dart` | Dropdown searchable. Spécifique à l'étape 2. |
| 15 | `password_strength_indicator.dart` | Indicateur visuel. Spécifique à l'étape 3. |
| 16 | `language_selector.dart` | Petit widget de sélection de langue. |
| 17 | `theme_selector.dart` | Petit widget de sélection de thème. |
| 18 | `login_page.dart` | Première page complète. Assemble les widgets 10-17. |
| 19 | `registration_page.dart` | Deuxième page. Assemble tout. |
| 20 | `app.dart` | MaterialApp qui déclare les routes vers 18 et 19. |
| 21 | `main.dart` | Point d'entrée. Initialise les providers et lance `app.dart`. |

---

## 3. Méthode du Widget Workshop (Hot Reload)

### Le problème

Quand tu construis un widget (ex: `StepIndicator`), tu ne peux pas le voir à l'écran tant qu'il n'est pas placé dans une page, elle-même dans une route, elle-même dans un MaterialApp. C'est trop lourd pendant le développement.

### La solution : le Workshop

Le fichier `workshop/widget_workshop.dart` est un **mini-app indépendant** qui te permet de visualiser n'importe quel widget en isolation.

### Comment l'utiliser

#### Méthode 1 : Modifier temporairement `main.dart`

```dart
// main.dart — PENDANT le développement d'un widget
import 'workshop/widget_workshop.dart';  // ← ajouter cet import

void main() {
  // ...
  runApp(
    MultiProvider(
      providers: [...],
      // child: const ChfApp(),        // ← commenter
      child: const WidgetWorkshopApp(), // ← décommenter
    ),
  );
}
```

#### Méthode 2 : Lancer le workshop directement

```bash
flutter run -t workshop/widget_workshop.dart
```

#### Workflow de développement

1. **Ouvre** `widget_workshop.dart`
2. **Va dans** la méthode `_buildPreview()`
3. **Place** le widget que tu construis :
   ```dart
   Widget _buildPreview(BuildContext context) {
     return CustomTextField(
       label: 'Email',
       hintText: 'test@email.com',
       prefixIcon: Icons.email,
     );
   }
   ```
4. **Sauvegarde** le fichier (Ctrl+S)
5. **Hot Reload** se déclenche automatiquement → tu vois le widget à l'écran
6. **Modifie** le widget source → Sauvegarde → Hot Reload → tu vois le changement
7. **Répète** jusqu'à satisfaction
8. Quand c'est fini, **reviens** à `child: const ChfApp()` dans `main.dart`

#### Avantages

- Feedback visuel immédiat (< 1 seconde avec hot reload)
- Pas besoin d'assembler toute la page pour voir un widget
- Tu peux tester différentes props (couleurs, états, tailles)
- Tu peux afficher le même widget dans différents états côte à côte
- Le ThemeSelector et LanguageSelector sont dans la toolbar du workshop pour tester les thèmes/langues

---

## 4. Étape par étape : Construction détaillée

### ÉTAPE 1 : Initialisation du projet

```bash
flutter create chf_app --org com.chf --platforms android,ios,web
cd chf_app
```

Remplace le contenu de `pubspec.yaml` par celui fourni. Puis :

```bash
flutter pub get
```

Crée toute l'arborescence de dossiers :

```bash
mkdir -p lib/core/theme lib/core/constants lib/core/l10n
mkdir -p lib/features/auth/presentation/pages
mkdir -p lib/features/auth/presentation/widgets
mkdir -p lib/features/auth/domain
mkdir -p lib/shared/widgets
mkdir -p workshop
mkdir -p assets/images
```

**Checkpoint** : `flutter run` doit afficher l'app par défaut de Flutter.

---

### ÉTAPE 2 : Les couleurs (`app_colors.dart`)

**Concept clé** : On ne met JAMAIS de `Color(0xFF...)` dans un widget. Toutes les couleurs sont des constantes dans `AppColors`.

**Ce que tu dois comprendre** :
- `Color(0xFF1B3A5C)` → le `0xFF` = opacité totale, `1B3A5C` = hex RGB
- Trois variantes de palette : Light, Dark, Ocean
- Les couleurs utilitaires (error, success, etc.) sont partagées entre thèmes
- `AppColors._()` → constructeur privé = on ne peut pas instancier la classe

**Workshop** : Pas de preview visuel à cette étape. Ce sont juste des constantes.

---

### ÉTAPE 3 : Le thème (`app_theme.dart`)

**Concept clé** : `ThemeData` est l'objet Flutter qui définit l'apparence de TOUS les widgets Material. On construit 3 instances (light, dark, ocean) à partir de `AppColors`.

**Ce que tu dois comprendre** :
- `ColorScheme` : le système de couleurs sémantiques de Material 3
- Chaque composant (bouton, input, card...) est stylisé via des `...ThemeData`
- Les tokens de spacing/radius sont des constantes pour la cohérence
- `_build()` est privé car seuls `light()`, `dark()`, `ocean()` sont exposés
- `useMaterial3: true` active Material Design 3

**Workshop** : Pas encore, mais tu peux créer un `Container` coloré pour vérifier que les couleurs s'appliquent.

---

### ÉTAPE 4 : Le provider de thème (`theme_provider.dart`)

**Concept clé** : `ChangeNotifier` est le pattern de base de Provider. Quand on appelle `notifyListeners()`, tous les widgets qui font `context.watch<ThemeProvider>()` se reconstruisent.

**Ce que tu dois comprendre** :
- `ChangeNotifier` → pattern Observer
- `setTheme()` → change le thème et notifie
- `cycleTheme()` → passe au thème suivant (light → dark → ocean → light)
- Les getters `isLight`, `isDark`, `isOcean` → raccourcis pratiques

---

### ÉTAPE 5 : Les routes API (`api_routes.dart`)

**Concept clé** : Centralisation. Si le backend change `/api/v1/` en `/api/v2/`, on modifie UNE seule ligne.

**Ce que tu dois comprendre** :
- Constantes `static const` → pas d'instanciation, accès direct `ApiRoutes.login`
- Méthodes statiques pour les routes paramétrées : `ApiRoutes.memberById('123')`
- Le `_baseUrl` est privé (préfixe `_`) → non accessible de l'extérieur

---

### ÉTAPE 6 : Les constantes app (`app_constants.dart`)

**Ce que tu dois comprendre** :
- La liste des écoles est un fallback local (en production, on la charge depuis l'API)
- Les routes in-app (`routeLogin`, etc.) sont aussi centralisées
- Les durées d'animation sont standardisées pour la cohérence

---

### ÉTAPE 7 : L'internationalisation (`l10n_*.dart` + `app_localizations.dart`)

**Concept clé** : On sépare le texte de l'UI. Chaque chaîne visible est une clé dans un `Map<String, String>`.

**Ce que tu dois comprendre** :

1. **`l10n_en.dart` / `l10n_fr.dart`** : de simples `Map` constants. Faciles à maintenir.

2. **`LocaleProvider`** : même pattern que `ThemeProvider`. Un `ChangeNotifier` qui tient la locale courante.

3. **`LocaleScope` + `_LocaleInheritedWidget`** : permettent l'extension `context.tr('key')`.
   - `InheritedWidget` → c'est le mécanisme natif Flutter pour propager des données dans l'arbre
   - `ListenableBuilder` → reconstruit l'InheritedWidget quand le provider change
   - L'extension `LocalizationExtension` → syntaxe propre, `context.tr('login_title')`

4. **Placeholders** : `'step_of': 'Étape {current} sur {total}'` → remplacés par `context.tr('step_of', {'current': '1', 'total': '3'})`

**Pourquoi pas `gen-l10n` (la méthode officielle Flutter) ?** : Pour 2 langues, c'est over-engineering. Notre système est plus lisible, plus facile à expliquer, et montre qu'on comprend le mécanisme sous-jacent (InheritedWidget).

---

### ÉTAPE 8 : Les validators (`validators.dart`)

**Concept clé** : Logique pure, zéro dépendance Flutter. Testable avec de simples unit tests.

**Ce que tu dois comprendre** :
- Chaque méthode retourne `null` (succès) ou une clé de traduction (échec)
- La résolution `context.tr(key)` se fait côté UI, PAS dans le validator
- Cela permet de tester les validators sans contexte Flutter :
  ```dart
  expect(Validators.email('bad'), equals('validation_email_invalid'));
  expect(Validators.email('good@email.com'), isNull);
  ```
- Les regex pour email et password sont standards

---

### ÉTAPE 9 : `CustomTextField` (premier widget UI)

**C'est ici que tu lances le Workshop pour la première fois.**

**Ce que tu dois comprendre** :
- `StatefulWidget` car il gère l'état du focus (`_hasFocus`)
- `Focus` widget → écoute les changements de focus
- `AnimatedContainer` → anime le box-shadow quand le champ reçoit le focus (glow effect)
- `TextFormField` → champ avec validation intégrée (via `validator` callback)
- La structure Column : Label en haut, champ en dessous, spacing standardisé

**Workshop** :
```dart
Widget _buildPreview(BuildContext context) {
  return CustomTextField(
    label: 'Email',
    hintText: 'Enter your email',
    prefixIcon: Icons.email_outlined,
  );
}
```
→ Hot reload → tu vois le champ. Clique dessus → le glow apparaît.

---

### ÉTAPE 10 : `AnimatedButton`

**Ce que tu dois comprendre** :
- `SingleTickerProviderStateMixin` → fournit le `vsync` pour l'AnimationController
- `ScaleTransition` → le bouton rétrécit légèrement quand on appuie (feedback tactile)
- `GestureDetector` → `onTapDown` / `onTapUp` pour contrôler l'animation
- État `isLoading` → remplace le texte par un `CircularProgressIndicator`
- `isOutlined` → variante outline pour les boutons secondaires
- `AuthLinkButton` → widget compagnon pour les liens textuels ("Pas de compte ?")

**Workshop** : Affiche les 3 états côte à côte (normal, outlined, loading).

---

### ÉTAPE 11 : `AuthHeader`

**Ce que tu dois comprendre** :
- Animation d'entrée : `FadeTransition` + `SlideTransition` combinés
- `AnimationController` → contrôle la timeline de l'animation
- `CurvedAnimation` → applique une courbe d'accélération (easeOut, easeOutCubic)
- `Tween<Offset>` → définit le début et la fin du slide
- `_controller.forward()` dans `initState()` → l'animation démarre au build
- Le logo est un Container avec gradient + ombre + texte emoji ✝

**Workshop** : Tu verras l'animation se rejouer à chaque hot reload.

---

### ÉTAPE 12 : `StepIndicator`

**Ce que tu dois comprendre** :
- `List.generate(totalSteps * 2 - 1, ...)` → génère alternativement des cercles et des lignes
  - Index pair = cercle, index impair = ligne
- `AnimatedContainer` → transition fluide quand on change d'étape
- 3 états visuels : completed (rempli + check), current (ring + glow), future (dim)
- Les `BoxShadow` donnent de la profondeur au step actif

**Workshop** : Teste avec `currentStep: 0`, `1`, `2` pour voir les 3 états.

---

### ÉTAPE 13 : `SchoolDropdown`

**Ce que tu dois comprendre** :
- `showModalBottomSheet` → ouvre une feuille depuis le bas (pattern mobile natif)
- `FormField<String>` → wrapper pour intégrer la validation du formulaire
- La recherche filtre en temps réel avec `setState` local au sheet
- `isScrollControlled: true` → le sheet peut occuper plus de 50% de l'écran
- La `ListTile` avec `trailing: Icon(check)` → feedback visuel pour l'élément sélectionné
- `viewInsets.bottom` → gère le décalage quand le clavier s'ouvre

**Workshop** : Place le `SchoolDropdown` avec la liste `AppConstants.defaultSchools`. Tape dessus → le sheet s'ouvre.

---

### ÉTAPE 14 : `PasswordStrengthIndicator`

**Ce que tu dois comprendre** :
- `_calculateStrength()` → scoring basé sur les regex (majuscule, chiffre, spécial, longueur)
- 4 segments animés avec `AnimatedContainer` → chaque segment se colore progressivement
- `AnimatedSwitcher` → transition douce quand le label change
- Les couleurs suivent une sémantique universelle : rouge → orange → bleu → vert

**Workshop** : Affiche 4 instances avec des mots de passe de force croissante pour voir les 4 niveaux.

---

### ÉTAPE 15 : `LanguageSelector` et `ThemeSelector`

**Ce que tu dois comprendre** :
- `context.watch<LocaleProvider>()` → se reconstruit quand la locale change
- `context.watch<ThemeProvider>()` → se reconstruit quand le thème change
- `AnimatedContainer` → les tailles de points changent avec animation
- Tooltip → info bulle au survol (utile en web/desktop)
- `BoxShadow` conditionnelle → le dot actif a un glow

---

### ÉTAPE 16 : `LoginPage`

**Tu assembles maintenant tout ce que tu as construit.**

**Ce que tu dois comprendre** :
- `GlobalKey<FormState>` → identifie le formulaire pour la validation groupée
- `_formKey.currentState!.validate()` → déclenche TOUS les validators d'un coup
- `SafeArea` → évite les encoches et barres système
- `SingleChildScrollView` → le contenu scrolle quand le clavier s'ouvre
- `ConstrainedBox(maxWidth: 420)` → contraint la largeur pour tablettes/web
- Les validators retournent des clés i18n : `Validators.email(value)` → `'validation_email_invalid'` → `context.tr(key)`
- `Navigator.of(context).pushReplacementNamed(...)` → navigation par route nommée, sans retour

**Ordre de lecture du build** (de haut en bas = ce que l'utilisateur voit) :
1. Settings bar (langue + thème)
2. AuthHeader animé
3. Email field
4. Password field + toggle visibilité
5. "Mot de passe oublié" link
6. Bouton connexion
7. Séparateur "ou"
8. Bouton "Créer un compte"
9. Version en bas

---

### ÉTAPE 17 : `RegistrationPage`

**La page la plus complexe.**

**Ce que tu dois comprendre** :
- `PageView` + `PageController` → navigation horizontale entre les étapes
- `NeverScrollableScrollPhysics()` → interdit le swipe manuel (navigation par boutons uniquement)
- **3 `GlobalKey<FormState>`** → un par étape, pour valider chaque étape indépendamment
- `_nextStep()` :
  1. Valide le formulaire de l'étape courante
  2. Vérifie les champs non-formulaire (date, école)
  3. Anime vers la page suivante
- `animateToPage()` avec `Curves.easeInOutCubic` → transition fluide
- Le `DatePicker` natif Flutter est stylisé via le thème (pas de customisation manuelle)
- Le `PasswordStrengthIndicator` écoute `onChanged` du champ password pour se mettre à jour en temps réel
- Les `RichText` → permettent de mixer les styles dans un même paragraphe (pour "J'accepte les **Conditions**")

**Structure des 3 étapes** :

| Étape | Champs | Widgets utilisés |
|-------|--------|-----------------|
| 1 | Nom, Prénom, Date naissance | `CustomTextField` x2, `GestureDetector` + DatePicker |
| 2 | École, Email | `SchoolDropdown`, `CustomTextField` |
| 3 | Mot de passe, Confirmation, CGU | `CustomTextField` x2, `PasswordStrengthIndicator`, `Checkbox` |

---

### ÉTAPE 18 : `app.dart` et `main.dart`

**Ce que tu dois comprendre** :

**`main.dart`** :
- `WidgetsFlutterBinding.ensureInitialized()` → obligatoire avant tout appel async dans `main()`
- `SystemChrome.setPreferredOrientations(...)` → verrouille en portrait
- `MultiProvider` → injecte plusieurs providers en une seule fois
- Les providers sont créés ICI (au sommet) pour être disponibles partout

**`app.dart`** :
- `context.watch<ThemeProvider>()` → reconstruit le MaterialApp quand le thème change
- `LocaleScope` → injecte le système i18n dans l'arbre
- `routes: {...}` → association route nommée ↔ page
- `initialRoute` → la première page affichée

---

## 5. Concepts clés à maîtriser pour l'entretien

### Architecture
- **Pourquoi séparer `core/`, `features/`, `shared/` ?** → Modularité. Chaque feature est un module isolé. `core/` est la fondation partagée.
- **Pourquoi `domain/` séparé de `presentation/` ?** → Les validators sont testables sans Flutter. C'est le principe de Clean Architecture.
- **Pourquoi un fichier unique pour les routes API ?** → Single source of truth. Une modification impacte un seul fichier.

### State Management
- **Provider** → pattern Observer. `ChangeNotifier` + `notifyListeners()` + `context.watch()`.
- **Pourquoi Provider et pas Riverpod/Bloc ?** → Pour 2 providers (thème + locale), Provider est le bon choix. Pas d'over-engineering. On migrera si nécessaire.

### Widgets
- **StatelessWidget vs StatefulWidget** → Stateless quand il n'y a pas d'état mutable local. Stateful quand il y en a (focus, animation, toggle).
- **AnimationController + Tween + CurvedAnimation** → la triade de base des animations Flutter.
- **InheritedWidget** → le mécanisme natif de propagation de données dans l'arbre. Provider l'utilise sous le capot.

### Internationalisation
- **Pourquoi pas gen-l10n ?** → Pour 2 langues, un système custom basé sur Map est plus lisible et montre la compréhension du mécanisme (InheritedWidget + extension).
- **Pourquoi les validators retournent des clés et pas des strings traduits ?** → Séparation des responsabilités. Le domain ne dépend pas de l'UI.

### Thème
- **Pourquoi 3 thèmes ?** → Montre la maîtrise du système de thème Flutter et la flexibilité de l'architecture.
- **Pourquoi des tokens (spacing, radius) ?** → Cohérence visuelle. Un changement de token impacte toute l'app.

---

## 6. Commandes utiles

```bash
# Créer le projet
flutter create chf_app --org com.chf --platforms android,ios,web

# Installer les dépendances
flutter pub get

# Lancer l'app
flutter run

# Lancer le workshop directement
flutter run -t workshop/widget_workshop.dart

# Hot reload (dans le terminal où flutter run tourne)
r

# Hot restart (reset complet de l'état)
R

# Analyser le code (linting)
flutter analyze

# Lancer les tests
flutter test

# Build release Android
flutter build apk --release

# Build release iOS
flutter build ios --release

# Build web
flutter build web
```

---

## Résumé visuel de l'ordre de construction

```
     pubspec.yaml
          │
     ┌────┴────┐
     │  CORE   │
     └────┬────┘
          │
  ┌───────┼───────┐
  │       │       │
Colors  Routes   i18n
  │       │       │
Theme  Constants  │
  │       │       │
Provider  │       │
  │       │       │
  └───────┼───────┘
          │
    ┌─────┴─────┐
    │  WIDGETS  │
    └─────┬─────┘
          │
  ┌───┬───┼───┬───┬───┐
  │   │   │   │   │   │
Text Btn Hdr Step Drop Pwd
Field     er  Ind  down  Str
  │   │   │   │   │   │
  └───┼───┼───┼───┼───┘
      │   │   │   │
      └───┴───┴───┘
          │
    ┌─────┴─────┐
    │   PAGES   │
    └─────┬─────┘
          │
    ┌─────┼─────┐
    │           │
  Login    Registration
    │           │
    └─────┬─────┘
          │
    ┌─────┴─────┐
    │  APP.DART │
    └─────┬─────┘
          │
    ┌─────┴─────┐
    │ MAIN.DART │
    └───────────┘
```

Chaque niveau dépend uniquement des niveaux au-dessus. C'est le principe d'inversion de dépendance.
