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
`periodStartDay`, `themeMode`, `useDynamicColor`, `seedColor`, `biometricEnabled`, `notificationsEnabled`, `lastBackupAt`, `alertThresholdPercent`

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
- Nommage : anglais dans le code, **français dans l'UI**.
- Un widget par fichier au-delà de 80 lignes.
- Pas de logique métier dans les widgets : tout passe par un provider qui appelle un service.
- Les DAO renvoient des `Stream` ; l'UI est réactive de bout en bout.
- Migrations Drift : jamais de `deleteAll` en prod, toujours une `MigrationStrategy` numérotée.
- Tests obligatoires sur `budget_engine`, `period_service`, `recurrence_service`.

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
