# AVANCEMENT

> **Fichier vivant.** Mis à jour à chaque fin de session. Si tu reprends après une pause, lis ce fichier en premier : il dit où on en est, ce qui vient après, et ce qui bloque.

**Dernière mise à jour :** 2026-07-10
**Phase en cours :** Phase 3 — Confort (terminée) → reste Phase 4 (finition)
**Progression globale :** ▰▰▰▰▰▰▰▰▰▰ ~95 %

> ⚡ **Fluidité :** l'app tourne désormais en **release** (AOT + Impeller). Les builds *debug* précédents saccadaient (JIT, pas d'optimisation) — c'était ça, pas le code. Rester en release pour tout test de fluidité.

---

## 🚦 État actuel

| | |
|---|---|
| Projet Flutter créé | ✅ `com.olivier.budget`, Android seul |
| Android configuré | ✅ minSdk/targetSdk/compileSdk **36** *(vérifié dans le manifeste fusionné)* |
| Dépendances | ✅ résolues |
| Base de données | ✅ 12 tables, migration v1, seed au 1er lancement |
| Thème Expressive | ✅ `DynamicSchemeVariant.expressive` + couleur dynamique |
| Navigation | ✅ 4 onglets + Réglages |
| `flutter analyze` | ✅ **0 problème** |
| `flutter test` | ✅ **27 tests au vert** (`Money`, `PeriodRange`) |
| APK debug | ✅ compile (`flutter build apk --debug`) |
| **App lancée et vue à l'écran** | ❌ **aucun appareil disponible** |

**Prochaine action concrète :** brancher un téléphone Android 16 en USB (débogage USB activé) et lancer `flutter run`. Tant que ça n'a pas tourné une fois, la Phase 0 n'est pas close.

---

## 🧱 Phases

### Phase 0 — Fondations
> Une app qui se lance, avec un thème correct, une navigation à 4 onglets et une base de données fonctionnelle.

