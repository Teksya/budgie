# AVANCEMENT

> **Fichier vivant.** Mis à jour à chaque fin de session. Si tu reprends après une pause, lis ce fichier en premier : il dit où on en est, ce qui vient après, et ce qui bloque.

**Dernière mise à jour :** 2026-07-31
**Phase en cours :** Phase 4 — Finition
**Progression globale :** ▰▰▰▰▰▰▰▰▰▰ ~98 %

> ⚡ **Fluidité :** l'app tourne désormais en **release** (AOT + Impeller). Les builds *debug* précédents saccadaient (JIT, pas d'optimisation) — c'était ça, pas le code. Rester en release pour tout test de fluidité.

---

## 🚦 État actuel

| | |
|---|---|
| Projet Flutter créé | ✅ **`com.olivierd.budgie`** (renommé le 2026-07-14 pour Play), Android seul |
| Android configuré | ✅ minSdk/targetSdk/compileSdk **36** *(vérifié dans le manifeste fusionné)* |
| Dépendances | ✅ résolues |
| Base de données | ✅ 13 tables, schéma **v7**, seed au 1er lancement |
| Thème Expressive | ✅ `DynamicSchemeVariant.expressive` + couleur dynamique |
| Navigation | ✅ 4 onglets + Réglages |
| Langues | ✅ **français + anglais complets** (~440 clés, parité vérifiée par test) |
| `flutter analyze` | ✅ **0 problème** |
| `flutter test` | ⚠️ **118 au vert** (`core` + `domain` + migrations + l10n + rappel de sauvegarde + anneau) ; 1 test widget préexistant bloqué — voir « Connu, non résolu » |
| APK release | ✅ compile (`flutter build apk --release`) |
| **App lancée sur le Pixel 10** | ✅ (l'utilisateur teste lui-même) |
| **Émulateur `Budgie_API36`** | ✅ parcours complet rejoué le 2026-07-27 (AVD Android 16, locale `fr-FR`) |

**Prochaine action concrète :** rejouer l'onboarding **en anglais** sur l'AVD (les presets de charges doivent retrouver les catégories semées en `en`), puis trancher **D3** (salaire net) et produire l'**APK release signé**.

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
- [x] **Rappel de sauvegarde à 30 jours** : `lastBackupAt` (clé qui existait mais n'était jamais écrite) renseignée à chaque export réussi ; carte sur l'accueil passé 30 jours sans sauvegarde, « Plus tard » = silence 7 jours. Règle isolée dans `isBackupReminderDue` (fonction pure, 8 tests). Migration Drift **v5** : horloge `firstLaunchAt`, non destructrice

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
- [x] Shimmer sur les pages restantes (Stats, Objectifs, Dettes, Comptes, Catégories) — *était en fait déjà fait et câblé ; case cochée après vérification le 2026-07-14*
- [x] **Passe accessibilité** : libellés (4 boutons-icônes muets, dont 2 flèches « retour » qui perdaient le tooltip de `BackButton`), 4 barres de progression rendues parlantes (`semanticsLabel`/`semanticsValue`), les 2 graphiques `fl_chart` annoncés au lecteur d'écran (le graphe de barres n'avait aucun équivalent texte), barre « Dépenses rapides » qui ne coupe plus au grossissement du texte. **Contrastes : ratios WCAG calculés, tout passe AA (4,64 → 13,86:1) en clair et en sombre — aucun changement nécessaire.**
- [ ] Autres composants Expressive (`ButtonGroup`, `SplitButton`) si besoin
- [x] **Accueil : l'anneau remplace la barre** (2026-07-27). `BudgetRing` (`lib/shared/widgets/budget_ring.dart`, `fl_chart` déjà en dépendance) : arcs = catégories réellement dépensées (4 max, le reste replié dans « Autres ») + « À payer » + « Libre », reste-à-vivre au centre, légende dessous. Le donut de Stats a été réécrit sur le même widget. `centerSpaceColor: transparent` obligatoire : par défaut `fl_chart` peint un disque pâle qui, sur une carte teintée, se lit comme un second anneau.
- [x] **Onboarding : étape abonnements** (2026-07-27). 24 plateformes en `const` (`subscription_presets.dart`), **vrais logos, les 24** : 17 via `simple_icons` (police tree-shakée, 1,4 Mo → 4,8 Ko ; couleur et glyphe viennent tous deux du même paquet, donc ils ne peuvent pas diverger), 7 en PNG 144 px sous `assets/brands/` (~61 Ko) pour les marques que leur détenteur a fait retirer de Simple Icons. **Aucun appel réseau** : les PNG sont téléchargés une fois à l'écriture du code et commités — une API de logos ferait fuiter vers un tiers la liste des marques tapées par l'utilisateur. Tap → feuille (date de prélèvement sur calendrier + montant pré-rempli) → `Recurrence` en `RecurrenceNature.subscription` (valeur qui existait en base et n'était jamais utilisée).
- [x] **Onboarding : dates réelles + budgets multiples + récap** (2026-07-27). Le jour de prélèvement des charges était **codé en dur** (loyer = le 5) et jamais demandé → bouton date par ligne cochée. L'étape enveloppe passe de 1 à N (Courses / Restaurant / Loisirs / Transport + une catégorie libre). Nouvelle dernière étape « Voilà ton mois » : le même anneau, construit sur les réponses locales, avec alerte si les charges dépassent le revenu. 8 étapes au total.
- [x] **Préparation Play** (2026-07-14) : `minSdk` 31, `signingConfig` release câblé sur `android/key.properties` (hors dépôt), `SCHEDULE_EXACT_ALARM` retirée du manifeste fusionné (permission restreinte : elle aurait fait recaler la fiche, et le code n'a jamais programmé qu'en `inexact`). Bundle `.aab` produit (77,9 Mo).
- [x] **Keystore créé** + `.aab` **signé avec la clé d'upload** (certificat vérifié : `CN=Olivier Dutoit, O=Budgie`, valide jusqu'en 2053). Package renommé **`com.olivierd.budgie`** (sources Kotlin déplacées + constantes `home_widget_sync.dart` mises à jour, sinon les widgets d'accueil cassaient en silence).
- [x] **Visuels Play** (2026-07-27) : `store/play/` — image de présentation 1024×500, 7 captures 1080×1920, icône 512×512. Générés par `store/make_store.py` (Pillow) à partir de `store/screens/` et de `assets/icon/icon.png` ; charte = le dégradé violet du logo, typo Roboto (celle de l'app, prise dans le SDK Flutter). Captures faites en release sur l'AVD avec le **mode démo SysUI** (barre d'état propre) et une base de démo injectée en SQL. Relancer : `python store/make_store.py`.
- [x] **Sécurité des mises à jour** (2026-07-28) : `onUpgrade` transactionnel + garde anti-rétrogradation, `favorites` réintégrée à la sauvegarde, sauvegarde Android déclarée explicitement, 3 tests de migration. Voir ARCHITECTURE § 5.2
- [x] **Anglais complet** (2026-07-28) : 402 clés fr/en, parité testée, dates/devise/catégories semées suivent la langue. Voir ARCHITECTURE § 5.1
- [ ] Fiche Play : Data Safety (déclarer la télémétrie ML Kit **et la sauvegarde Android**, cf. D6), politique de confidentialité, classification du contenu
- [ ] **Sauvegarder le keystore hors de ce PC** (`~/budgie-upload.jks` + mot de passe). Le perdre = ne plus jamais pouvoir mettre à jour l'app.
- [ ] Animations de montants, transitions à ressort
- [ ] Écrans vides, états de chargement, gestion d'erreur
- [ ] Accessibilité : contrastes, tailles de police, lecteur d'écran
- [ ] Performance : profilage des listes longues
- [ ] Build release signé, APK installable

---

## 🧩 Décisions

| # | Question | Statut |
|---|---|---|
| D1 | ~~`minSdk 36`~~ → ~~`31`~~ → **`minSdk 26`** (Android 8+), abaissé le 2026-07-28 pour la portée Play. Rien dans l'app n'exigeait 31 : la couleur dynamique retombe seule sur la palette de seed, tous les plugins tiennent en 21+, et le plancher de Flutter est 24 | 🟢 **tranché** — révisé 2× |
| D9 | `USE_FINGERPRINT` (injectée par `local_auth`, morte depuis l'API 28) retirée au merge : Play la traduisait en `android.hardware.fingerprint` **requis** et écartait du catalogue tout appareil sans lecteur d'empreinte. `android.hardware.fingerprint` est désormais déclarée `required="false"` | 🟢 tranché |
| D6 | Permission `INTERNET` en release (télémétrie ML Kit) : on garde le scanner et on l'assume dans la doc + Data Safety | 🟢 tranché |
| D10 | Sauvegarde Android (`allowBackup`) : **gardée activée** et déclarée explicitement au manifeste. La base part chez Google au changement de téléphone (chiffrée de bout en bout par le code de verrouillage) ; l'alternative `false` faisait perdre tout l'historique à qui n'a jamais exporté de `.budgetbak`. **À déclarer en Data Safety avec D6** | 🟢 tranché 2026-07-28 |
| D11 | Langue de l'UI : **fr + en**, réglage `system`/`fr`/`en`. Les catégories semées sont traduites une fois au 1ᵉʳ lancement puis deviennent des données utilisateur — changer de langue ne les renomme pas | 🟢 tranché 2026-07-28 |
| D7 | Clé de signature Play : keystore `budgie-upload.jks` créé (alias `upload`, hors dépôt), `android/key.properties` gitignoré | 🟢 tranché |
| D8 | `applicationId` = **`com.olivierd.budgie`** — définitif dès la 1ʳᵉ publication, ne pourra plus jamais changer | 🟢 tranché |
| D2 | Début de période = **1er du mois**, modifiable dans les réglages | 🟢 tranché |
| D3 | Salaire net habituel, pour pré-remplir la récurrence ? | 🟡 en attente |
| D4 | `riverpod_generator` abandonné (incompatible Riverpod 3) → providers manuels | 🟢 tranché |
| D5 | `dynamic_color` applique encore KGP ; Flutter prévient d'un futur échec de build | 🟡 à surveiller |

---

## 🐛 Connu, non résolu

- **`test/widget/dashboard_flow_test.dart` se bloque** (timeout 10 min sur « dashboard renders the reste-à-vivre »). **Préexistant** : vérifié en rejouant le test sur le commit d'origine, il échoue à l'identique — ce n'est pas une régression du 2026-07-14. Les 2 autres tests du fichier passent. Piste : le test mélange `NativeDatabase` (I/O réelle) et l'horloge simulée de `testWidgets`, donc le stream Drift ne se résout jamais. Les 69 autres tests (`core`, `domain`) sont au vert.

---

## 📓 Journal

### 2026-07-31 — « Payer » ne faisait rien (Riverpod 3)

Valider une échéance ne changeait rien : ni statut, ni dépense, ni reste à vivre. Les écrans lisaient le compte à débiter avec `ref.read(accountsProvider).value ?? const []` depuis un callback de bouton. **Riverpod 3 auto-dispose les providers par défaut** : hors d'un `build` qui le `watch`, ce `.value` est toujours `null`, la liste tombait à vide, `accountId` à `null`, et le `if` autour de `markPaid` avalait le paiement en silence. Aucune erreur nulle part.

Corrigé à la source par `AccountRepository.defaultId()` — une requête one-shot, pas un stream. `ref.read(p.future)` ne suffit pas : sans écouteur, Riverpod 3 n'abonne même pas le stream et le `Future` ne se résout jamais (vérifié en test, timeout à 30 s). Trois appelants réparés : paiement d'échéance, paiement de dette, acceptation d'une suggestion de récurrence.

Vérifié sur émulateur (release, API 36) : loyer 800 € → *Payée*, reste à vivre 849 € → 49 €, dépense visible dans l'historique, *Annuler* remet tout en place. Test de non-régression : `test/widget/charge_payment_test.dart`.

**Bundle 0.4.0 (versionCode 5)** — `pubspec.yaml` passé de `0.3.0+4` à `0.4.0+5` : le bundle du 28/07 portait déjà le 4, et ce binaire-ci est différent (il contient le correctif). Deux binaires ne partagent jamais un versionCode. Les notes de version de `store/play/release-notes/` datent du 0.3.0 et décrivent des fonctionnalités jamais publiées — elles restent valables pour le 0.4.0, à compléter d'une ligne sur le correctif si le 0.3.0 n'est jamais sorti.

**⚠️ Test cassé, non lié :** `dashboard_flow_test.dart › dashboard renders the reste-à-vivre` échoue sur `A Timer is still pending even after the widget tree was disposed`, puis timeout à 10 min. Reproduit avec une sonde minimale (un `testWidgets` + `ProviderScope` + un `ref.watch` de stream, zéro code métier) : c'est l'auto-dispose de **Riverpod 3 qui laisse un timer en vol**, incompatible avec le harness `testWidgets`. Les tests en `test()` pur ne sont pas touchés. À traiter à part.

### 2026-07-28 — Bundle 0.3.0 (versionCode 4)

`.aab` signé produit et vérifié : `versionCode=4`, `versionName=0.3.0`, `package=com.olivierd.budgie`, `minSdkVersion=26`, `allowBackup=true`. Signé par la clé d'upload (`META-INF/UPLOAD.RSA`, `CN=Olivier Dutoit, O=Budgie`, valide jusqu'en 2053). 79,1 Mo.

Notes de version dans `store/play/release-notes/` (`fr-FR.txt` 486 car., `en-US.txt` 458 car. — la limite Play est de 500 par langue). Contenu vérifié feature par feature dans le code avant rédaction, pas depuis la liste des tâches.

**Rappel avant de publier** — bloquants côté fiche, pas côté binaire :
- Data Safety : déclarer la télémétrie ML Kit (D6) **et** la sauvegarde Android (D10).
- Politique de confidentialité, classification du contenu.
- Sauvegarder le keystore hors de ce PC.

### 2026-07-28 — Page Stats refaite

L'ancienne page répondait à « sur quoi j'ai dépensé » mais jamais à « est-ce que c'est beaucoup », qui est la question qu'on se pose en ouvrant des stats. Tout est désormais cadré par rapport à quelque chose.

- **Plage sélectionnable** : 1 / 3 / 6 / 12 mois (des `ChoiceChip`, pas un `SegmentedButton` — quatre libellés français ne tiennent pas en largeur). Elle pilote toute la page.
- **Trois chiffres en tête** : revenu, dépenses, épargné ou déficit, plus la **moyenne mensuelle** dès qu'il y a plus d'un mois.
- **Par catégorie** : l'anneau, puis une ligne classée par catégorie avec **barre proportionnelle** (échelle sur la plus grosse, sinon les petites disparaissent) et **variation vs la période précédente de même longueur**. C'est le vrai apport : un pourcentage seul ne dit pas si ça monte.
- **Ce qui revient le plus** : les notes vues au moins deux fois, avec le nombre d'occurrences. Une catégorie dit « courses » ; ça dit dans quel magasin.
- **Le graphe a enfin un axe.** Sans échelle, une grande barre verte à côté d'un trait bleu ne disait rien du tout. Deux graduations + lignes de grille, et un plafond **arrondi** (`niceAxisCeiling`, exposé et testé plutôt que recopié dans le test) : l'axe lit 0 / 500 / 1 k, plus 0 / 517 / 1,03 k. Étiquettes de mois désambiguïsées par le jour quand deux périodes tombent dans le même mois.
- `RangeStats` côté repository agrège en une passe : périodes, catégories (courantes **et** précédentes), notes.

Au passage : les deux boutons « Charge fixe » / « Revenu récurrent » de l'état vide des récurrences ont été retirés — ils faisaient doublon avec le FAB.

`flutter analyze` : 0 problème. **118 tests au vert.** Vérifié à l'écran sur l'AVD.

### 2026-07-28 — Six fonctionnalités : export, suggestions, récap, multi-devise

- **Recherche élargie.** Elle ne regardait que la note et la catégorie ; « c'était combien déjà » ne marchait pas. `TxnView.matches()` couvre désormais note, catégorie, compte **et montant**, avec les deux marques décimales (`12`, `12,5`, `12.50` trouvent tous 12,50 €). 5 tests.
- **Export CSV d'un mois** (`CsvExportService`) depuis l'écran Historique, via la feuille de partage. Séparateur `;` et BOM UTF-8 pour qu'Excel FR l'ouvre sans mojibake ; montants en décimal brut et **signés** pour qu'une colonne se totalise toute seule. L'import CSV reste retiré — exporter n'est pas la même chose qu'importer.
- **Suggestions depuis l'historique** (`SuggestionEngine`, pur, 12 tests) : une dépense répétée dans 3 mois **distincts** à montant stable (±15 %) devient une proposition d'abonnement ; une catégorie dépensée 3 mois de suite propose une enveloppe à la moyenne + 10 %, arrondie à un chiffre humain. Une carte à la fois sur l'onglet Budgets, avec « Non merci » persistant (clé de réglage, pas de table). Accepter crée directement l'objet — un formulaire pré-rempli aurait été plus de code pour moins d'intérêt.
- **Récap de fin de mois** (`MonthRecapPage`) : l'anneau du tableau de bord réutilisé pour raconter le mois écoulé — épargné ou dépassé, où c'est parti, part de chaque poste. Accessible depuis l'Historique, et une notification le lendemain de la clôture de période.
- **Multi-devise par compte** (schéma **v7**, `accounts.currencyCode`). Modèle retenu : **taux manuel, un seul budget**. Les montants sont **stockés dans la devise principale**, convertis une seule fois à la saisie — stocker en natif obligerait à reconvertir tout l'historique à chaque correction de taux, et un budget dont le passé bouge n'est pas un budget. Écran de taux dans les Réglages qui assume l'absence de réseau. `ExchangeRates` pur, 7 tests.

**Bug attrapé au passage :** `syncChargeReminders` fait `cancelAll()`, ce qui effaçait le **rappel quotidien** dès qu'une charge changeait. Il est reprogrammé après la synchro, comme le récap.

`flutter analyze` : 0 problème. **114 tests au vert.** APK release installé, migration v7 passée sans erreur sur la base existante de l'AVD.

⚠️ **Non vérifié à l'exécution :** les suggestions et le récap demandent 3 mois d'historique, que l'AVD n'a pas. Le moteur est testé, le câblage ne l'est pas.

### 2026-07-28 — Historique jour par jour, et 5 finitions produit

**Le bug de l'historique.** L'écran d'historique paginait jour par jour au lieu de mois par mois. Cause trouvée en le reproduisant : le curseur « jour de début de période » des Réglages committait **à chaque cran du glissement** (`Slider.onChanged`), et chaque écriture ré-invalidait `openPeriodProvider` → `ensureOpenPeriodFor` créait une période budgétaire **par jour survolé par le doigt**. Un seul glissement de 1 à 15 = 15 périodes (vérifié).
- Correctif : `onChangeEnd` valide une seule fois, `onChanged` ne fait plus que repeindre (état local).
- Migration **v6** : purge les périodes qui ne portent *rien* — aucune transaction, enveloppe, échéance, contribution, ni report corrigé à la main, et pas la période ouverte. Une période vide transmet son report tel quel, donc rien de ce que l'utilisateur a saisi ne peut être perdu. Test dédié, vérifié qu'il échoue sans la purge.

**Les 5 finitions demandées :**
1. **Charges déjà échues au 1ᵉʳ lancement.** `startDate` d'une récurrence filtre désormais des *périodes entières*, plus des jours : un loyer déclaré le 28 était payé le 5, l'instance doit exister. Sans ça, s'inscrire en fin de mois ne matérialisait ni salaire ni charges et le tout premier tableau de bord affichait « Dépassé ». 2 tests remplacent l'ancien.
2. **Annuler une suppression.** `TransactionRepository.restore()` remet la ligne avec son id d'origine. L'appui long ouvre maintenant une feuille (Dupliquer / Supprimer) au lieu de supprimer derrière un oui/non ; la suppression est immédiate mais réversible 5 s. L'historique garde sa confirmation (elle recalcule les reports en cascade) *et* gagne l'annulation.
3. **Projection de fin de mois.** « À ce rythme, tu finis le mois à X » sous l'anneau. Calcul dans le moteur pur : seules les dépenses **du quotidien** sont extrapolées — une charge payée le 5 est un one-off, l'inclure rendait toute prévision de début de mois catastrophique. Muet les 3 premiers jours et une fois la période finie. 6 tests.
4. **Comparaison au mois précédent.** « 12 % de moins que le mois dernier », mesuré **à jours écoulés égaux** — comparer 8 jours à un mois complet flatterait toujours. Sous 5 % d'écart on dit « au même rythme ». 3 tests, dont la fenêtre glissante.
5. **Dupliquer une transaction** à la date du jour, dans la période courante. Le ticket n'est pas recopié : il appartient à l'achat d'origine.

**Deux retours d'usage traités dans la foulée :**
- Les `SnackBar` de suppression **s'empilaient** (une par ligne supprimée, chacune attendant son propre minuteur par-dessus la barre du bas). Elles se remplacent désormais (`hideCurrentSnackBar`) et durent 3 s au lieu de 4.
- L'écran **Charges & revenus récurrents** disait « ajoute-les depuis l'onglet Budgets » au lieu de le permettre. Il a maintenant un FAB (feuille à deux choix) et un état vide avec deux boutons directs.

- La carte **« Note ta première dépense »** de l'accueil était décorative : elle est devenue un vrai raccourci vers `/add` (`InkWell` + chevron), et son texte ne renvoie plus vers le bouton du bas.

**Régression l10n corrigée au passage :** `currencyProvider` lisait le *réglage* de langue (null quand il vaut `system`) au lieu de la langue réellement rendue, ce qui laissait dates et séparateurs en français dans une app en anglais. Il lit désormais `resolvedLocaleProvider`.

`flutter analyze` : 0 problème. **90 tests au vert.** APK release installé et relancé sur l'AVD, aucune exception Flutter ; projection visible à l'écran.

⚠️ **Vu sur l'AVD, à confirmer sur un vrai téléphone :** relancer l'app via `adb`/`am start` la fait démarrer directement sur `/add`. C'est probablement l'intent du raccourci de lanceur rejoué par `am start` (`quickActions.initialize` réagit à l'intent de lancement) plutôt qu'un vrai bug — un appui sur l'icône depuis le launcher devrait être sain. À vérifier.

⚠️ **Effet visible du choix « catégories semées une fois » :** sur une base semée en anglais puis basculée en français, les catégories restent en anglais (Groceries, Eating out…) dans une UI française. C'est le comportement décidé (ce sont des données utilisateur dès l'insertion, cf. D11) mais ça surprend. À trancher si ça doit rester.

⚠️ **Reste ouvert :** dans l'onboarding en anglais, les libellés de charges pré-remplis restent en français (`_charges` est un `late final` figé au premier build, avant que le réglage de langue soit chargé). Impact réel : les presets ne retrouveraient pas les catégories semées dans l'autre langue. À corriger en sortant les libellés du `late final`.

### 2026-07-28 — Sécurité des mises à jour Play + anglais complet

**Audit « une mise à jour peut-elle détruire les données ? »** — réponse de fond : non, Android conserve `/data/data` d'une version à l'autre et les migrations v1→v5 sont toutes additives. Quatre trous corrigés quand même :

- **La restauration effaçait les favoris.** `BackupService._restoreTables` vidait les 13 tables et n'en réinsérait que 12 : `favorites` n'a jamais été dans le dump. Ajoutée, plus un `assert` sur `allTables` qui claque au prochain ajout de table oublié.
- **`onUpgrade` enveloppé dans une transaction.** Drift ne le fait pas et n'écrit `user_version` qu'après succès (vérifié dans `engines.dart:559`). Une migration qui meurt à mi-parcours laissait donc le schéma à moitié migré sous l'ancien numéro → au lancement suivant la chaîne rejoue et `addColumn` explose sur « duplicate column name », à chaque démarrage, définitivement. Le test le prouve : sans le wrapper il échoue.
- **Garde anti-rétrogradation** : une base plus récente que le build lève au lieu d'être réétiquetée à la baisse sur un schéma qui ne correspond plus.
- **Sauvegarde Android déclarée** (`allowBackup="true"` + `backup_rules.xml` / `data_extraction_rules.xml`, seul le `-shm` exclu). Décision assumée : l'utilisateur qui change de téléphone garde son budget sans avoir pensé à exporter. **À déclarer dans Data Safety** — la base part bien chez Google, même chiffrée de bout en bout par le code de verrouillage.
- **Filet de migration écrit à la main** (`test/migration_test.dart`, 3 tests) : `drift_dev schema dump` est inutilisable ici, `drift_dev > 2.34.0` exige `analyzer 13` que le SDK Flutter épinglé refuse. Le test fabrique une base v1, la fait migrer par le vrai `AppDatabase`, et vérifie survie des données / rollback / refus de rétrogradation.
- Nettoyage au passage : les `PRAGMA foreign_keys = OFF` dans `wipeAndReseed` et `_restoreTables` étaient des **no-op** (SQLite ignore ce pragma dans une transaction). Retirés ; tout est en `cascade`/`setNull`, l'ordre n'a jamais compté.

**Anglais complet** — l'app avait bien une infra `l10n` mais seulement ~100 clés câblées ; ~270 chaînes restaient en dur. Passe complète sur 33 fichiers, **402 clés, parité fr/en garantie par test** :

- Accès aux traductions **hors widgets** (`translationsProvider` + `resolvedLocaleProvider`) pour les notifications, les widgets d'accueil et le raccourci du lanceur — `main()` ne pouvait pas le faire, il tourne avant que la langue soit connue. L'init du service de notifications est donc passée dans `NotificationSync`.
- **Dates et nombres** : `date_x.dart` codait `'fr_FR'` en dur partout. Remplacé par `Intl.defaultLocale`, posé par `AppCurrency.configure`. Le `'€'` en dur (21 occurrences) devient `AppCurrency.instance.symbol`.
- **Catégories semées** traduites une fois au premier lancement, dans la langue de l'appareil. Piège : les presets de l'onboarding les référencent par nom, donc ils utilisent les **mêmes clés** — sinon ils ne retrouvent plus la catégorie en base.
- **Scanner de tickets** : mots-clés OCR anglais ajoutés (`amount due`, `balance due`, `subtotal`…). Les dates restent jour-d'abord : un `03/14/2026` américain ne donne aucune date plutôt qu'une date fausse.
- Libellés d'enums (`shared/labels.dart`) prennent un `L` au lieu d'un contexte, pour rester utilisables depuis les services.

`flutter analyze` : 0 problème. **79 tests au vert.** APK release construit (96,6 Mo) ; manifeste empaqueté revérifié : `minSdkVersion="26"`, `allowBackup="true"`, les deux fichiers de règles de sauvegarde présents.

⚠️ **Non vérifié à l'exécution** : l'app en anglais n'a pas été lancée (l'utilisateur teste lui-même). Le parcours à revoir en priorité est l'onboarding en `en`, où les presets de charges doivent retrouver les catégories semées en anglais.

### 2026-07-28 — Portée Play : le coupable n'était pas le minSdk
- **Diagnostic d'abord.** Le manifeste réellement empaqueté dans le `.aab` déclarait déjà `minSdkVersion="31"` — le catalogue d'appareils riquiqui venait d'ailleurs.
- **`USE_FINGERPRINT`.** `local_auth` déclare cette permission d'avant l'API 28 dans son propre manifeste. Play la traduit en `<uses-feature android:name="android.hardware.fingerprint" android:required="true">` **implicite** et retire du catalogue tout appareil sans lecteur d'empreinte. Or la biométrie est optionnelle dans Budgie et retombe sur le code de l'appareil. Retirée via `tools:node="remove"` (même mécanique que `SCHEDULE_EXACT_ALARM`), et la fonctionnalité déclarée explicitement `required="false"`.
- **`minSdk` 31 → 26** (D1 révisée une 2ᵉ fois). Rien ne justifiait 31 : `dynamic_color` renvoie `null` sous Android 12 et le thème retombe déjà sur la palette de seed (`app.dart`), tous les plugins annoncent 21+, et le plancher de Flutter est 24 — 26 garde une marge tout en récupérant Android 8 à 11.
- Vérifié dans le manifeste empaqueté : `minSdkVersion="26"`, `USE_FINGERPRINT` absente, `android.hardware.fingerprint` en `required="false"`, aucune autre `uses-feature`.
- `flutter analyze` : 0 problème. 72 tests au vert. APK release installé et lancé sur l'AVD. `.aab` signé, **versionCode 3** (`0.2.1+3`).
- ⚠️ **Non vérifié à l'exécution sous Android 8–11** : l'AVD disponible est en API 36. Le build passe et les plugins l'annoncent, mais un test sur un AVD API 26 reste à faire avant de se fier au chiffre de portée.

### 2026-07-27 — Refonte désirabilité : anneau + parcours d'entrée
Objectif : rendre l'app plus engageante, sur le modèle des applis de budget « grand public » (parcours guidé à pastilles de marque, page d'accueil en anneau). Aucune fonctionnalité retirée.

- **Accueil.** Le héros passe de « gros chiffre + `LinearProgressIndicator` » à un **anneau ouvert avec le chiffre au centre**. Le commentaire de `BudgetSnapshot.committedRatio` promettait déjà « Drives the progress ring » depuis la Phase 1 — c'est maintenant vrai. Widget partagé `BudgetRing`/`RingLegend`, réutilisé par le donut de Stats (≈25 lignes supprimées là-bas).
- **Abonnements.** Étape dédiée, 20 plateformes. Choix assumé : **monogramme + couleur de marque, pas de logos** (assets sous licence, poids du bundle, et illisibles à 52 dp de toute façon).
- **Trois bugs trouvés en rejouant le parcours sur l'émulateur**, tous antérieurs ou révélés par la refonte :
  1. **`showDatePicker` et `showModalBottomSheet` ne s'ouvraient pas du tout.** L'onboarding est rendu depuis `MaterialApp.builder`, au-dessus du `Navigator` du routeur : il n'en avait aucun. Le correctif de juillet avait fourni un `Overlay` nu (assez pour `Slider`/`Tooltip`), mais une feuille et un dialogue **poussent des routes**. `Overlay` → `Navigator` dans `_Gate` ; le `Navigator` amène son `Overlay`, donc le correctif d'origine reste couvert.
  2. **`categoriesProvider` était lu (`ref.read`) sans jamais être écouté.** Le stream n'étant abonné par personne, la liste restait vide : les **enveloppes étaient silencieusement perdues à l'enregistrement** et l'anneau de récap tombait sur une couleur unique. `ref.watch` en tête de `build`.
  3. **Les montants suggérés n'étaient que des `hintText`.** Cocher « Loyer » affichait « 800 » en gris et enregistrait… rien. Cocher promeut désormais le hint en vraie valeur (`_ChargePreset.enable()`).
- **Stats — « Revenus et dépenses » réparé.** Avec un seul mois d'historique, `fl_chart` dessinait une barre fine et solitaire au milieu d'un cadre vide, sans axe, avec une légende « Revenus » sans barre (0 €) : ça se lisait comme un graphe cassé. En dessous de 2 mois on affiche désormais les chiffres du mois (revenus / dépenses / épargné ou déficit) et une ligne qui annonce le graphe pour le mois suivant.
- Détails : ring vide en teinte de la carte plutôt qu'en `surfaceContainerHighest` (sur la carte verte il ressortait en blanc franc) ; `Restaurant` prend sa propre teinte (orange) — deux verts côte à côte dans l'anneau ne se distinguaient pas ; points de progression en `outlineVariant` (en `surfaceContainerHighest` ils étaient invisibles sur le fond, on ne voyait que le point actif).
- **Vérifié sur l'AVD `Budgie_API36`** (Android 16, `fr-FR`), APK release, parcours complet rejoué de l'accueil au tableau de bord : calendrier, feuille d'abonnement, 2 enveloppes bien persistées, échéances Netflix/Spotify créées, anneau multicolore sur l'accueil et sur Stats.
- `flutter analyze` : 0 problème. 72 tests au vert (3 nouveaux sur `BudgetRing` : mois vide, arcs nuls/négatifs, légende).
- **À noter, non corrigé :** en s'inscrivant en fin de mois (test fait le 27), le salaire et les charges dont le jour d'échéance est déjà passé ne se matérialisent pas (`startDate` = aujourd'hui), donc le premier écran affiche « Dépassé ». Comportement d'origine de `RecurrenceService`, pas une régression — mais c'est un mauvais premier contact, à trancher.

### 2026-07-14 — Préparation Google Play
- APK release **installé sur le Pixel 10** à la demande.
- **`minSdk` 36 → 31** (D1 révisée). Assumable en perso, intenable sur Play.
- **Signature** : `signingConfigs.release` lit `android/key.properties` (déjà gitignoré) ; repli sur la clé de debug **avec avertissement Gradle** si le fichier est absent, pour que `flutter run --release` continue de marcher sur un clone neuf. Keystore à créer par l'utilisateur (D7).
- **`SCHEDULE_EXACT_ALARM` retirée** (`tools:node="remove"` — `flutter_local_notifications` la déclare de son côté, l'omettre ne suffisait pas). Permission à usage restreint sur Play, réservée réveils/agendas : elle aurait fait recaler la fiche. Le code n'a jamais programmé qu'en `inexactAllowWhileIdle`, donc aucune perte.
- **Découverte : la promesse hors-ligne était fausse en release.** Le manifeste fusionné contient `INTERNET`, injecté par `transport-backend-cct` (télémétrie Google), tiré par ML Kit / scanner de tickets. La doc affirmait le contraire depuis la Phase 0 — c'était vrai *avant* l'ajout du scanner. Arbitré (D6) : on garde ML Kit, et README/CLAUDE/SPEC disent désormais la vérité (« tes données budgétaires restent sur le téléphone », pas « aucun octet ne sort »).
- Manifeste fusionné revérifié : `minSdkVersion="31"`, `targetSdkVersion="36"`, plus aucune permission d'alarme exacte.

### 2026-07-14 — Phase 4 : rappel de sauvegarde + accessibilité
- **Le doc avait pris du retard sur le code.** Le shimmer des 5 pages restantes était déjà fait et câblé (case cochée après vérification). Le schéma Drift était déjà en v4 (le doc disait v3), et `favorites`, `home_widget_sync`, `l10n` et les tests widget n'y figuraient nulle part. Corrigé.
- **Rappel de sauvegarde** : `SettingKeys.lastBackupAt` existait mais **n'était jamais écrite** — le rappel n'aurait donc jamais pu partir. Elle est maintenant renseignée à chaque export réussi (une feuille de partage fermée ne compte pas). `firstLaunchAt` (migration **v5**, non destructrice) démarre l'horloge quand aucune sauvegarde n'existe, pour ne pas harceler une install neuve dès le jour 1. La restauration d'un vieux fichier `.budgetbak` redémarre l'horloge si le dump n'en contient pas. Règle métier sortie du provider → `isBackupReminderDue` (fonction pure, 8 tests). Les Réglages affichent désormais la date de dernière sauvegarde.
- **Accessibilité** : `BackButton` à la place des flèches custom (elles perdaient le tooltip localisé), tooltips manquants, `semanticsLabel`/`semanticsValue` sur les 4 barres de progression, et surtout les graphiques : le donut a déjà une légende textuelle, mais **le graphe de barres n'exposait rien** — il est maintenant résumé mois par mois à la voix. Barre « Dépenses rapides » rendue proportionnelle au `textScaler`.
- **Contrastes vérifiés, pas supposés** : ratios WCAG calculés sur `healthy`/`caution`/conteneurs, clair et sombre → 4,64:1 à 13,86:1, tout passe AA. `danger` hérite de `error` du schéma M3, sûr par construction. Aucune couleur modifiée.
- `flutter analyze` : 0 problème. `flutter build apk --release` : OK. 69 tests au vert ; 1 test widget préexistant bloqué (voir « Connu, non résolu »).

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
