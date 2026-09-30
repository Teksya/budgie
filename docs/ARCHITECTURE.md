# ARCHITECTURE

> Document technique. Stack, arborescence, modèle de données, règles de calcul.
> Dernière mise à jour : 2026-07-10

---

## 1. Stack

| Rôle | Choix | Pourquoi |
|---|---|---|
| Framework | Flutter 3.44.2 / Dart 3.12.2 | installé, canal stable |
| État | `flutter_riverpod` 3.x, **providers écrits à la main** | `riverpod_lint`/`riverpod_generator` sont incompatibles avec Riverpod 3 (conflit sur `analyzer`). Moins de codegen, moins de casse. |
| Base de données | `drift` + `drift_flutter` (SQLite) | typé à la compilation, migrations versionnées, requêtes réactives (`Stream`) |
| Navigation | `go_router` | routes déclaratives, deep-link vers l'ajout rapide |
| Couleur dynamique | `dynamic_color` | Material You |
| Graphiques | `fl_chart` | donut, barres, courbes |
| Notifications | `flutter_local_notifications` + `timezone` | rappels d'échéance |
| Biométrie | `local_auth` | déverrouillage |
| Formatage | `intl` | €, dates, locale fr_FR |
| Fichiers | `file_picker`, `path_provider`, `share_plus` | sauvegarde / restauration |
| Photos | `image_picker` | tickets |
| Chiffrement backup | `cryptography` | fichier `.budgetbak` |
| Tests | `flutter_test`, `mocktail`, `drift` in-memory | |

> Packages différés (ajoutés à la phase qui en a besoin) : `local_auth`, `file_picker`, `share_plus`, `image_picker`, chiffrement du backup.

**Règle sur l'argent** : jamais de `double`. Tous les montants sont des **`int` en centimes**. Un type `Money` (extension type, coût zéro) encapsule la valeur et le formatage. Les divisions (reste par jour) arrondissent explicitement.

**Règle sur les icônes** : elles sont persistées par **clé texte** (`'bolt'`, `'cart'`…) résolue via une `const Map` dans `shared/icons.dart`, jamais par `IconData.codePoint`. Construire une `IconData` à partir d'un entier lu en base casse le tree-shaking des icônes : le build release supprime le glyphe (carrés vides) ou échoue.