- [x] Créer le projet Flutter (Android seul, `com.olivier.budget`)
- [x] `minSdk` / `compileSdk` / `targetSdk` 36, licences Android acceptées
- [x] `MainActivity` en `FlutterFragmentActivity` (requis par la biométrie)
- [x] Permissions + receivers de notifications dans le manifeste
- [x] Desugaring activé (requis par `flutter_local_notifications`)
- [x] Dépendances installées
- [x] `build_runner` opérationnel (Drift)
- [x] Type `Money` (centimes) + formatage € fr_FR + **13 tests**
- [x] `PeriodRange` : bornes de période configurables + **14 tests**
- [x] Thème M3 Expressive, clair/sombre, couleur dynamique, chiffres tabulaires
- [x] Formes et motion Expressive (`shapes.dart`, `motion.dart`)
- [x] `go_router` + `NavigationBar` à 4 onglets
- [x] Schéma Drift complet (12 tables) + migration v1 + `PRAGMA foreign_keys`
- [x] Seed : catégories par défaut, compte « Principal », période ouverte, réglages
- [x] `flutter analyze` sans aucun warning
- [x] **App compilée et installée sur le Pixel 10** (l'utilisateur teste lui-même — voir note ci-dessous)

> 📱 **Vérification runtime = l'utilisateur uniquement.** Il teste l'app à la main sur son téléphone. Je compile (`flutter analyze`, `flutter build apk`) et j'installe l'APK sur demande (`adb install`), mais je ne lance PAS `flutter test`, adb monkey, screencap, ni de tests de widgets. Appareil : Pixel 10, Android 17 (API 37).

---

### Phase 1 — MVP utilisable
> Tu peux vraiment gérer ton budget du mois. C'est le jalon qui compte.

- [x] `BudgetEngine` — calcul du reste-à-vivre (moteur pur, 15 tests)
- [x] `PeriodService` — ouverture/clôture + recalcul du report **en cascade** (tests)
- [x] `RecurrenceService.materialize()` — génération **idempotente** des échéances (tests)
- [x] **Périodes** : ouverture automatique au lancement, report calculé
- [x] **Transactions** : saisie sur **page dédiée** (`/add`), liste groupée par jour, suppression (appui long)
- [x] **Revenus** : sources via catégories, statut prévu/perçu
- [x] **Dashboard** : reste-à-vivre réel animé, pastille d'état, reste/jour, prochaines échéances, dernières transactions
- [x] **Récurrences** : ajout de charge fixe / abonnement (page dédiée), montant fixe ou variable
- [x] **Échéances** : onglet Budgets — à payer / payées, « marquer payé » avec saisie du montant réel, annulation
- [x] **Catégories** : écran de gestion complet (onglets Dépenses/Revenus, créer/modifier/supprimer, sélecteur d'icône + couleur, sous-catégories) — pages dédiées, pas de feuille modale
- [x] **Réglages** : thème clair/sombre/système, couleurs dynamiques, **jour de début de période** (curseur 1→28), accès aux catégories
- [x] **Historique** : navigation mois par mois (accessible depuis l'accueil), détail complet (report entrant, revenus, dépenses, charges, solde de fin), suppression rétroactive avec recalcul en cascade, **correction manuelle du report**
- [x] **Salaire récurrent** : revenu qui se matérialise en revenu **prévu** chaque mois (idempotent), modifiable au cas par cas (appui sur le revenu → ajuster le montant / marquer perçu). Créé depuis l'onglet Budgets (icône carte). Migration Drift **v2** : colonne `transactions.recurrenceId`.
- [x] **Comptes** : écran de gestion complet (créer/modifier/supprimer, type, icône, couleur, solde initial), **solde calculé en direct** (initial + revenus perçus − dépenses ± virements). Suppression du dernier compte bloquée.

🎯 *Fin de phase 1 = application réellement utilisable au quotidien.* → **atteint pour l'usage courant.**

### Finitions Phase 1 — ✅ faites
- [x] **Gérer les récurrences existantes** : page dédiée (Réglages → Charges & revenus récurrents), éditer / activer-désactiver / supprimer
- [x] **Éditer une transaction** : appui sur une transaction → page d'édition (montant, catégorie, date, note, compte)
- [x] **Virements** entre comptes : 3ᵉ mode dans la page de saisie (Depuis → Vers), ignorés du reste-à-vivre, pris en compte dans les soldes de comptes

> Note archi : `riverpod_generator` abandonné (incompatible Riverpod 3) → providers manuels. `rxdart` pour combiner les streams. `meta` pour `@immutable` côté domain. Migration Drift v2 (ajout colonne, non destructrice) validée.

---

### Phase 2 — Pilotage
- [x] **Enveloppes** : plafond par catégorie (onglet Budgets), barre de progression, dépenses des sous-catégories comptées dans l'enveloppe du parent, couleur d'alerte à 80 % / 100 %, option rollover, éditer/supprimer
- [x] **Objectifs d'épargne** : cible, date, montant mensuel réservé, contributions, barre de progression (accès via l'icône tirelire de l'onglet Budgets)
- [x] Épargne planifiée intégrée au reste-à-vivre (le montant mensuel réservé est déduit)
- [x] **Stats** : donut des dépenses par catégorie + barres revenus/dépenses (jusqu'à 12 mois) — onglet Stats
- [x] **Notifications locales** : rappel J-3 et jour J pour chaque charge à payer, activable dans Réglages (demande la permission Android), synchro auto quand les charges changent, défensif (jamais de plantage si refusé). *Programmation « inexacte » → pas besoin de la permission alarme exacte ; l'heure exacte des rappels reste à vérifier on-device.*
- [x] **Historique par charge variable** : Réglages → récurrences → menu « Historique & moyenne » d'une charge variable → graphique des montants réels + moyenne + bouton « réajuster l'estimé » si l'écart dépasse 15 %
- [x] Duplication automatique des enveloppes d'un mois sur l'autre (avec report du non-dépensé pour les enveloppes en rollover)

---

### Phase 3 — Confort ✅
- [x] **Dettes & crédits** (Réglages → Dettes & crédits) : crédits, paiements en N fois, « on me doit », capital restant dû, barre de progression, « payer une échéance » qui crée une dépense
- [x] **Verrouillage biométrique** (`local_auth` 3.x) : empreinte ou code appareil, re-verrouillage au retour arrière-plan, toggle dans Réglages
- [x] **Sauvegarde / restauration** chiffrée `.budgetbak` (AES-GCM + PBKDF2, `cryptography`) : export partagé via `share_plus`, restauration avec mot de passe qui remplace toutes les données
- [x] **Photo de ticket** sur une dépense (`image_picker`, copiée dans le dossier de l'app)
- [x] **Dépenses partagées** : interrupteur, montant = ma part, champ montant total
- [x] ~~Import CSV~~ — **retiré le 2026-07-10** : jugé trop technique pour une app grand public (décision produit). Service + dépendance `csv` supprimés. La sauvegarde/restauration reste.
- [x] **Basculement de solde** entre comptes (ex-« Virement », renommé pour la clarté grand public) + affichage distinct dans la liste
- [ ] Rappel de sauvegarde à 30 jours (mineur, non fait)

> Résolution de dépendances : `file_picker` forcé en ^10.3.3 et `share_plus` en 12.0.2 (conflit win32 : file_picker 8–11 veut win32 ^5, share_plus 13 veut ^6 ; sans intérêt sur Android mais bloque le solveur). `file_picker` 3.0.4 (résolu par défaut) cassait le build Gradle via `jcenter()`.

---

### Phase 4 — Finition
- [x] **Onboarding grand public complet** (`OnboardingFlow`) : accueil chaleureux → jour de début de mois → salaire → charges fixes pré-cochées (loyer/élec/eau/internet/téléphone/assurance) → 1re enveloppe (facultative) → notifs + biométrie → « C'est parti ». Points de progression, ton encourageant.
- [x] ~~Mode démo~~ — **retiré à la demande de l'utilisateur** (bouton données d'exemple + `loadDemo` supprimés). « Repartir de zéro » (Réglages → Données) reste pour relancer l'onboarding.
- [x] Accueil repensé : 4 points forts (reste à vivre / charges auto / alertes / privé hors-ligne) au lieu du bouton démo.
- [x] Bug **boîte grise** onboarding corrigé : le `Slider` plantait faute d'`Overlay` (l'onboarding est rendu hors du Navigator via `MaterialApp.builder`). Fix : `Overlay` fourni au gate + écran du jour refait sans Slider (`_DayPicker` gros chiffre + −/+ + raccourcis).
- [x] **Animations** : `SplashScreen` (logo qui pulse), `Shimmer`/`SkeletonList` (chargements dashboard + transactions), `FadeSlideIn` (apparition des cartes du dashboard), transition fondue onboarding→app. État vide guidé « Note ta première dépense ».
- [x] Migration Drift **v3** : `onboarded` mis à `true` pour les installs existantes (elles ne repassent pas par l'accueil) ; `AppDatabase.wipeAndReseed()` pour la réinitialisation.
- [x] **FAB expressif maison** (`ExpressiveFab`) : press → ressort avec overshoot (`SpringSimulation`), sur Accueil/Transactions/Budgets
- [x] **Accessibilité** (amorce) : `Semantics` sur le reste-à-vivre (phrase parlée propre au lieu des chiffres animés)
- [x] Shimmer de chargement sur Budgets (comme Transactions/Dashboard)
- [ ] Shimmer sur les pages restantes (Stats, Objectifs, Dettes, Comptes, Catégories)
- [ ] Passe accessibilité complète (audit contrastes, mise à l'échelle du texte, labels partout)
- [ ] Autres composants Expressive (`ButtonGroup`, `SplitButton`) si besoin
- [ ] **APK release signé** pour distribution (clé de signature, nom/package définitifs) — nécessite tes choix
- [ ] Animations de montants, transitions à ressort
- [ ] Écrans vides, états de chargement, gestion d'erreur
- [ ] Accessibilité : contrastes, tailles de police, lecteur d'écran
- [ ] Performance : profilage des listes longues
- [ ] Build release signé, APK installable

---

## 🧩 Décisions

| # | Question | Statut |
|---|---|---|
| D1 | `minSdk 36` (Android 16 uniquement) | 🟢 **tranché** — assumé |
| D2 | Début de période = **1er du mois**, modifiable dans les réglages | 🟢 tranché |
| D3 | Salaire net habituel, pour pré-remplir la récurrence ? | 🟡 en attente |
| D4 | `riverpod_generator` abandonné (incompatible Riverpod 3) → providers manuels | 🟢 tranché |
| D5 | `dynamic_color` applique encore KGP ; Flutter prévient d'un futur échec de build | 🟡 à surveiller |

---

## 📓 Journal

### 2026-07-10 — Phase 4 (1/n) : onboarding + mode démo
- Décision produit : **app grand public hors-ligne à saisie manuelle**. Import CSV retiré, « Virement » renommé « Basculer ».
- **Onboarding** : `OnboardingFlow` (PageView 6 étapes, ton chaleureux), `OnboardingService.completeSetup` (écrit période/salaire/charges/enveloppe + `materialize`), `loadDemo` (mois d'exemple), `resetAll`/`wipeAndReseed`. Gate dans `app.dart` sur `onboardedProvider`. Migration v3 pour marquer les anciens users comme onboardés.
- `flutter analyze` : 0 problème. Désactivé `avoid_escaping_inner_quotes` (apostrophes françaises).
- **À tester on-device (utilisateur)** : parcours d'onboarding via « Repartir de zéro », bouton données d'exemple, activation notifs/biométrie en fin de parcours.

### 2026-07-10 — Phase 3 terminée
- **Biométrie** : `AuthService` (local_auth 3.x, API changée : flags directs, plus de `AuthenticationOptions`), `AppLock` qui gate toute l'app et re-verrouille au `paused`.
- **Dépenses partagées + photo de ticket** : intégrées à la page de saisie (colonne `sharedTotalCents` déjà prévue ; photo copiée dans `receipts/`).
- **Dettes & crédits** : `DebtRepository` (paiement → dépense + `debt_payment` + capital décrémenté + soldé auto), pages liste + ajout.
- **Sauvegarde chiffrée** : `BackupService` dump JSON de toutes les tables → AES-GCM (clé PBKDF2), fichier `.budgetbak` partagé ; restauration wipe + réinsertion via les `fromJson` générés.
- **Import CSV** : `CsvImportService` (csv 8, `CsvDecoder` auto-détection du séparateur).
- Galère de résolution : `file_picker` 3.0.4 par défaut cassait Gradle (`jcenter()`) → forcé ^10.3.3, ce qui a imposé `share_plus` 12 (conflit win32). Build release OK, installé.
- `flutter analyze` : 0 problème.
- **À vérifier on-device (utilisateur)** : prompt biométrique, prise de photo, partage du fichier de sauvegarde, sélection de fichier pour restauration/CSV.

### 2026-07-10 — Phase 2 terminée
- **Notifications locales** (`flutter_local_notifications` + `timezone`) : service défensif (tout est try/catch, ne plante jamais), init au démarrage, toggle dans Réglages avec demande de permission Android 13+, widget `NotificationSync` qui reprogramme les rappels J-3/J quand les charges changent. Programmation `inexactAllowWhileIdle` pour éviter la permission d'alarme exacte. **À vérifier on-device par l'utilisateur : réception effective des rappels.**
- **Historique par charge variable** : `RecurrenceRepository.watchHistory` + `ChargeHistoryPage` (graphe fl_chart des montants réels, moyenne, réajustement de l'estimé si dérive > 15 %).
- **Duplication des enveloppes** : `PeriodService._carryEnvelopes` recopie les enveloppes au changement de mois, avec report du reste pour celles en rollover.
- `flutter analyze` : 0 problème. Build release installé.

### 2026-07-10 — Finitions Phase 1 + gros de la Phase 2
- **Finitions Phase 1** : édition de transaction, virements entre comptes (3ᵉ mode de saisie), page de gestion des récurrences (éditer/désactiver/supprimer charges & salaires).
- **Phase 2** : enveloppes de budget (progression + alerte 80/100 %, sous-catégories agrégées, rollover), objectifs d'épargne (cible/date/mensuel réservé/contributions, intégré au reste-à-vivre), stats (donut catégories + barres revenus/dépenses via `fl_chart`).
- Tous les écrans « à venir » des onglets Budgets et Stats sont désormais réels ; le `PlaceholderPage` n'est plus utilisé.
- `flutter analyze` : 0 problème. Build release installé sur le Pixel.
- **Reste Phase 2** : notifications locales (échéances, dépassement d'enveloppe) — repoussé car nécessite un test des permissions on-device (côté utilisateur) ; historique par charge variable ; duplication auto des enveloppes.

### 2026-07-10 — Cadrage + Phase 0
**Cadrage**
- 36 questions posées, réponses obtenues. Rédaction de `SPEC.md`, `ARCHITECTURE.md`, `CLAUDE.md`.
- Environnement vérifié : Flutter 3.44.2, Dart 3.12.2, Android SDK 36.
- Vérifié **dans les sources du SDK** : `DynamicSchemeVariant.expressive`, `Durations`/`Easing`, `CarouselView` sont disponibles ; `ButtonGroup`, `SplitButton`, `FabMenu`, `LoadingIndicator` **ne sont pas dans le canal stable** → reconstruits à la main en phase 4.

**Fondations**
- Projet créé, Android configuré (minSdk 36, desugaring, `FlutterFragmentActivity`, permissions, receivers).
- `Money` : extension type sur `int` (centimes), opérateurs, `dividedBy` qui ne divise jamais par zéro, formatage `fr_FR`.
- `PeriodRange` : période à jour de départ configurable, clampée aux mois courts (un départ le 31 tombe au 28 en février), bornes inclusives.
- Thème : `DynamicSchemeVariant.expressive`, palette dynamique harmonisée, rayons différenciés 8→36dp, chiffres tabulaires partout.
- Schéma Drift : 12 tables, clés étrangères activées (`PRAGMA foreign_keys = ON` — off par défaut dans SQLite), contrainte d'unicité `(recurrenceId, dueDate)` qui rend la génération d'échéances idempotente.
- Seed au premier lancement : 6 catégories de revenus, 16 de dépenses dont 12 sous-catégories, compte « Principal », période de juillet 2026 ouverte, réglages par défaut.

**Vérifications réelles (pas des suppositions)**
- `flutter analyze` → 0 problème.
- `flutter test` → 27 tests au vert.
- `flutter build apk --debug` → succès.
- Manifeste fusionné inspecté : `minSdkVersion="36"`, `targetSdkVersion="36"`, `USE_BIOMETRIC` présente, receiver de notifications présent, `INTERNET` **uniquement en debug** (la promesse hors-ligne tient en release).
- Format monétaire sondé au niveau des octets : `fr_FR` utilise U+202F (séparateur de milliers) et U+00A0 (avant le €). Le test vérifie la propriété « aucun espace ASCII » plutôt que de coller des caractères invisibles.

**Non fait**
- L'app n'a **jamais été lancée** : aucun appareil ni émulateur disponible. Le dashboard affiche pour l'instant un reste-à-vivre à 0 € et trois voyants de vérification (base de données, catégories, comptes) qui prouveront le seed au premier lancement.

---

## 🔧 Mémo commandes

```bash
flutter pub get
dart run build_runner watch -d   # à laisser tourner pendant le dev
flutter run                      # téléphone branché en USB
flutter analyze
flutter test
flutter build apk --release
```
