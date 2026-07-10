# Projet — Gestion de Budget (Flutter, Android, hors ligne)

## Documents de référence — à lire avant toute chose
1. `docs/AVANCEMENT.md` — **où on en est, quoi faire ensuite, ce qui bloque.** Toujours en premier.
2. `docs/SPEC.md` — le quoi (fonctionnel, écrans, règles produit).
3. `docs/ARCHITECTURE.md` — le comment (stack, arborescence, modèle de données, formules).

## Règles de tenue de la doc
- **À chaque fin de session** : cocher les cases faites dans `AVANCEMENT.md`, mettre à jour l'en-tête (date, phase, %), ajouter une entrée datée au Journal.
- Toute décision produit va dans `SPEC.md` ; toute décision technique dans `ARCHITECTURE.md`. Jamais dans un commentaire de code.
- Une décision en attente se note dans le tableau « Décisions » avec un statut 🔴/🟡/🟢.
- Ne jamais cocher une case sans avoir vérifié que ça marche réellement (l'app se lance, le test passe).

## Règles de code
- Les montants sont des **`int` en centimes**, jamais des `double`. Type `Money` obligatoire.
- Code et noms en **anglais**, interface utilisateur en **français** (locale `fr_FR`, devise EUR).
- Pas de logique métier dans les widgets : widget → provider Riverpod → service → repository → DAO.
- Feature-first : une feature ne dépend jamais d'une autre feature.
- `flutter analyze` doit rester à zéro warning.
- Tests obligatoires sur `domain/services/` (`budget_engine`, `period_service`, `recurrence_service`).
- Après modification d'une table Drift ou d'un provider : `dart run build_runner build -d`.
- Migrations Drift numérotées, jamais destructrices.

## Contexte utile
- Android uniquement, `minSdk 36`, aucun backend, aucune donnée ne quitte l'appareil.
- Flutter 3.44.2 / Dart 3.12.2. Les widgets M3 Expressive (`ButtonGroup`, `SplitButton`, `FabMenu`, `LoadingIndicator`) **n'existent pas** dans ce canal : ne pas tenter de les importer, ils sont reconstruits à la main.