**Dette connue** : `dynamic_color` applique encore le Kotlin Gradle Plugin ; Flutter prévient que les versions futures refuseront de compiler. À surveiller (remplaçable par un canal de plateforme maison si le package n'est pas mis à jour).

---

## 2. Arborescence

```
lib/
├── main.dart
├── app/
│   ├── app.dart                 MaterialApp.router, thèmes, locale
│   ├── router.dart              go_router, shell des 4 onglets
│   └── theme/
│       ├── app_theme.dart       ColorScheme expressive, light/dark
│       ├── shapes.dart          rayons M3E, morphing
│       └── motion.dart          ressorts, durées
├── core/
│   ├── money.dart               type Money (centimes) + format €
│   ├── date_x.dart              bornes de période, jours restants
│   ├── result.dart
│   └── constants.dart
├── data/
│   ├── db/
│   │   ├── database.dart        @DriftDatabase, migration v1, seed
│   │   ├── enums.dart
│   │   ├── setting_keys.dart
│   │   ├── tables/              groupées par agrégat : core / ledger / planning
│   │   └── daos/                un DAO par agrégat
│   ├── seed/
│   │   └── default_categories.dart
│   └── repositories/            façade métier au-dessus des DAO
├── domain/
│   ├── models/                  entités pures (freezed)
│   └── services/
│       ├── period_service.dart      ouverture/clôture, report en cascade
│       ├── recurrence_service.dart  génération des échéances
│       ├── budget_engine.dart       ★ calcul du reste-à-vivre
│       └── notification_service.dart
├── features/
│   ├── dashboard/    { view, widgets, providers }
│   ├── transactions/
│   ├── budgets/
│   ├── charges/
│   ├── goals/
│   ├── debts/
│   ├── stats/
│   ├── settings/
│   └── lock/                    écran biométrique
└── shared/
    ├── widgets/                 AmountText, CategoryChip, ExpressiveFab, ProgressRing…
    └── extensions/
```

Découpage **feature-first**. Une feature ne dépend jamais d'une autre feature ; les dépendances vont vers `domain` puis `data`.

---

## 3. Modèle de données

Toutes les tables ont `id INTEGER PRIMARY KEY`, `createdAt`, `updatedAt`.
Les montants sont des `INTEGER` (centimes).

### `accounts`
`name`, `type` (courant|epargne|especes), `initialBalanceCents`, `iconCode`, `colorValue`, `archived`

### `categories`
`name`, `kind` (expense|income), `parentId` → `categories.id` (1 niveau max), `iconCode`, `colorValue`, `isSystem`, `sortOrder`

### `periods`
`startDate`, `endDate`, `status` (open|closed), `carryOverInCents`, `carryOverManualCents` (override), `closedAt`

> Une seule période `open` à la fois. `carryOverIn` de la période N = solde final de N-1, sauf si `carryOverManual` est renseigné.

### `transactions`
`date`, `type` (expense|income|transfer), `amountCents`, `sharedTotalCents` (nullable, dépense partagée), `categoryId`, `accountId`, `toAccountId` (virements), `periodId`, `note`, `receiptPath`, `incomeStatus` (planned|received), `recurrenceInstanceId` (nullable), `debtId` (nullable)

> `amountCents` est **toujours la part à ma charge**. `sharedTotalCents` n'est qu'informatif.

### `recurrences` — modèles de charges fixes, abonnements, salaires, mensualités
`name`, `type` (expense|income), `nature` (fixedCharge|subscription|salary|loanPayment), `categoryId`, `accountId`, `estimatedAmountCents`, `isVariable`, `frequency` (monthly|bimonthly|quarterly|biannual|annual), `dueDayOfMonth`, `startDate`, `endDate`, `active`, `debtId`

### `recurrence_instances` — échéances concrètes
`recurrenceId` (nullable → échéance ponctuelle), `periodId`, `dueDate`, `estimatedAmountCents`, `actualAmountCents` (nullable), `status` (pending|paid|late), `paidDate`, `transactionId`

> Le paiement d'une échéance crée une `transaction` et lie les deux.

### `budgets` — enveloppes
`periodId`, `categoryId`, `limitCents`, `rollover`, `rolloverInCents`

### `savings_goals`
`name`, `targetCents`, `targetDate`, `accountId`, `monthlyPlannedCents`, `archived`

### `goal_contributions`
`goalId`, `periodId`, `amountCents`, `date`

### `debts`
`name`, `kind` (credit|debtOwed|debtLent|installment), `principalCents`, `remainingCents`, `installmentCents`, `installmentsTotal`, `installmentsPaid`, `annualRateBps`, `startDate`, `endDate`

### `debt_payments`
`debtId`, `transactionId`, `date`, `amountCents`, `principalCents`, `interestCents`

### `settings` (clé/valeur)
`periodStartDay`, `themeMode`, `useDynamicColor`, `seedColor`, `biometricEnabled`, `notificationsEnabled`, `lastBackupAt`, `alertThresholdPercent`, `currency`, `language`, `dailyReminder`, `firstLaunchAt`, `backupReminderSnoozedUntil`

**Horloge de sauvegarde.** `lastBackupAt` est écrite à chaque export réussi (`BackupService.exportAndShare`, sauf si l'utilisateur ferme la feuille de partage). `firstLaunchAt` sert de point de départ tant qu'aucune sauvegarde n'a jamais été faite — sans elle, une installation neuve serait harcelée dès le premier jour. Le rappel se déclenche au-delà de 30 jours (`isBackupReminderDue`, fonction pure testée) ; « Plus tard » écrit `backupReminderSnoozedUntil` à +7 jours.

---

## 4. Règles de calcul

### 4.1 Bornes de période
`periodStartDay = 1` → 01/07 → 31/07.
`periodStartDay = 25` → 25/07 → 24/08.
Si le jour n'existe pas dans le mois (31 en février), on prend le dernier jour du mois.

### 4.2 Solde final d'une période
```
soldeFinal = carryOverIn
           + Σ revenus perçus
           − Σ dépenses
           − Σ échéances payées (via leur transaction)
```

### 4.3 Reste-à-vivre (`budget_engine.dart`)
```
resteAVivre = carryOverIn
            + Σ revenus (perçus + prévus)
            − Σ dépenses déjà effectuées
            − Σ échéances non payées   [réel si connu, sinon estimé]
            − Σ épargne planifiée non versée
```
`restePartJour = resteAVivre ÷ max(1, jours restants dans la période)`

### 4.4 Report en cascade
Modifier une transaction d'une période passée invalide le `carryOverIn` de toutes les périodes suivantes. `PeriodService.recomputeFrom(periodId)` les recalcule en chaîne, en respectant les `carryOverManual` qui coupent la chaîne.

### 4.5 Génération des échéances
À l'ouverture d'une période, `RecurrenceService.materialize(period)` crée une `recurrence_instance` pour chaque récurrence active dont une échéance tombe dans les bornes. Idempotent : rejouer ne duplique jamais (contrainte unique `(recurrenceId, dueDate)`).

### 4.6 Charges variables
`estimatedAmountCents` sert tant que `actualAmountCents` est nul. Après 3 occurrences réelles, si la moyenne s'écarte de plus de 15 % de l'estimé, l'app propose de réajuster.

---

## 5. Conventions

- Dart : `dart format`, `flutter analyze` sans warning, `very_good_analysis` en lints.
- Nommage : anglais dans le code, **UI bilingue fr/en** (§ 5.1).
- Un widget par fichier au-delà de 80 lignes.
- Pas de logique métier dans les widgets : tout passe par un provider qui appelle un service.
- Les DAO renvoient des `Stream` ; l'UI est réactive de bout en bout.
- Migrations Drift : jamais de `deleteAll` en prod, toujours une `MigrationStrategy` numérotée (§ 5.2).
- Tests obligatoires sur `budget_engine`, `period_service`, `recurrence_service`.
- **Jamais de `ref.read(unStreamProvider).value` dans un callback** (§ 5.3).

### 5.1 Localisation

Zéro chaîne d'UI en dur : tout passe par `lib/l10n/app_fr.arb` (template) et
`app_en.arb`, générés en classe `L` par `flutter gen-l10n`.

- **Widgets** : `L.of(context)`, gardé dans un `final l` en tête de `build`.
- **Sans `BuildContext`** (notifications, widgets d'accueil, raccourci du
  lanceur) : `translationsProvider`, qui résout la locale via
  `resolvedLocaleProvider` (réglage forcé, sinon langue de l'appareil, sinon
  anglais).
- **Libellés d'enums** : extensions dans `shared/labels.dart`, qui prennent un
  `L` en paramètre plutôt qu'un contexte, pour rester utilisables hors widgets.
- **Dates et montants** : aucun `DateFormat` ne reçoit de locale explicite. Ils
  suivent `Intl.defaultLocale`, posé par `AppCurrency.configure` depuis le
  réglage de langue. Le symbole monétaire vient de `AppCurrency.instance.symbol`,
  jamais d'un `'€'` en dur.
- **Catégories semées** : traduites **une fois**, au premier lancement, dans la
  langue de l'appareil (`defaultCategories(L)`). Ce sont ensuite des lignes
  utilisateur ordinaires — changer de langue ne les renomme pas, et c'est voulu.
  Corollaire : les presets de l'onboarding doivent référencer les mêmes clés
  `l.catXxx`, sinon ils ne retrouvent plus la catégorie en base.
- **Scanner de tickets** : les mots-clés OCR contiennent les deux langues en
  permanence — un ticket est imprimé par le commerçant, pas par le téléphone.

`test/l10n_test.dart` échoue si une clé n'existe que d'un côté ou si une
traduction anglaise est restée identique au français.

### 5.2 Ce qu'une mise à jour Play a le droit de faire aux données

- `onUpgrade` est **enveloppé dans une transaction** : Drift ne le fait pas, et
  n'écrit `user_version` qu'après un retour sans erreur. Sans la transaction,
  une migration qui échoue à mi-parcours laisse le schéma à moitié migré sous
  l'ancien numéro de version, et le lancement suivant rejoue la chaîne :
  `createTable` est idempotent (`IF NOT EXISTS`), **`addColumn` ne l'est pas** —
  boucle de crash définitive.
- Une base plus récente que le build (restauration d'une sauvegarde Android sur
  une version antérieure) est **refusée bruyamment** plutôt que réétiquetée à la
  baisse, ce qui corromprait en silence.
- Jamais de `DROP` ni de `delete()` dans `onUpgrade`. Une colonne devenue
  inutile se laisse en place.
- `driftDatabase(name: 'budget')` et l'`applicationId` sont **définitifs** :
  changer l'un ou l'autre est un effacement total côté utilisateur.
- Le filet de test est `test/migration_test.dart` : il fabrique une base au
  schéma v1, la fait migrer par le vrai `AppDatabase`, et vérifie que les
  données survivent, que l'échec revient en arrière, et que la rétrogradation
  est refusée. `drift_dev schema dump` serait l'outil normal, mais
  `drift_dev > 2.34.0` exige `analyzer 13`, incompatible avec le SDK Flutter
  épinglé — d'où le test écrit à la main.
- **Sauvegarde Android** déclarée explicitement dans le manifeste
  (`allowBackup="true"` + `backup_rules.xml` / `data_extraction_rules.xml`) :
  la base part chez Google au changement de téléphone. À déclarer dans *Data
  Safety* au même titre que la télémétrie ML Kit (D6).
- `BackupService` : toute table ajoutée au schéma doit l'être aussi dans le
  dump, sinon la restauration l'efface — un `assert` sur `allTables` le rappelle
  au prochain ajout (c'est ce qui était arrivé à `favorites`).

### 5.3 Lire une donnée depuis un callback (Riverpod 3)

Riverpod 3 **auto-dispose tous les providers par défaut**. Un provider n'est
vivant que tant qu'un `build` le `watch`. Conséquences dans un `onPressed`,
un `onTap` ou une méthode `Future<void> _faireUnTruc()` :

- `ref.read(unStreamProvider).value` vaut **toujours `null`** si rien n'écoute
  ce provider. Le `?? const []` qui suit masque le problème et l'action est
  annulée en silence — c'est ce qui empêchait « Payer » de fonctionner.
- `await ref.read(unStreamProvider.future)` ne sauve pas : sans écouteur, le
  stream n'est même pas abonné et le `Future` ne se résout jamais.

**Règle :** depuis un callback, on interroge le repository (requête one-shot,
ex. `AccountRepository.defaultId()`), pas un provider de stream. Les providers
de stream sont réservés au `build`.

---

## 6. Commandes

```bash
flutter pub get
dart run build_runner watch -d      # drift + riverpod + freezed
flutter run -d <device>
flutter analyze
flutter test
flutter build apk --release
```
