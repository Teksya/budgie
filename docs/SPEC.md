# SPEC — Application de gestion de budget

> Document de référence fonctionnel. Toute décision produit se pose ici.
> Dernière mise à jour : 2026-07-10

---

## 1. Objectif

Application mobile Android, **sans compte ni backend**, mono-utilisateur, en euros, qui permet à Olivier de :

- saisir ses revenus (salaire, primes, allocations, freelance) quand il veut ;
- déclarer ses charges fixes (loyer, charges, électricité, eau, internet, téléphone…) et les suivre ;
- enregistrer ses dépenses courantes et les catégoriser ;
- savoir **à tout moment combien il peut encore dépenser** (« reste-à-vivre ») ;
- consulter l'historique complet des mois précédents avec statistiques.

Le but n'est pas de comptabiliser : c'est de **décider**. Le chiffre le plus important de l'app est « il te reste X € à dépenser d'ici la fin du mois ».

> **Positionnement (tranché le 2026-07-10) : app grand public, hors-ligne, à saisie manuelle.** Pas de synchro bancaire ni d'import de fichiers dans le parcours utilisateur (jugé trop technique pour le grand public — voir §8). La priorité produit devient la **rapidité et l'agrément de la saisie manuelle**. La sauvegarde/restauration reste (sécurité des données).

---

## 2. Contraintes techniques validées

| Sujet | Décision |
|---|---|
| Plateforme | Android uniquement |
| minSdk | **26 (Android 8+)** — abaissé le 2026-07-28 pour la portée Play, *voir D1* |
| targetSdk | 36 |
| Utilisateurs | 1 seul, aucun compte, aucun backend |
| Données budgétaires | Locales (SQLite via Drift). Aucun code de l'app ne les envoie où que ce soit. Seule sortie possible : le fichier de sauvegarde chiffré que l'utilisateur exporte lui-même |
| Réseau | Le build release **porte la permission `INTERNET`** (télémétrie de ML Kit, scanner de tickets) — *voir D6* |
| Devise | EUR unique |
| Design | Material 3 Expressive, couleur dynamique (Material You) |
| Thèmes | Clair / Sombre / Système |
| Sécurité | Déverrouillage biométrique à l'ouverture |

---

## 3. Modèle mental

### 3.1 La période budgétaire

L'app raisonne par **période** (un « mois budgétaire »). Sa date de début est **configurable** : le 1er du mois par défaut, mais on peut la caler sur le jour de paie (ex. le 25). Chaque période a un début, une fin, un état (`ouverte` / `clôturée`) et un **report**.

### 3.2 Le report (carry-over)

Ce qui reste à la fin d'une période est **reporté** sur la suivante, en positif comme en négatif. Le report est **modifiable manuellement** : si un montant a été mal saisi, on corrige la période concernée et les reports en aval se recalculent en cascade.

### 3.3 Le reste-à-vivre

Le chiffre-roi affiché sur le dashboard.

```
Revenus de la période (réels + prévus non encore perçus)
+ Report de la période précédente
− Charges fixes restant à payer (montant réel si connu, sinon estimé)
− Épargne planifiée de la période
− Dépenses déjà effectuées
= RESTE À VIVRE
```

Décliné en trois lectures :
- **Reste total** sur la période
- **Reste par jour** = reste total ÷ jours restants dans la période
- **Reste par semaine** = reste par jour × 7

Un état visuel clair : vert (confortable), ambre (serré), rouge (dépassement).

---

## 4. Fonctionnalités

### 4.1 Revenus

- Sources multiples : `salaire`, `prime`, `allocation`, `freelance`, `autre`.
- Le salaire est **récurrent** : montant par défaut pré-rempli chaque période, **modifiable au cas par cas** sans casser la récurrence.
- Les revenus ponctuels se saisissent librement, à n'importe quelle date.
- Un revenu peut être marqué `prévu` (attendu) ou `perçu` (encaissé). Les deux comptent dans le reste-à-vivre, mais seul le `perçu` bouge le solde du compte.

### 4.2 Charges fixes & abonnements

Un seul moteur : une **récurrence** (le modèle) qui génère des **échéances** (les occurrences réelles).

**Récurrence** — nom, catégorie, compte, montant estimé, périodicité (mensuelle, bimestrielle, trimestrielle, semestrielle, annuelle), jour d'échéance, date de début, date de fin optionnelle, actif/inactif, type (`charge fixe` ou `abonnement`).

**Montant fixe vs variable** : une récurrence peut être `fixe` (loyer : 750 €, toujours) ou `variable` (électricité : estimée 80 €, réel corrigé à réception de la facture). Le reste-à-vivre utilise le réel dès qu'il existe, sinon l'estimé.

**Échéance** — générée automatiquement pour chaque période, avec :
- date d'échéance,
- montant estimé, montant réel (nullable),
- statut : `à payer` / `payée` / `en retard`,
- date de paiement.

Elles peuvent aussi être **créées à la main** (une charge exceptionnelle sans récurrence).

**Historique par charge** : courbe d'évolution du montant réel mois par mois (indispensable pour l'électricité et l'eau), avec moyenne et écart à l'estimé — l'app propose de réajuster l'estimé quand il dérive.

**Rappels** : notification locale J-3 et le jour J pour chaque échéance non payée.

**Abonnements au premier lancement** (tranché le 2026-07-27) : le parcours d'entrée propose une grille de ~24 plateformes courantes (Netflix, Spotify, Disney+, Canal+, ChatGPT, Claude, Xbox Game Pass…). Un tap demande la **date de prélèvement** (calendrier) puis le **montant** (pré-rempli au tarif courant). Le tarif pré-rempli est une commodité, jamais une affirmation — il est éditable et vieillira.

**Logos** — deux sources, jamais le réseau :
1. `simple_icons` (jeu *Simple Icons*, CC0) en **police d'icônes tree-shakée** : 1,4 Mo réduits à ~5 Ko dans l'APK. Couvre 17 marques sur 24.
2. Les 7 restantes (Disney+, Prime Video, Canal+, ChatGPT, Microsoft 365, Xbox, Nintendo) ont **fait retirer leur marque de Simple Icons** ; elles sont livrées en **PNG 144 px dans `assets/brands/`** (~61 Ko au total). Un monogramme coloré reste le repli de dernier recours si un asset manque.

**Aucune API de logos au runtime** (Brandfetch, Logo.dev, Clearbit…) : chaque tuile deviendrait un appel réseau signalant à un tiers les marques auxquelles l'utilisateur est abonné. Incompatible avec le §1 et avec D6, où la seule sortie réseau tolérée est de la télémétrie ML Kit déjà subie, pas une fuite fonctionnelle. Les logos sont donc téléchargés **une fois, à l'écriture du code**, et commités.

### 4.3 Dépenses courantes

- Saisie **manuelle** (aucune connexion bancaire) et **import CSV** hors ligne.
- Champs : montant, date, catégorie, compte, note, pièce jointe (photo de ticket, optionnelle).
- **Dépenses partagées** : champ « part à ma charge » (montant total 60 €, ma part 30 €) — seul le montant à ma charge impacte le budget.
- Saisie rapide : écran d'ajout accessible en 1 geste depuis le dashboard, montant d'abord, catégorie ensuite.

### 4.4 Catégories

- Set par défaut fourni à l'installation (voir §7).
- **Entièrement modifiables** : créer, renommer, supprimer, changer icône et couleur.
- **Sous-catégories** sur un niveau (Courses → Supermarché / Boulangerie).
- Une catégorie est de type `dépense` ou `revenu`.
- Suppression : les transactions sont réaffectées à « Non catégorisé », jamais perdues.

### 4.5 Budgets (enveloppes)

- Une enveloppe = un plafond mensuel par catégorie (ex. Courses : 300 €).
- Barre de progression, alerte à **80 %** et à **100 %** (notification + badge rouge).
- Option **rollover** par enveloppe : le non-dépensé bascule sur le mois suivant.
- Les enveloppes se dupliquent automatiquement d'une période à l'autre.

### 4.6 Objectifs d'épargne

- Un objectif = nom, montant cible, date cible optionnelle, compte d'épargne associé.
- L'app calcule la mensualité nécessaire pour tenir la date, et la déduit du reste-à-vivre en tant qu'« épargne planifiée ».
- Contributions manuelles ou automatiques à l'ouverture de la période.

### 4.7 Comptes

- Plusieurs comptes : `courant`, `épargne`, `espèces`. Un compte « Principal » est créé par défaut.
- Solde calculé = solde initial + somme des mouvements.
- **Virements** entre comptes (n'impactent ni les revenus ni les dépenses).
- L'UI reste simple : si un seul compte existe, la notion de compte est invisible.

### 4.8 Dettes, crédits et paiements en plusieurs fois

- Types : `crédit` (mensualité fixe, taux, durée), `dette` (je dois à quelqu'un / on me doit), `paiement en N fois` (3x, 4x…).
- Suivi : capital restant dû, échéances payées / restantes, date de fin prévue.
- Les mensualités sont des récurrences et sont donc déduites du reste-à-vivre.

### 4.9 Historique & statistiques

- **Historique** : navigation mois par mois, avec pour chaque période le détail complet (revenus, charges, dépenses, report entrant et sortant, solde final).
- **Modification rétroactive** possible : corriger un mois passé recalcule tous les reports suivants.
- **Graphiques** :
  - répartition des dépenses par catégorie (donut),
  - évolution revenus vs dépenses sur 12 mois (barres),
  - courbe d'une charge variable dans le temps (électricité, eau),
  - comparaison mois N vs N-1 par catégorie,
  - taux d'épargne.
- Pas d'export PDF/CSV en sortie (non demandé).

### 4.10 Sauvegarde / restauration

- Export manuel d'un fichier de sauvegarde chiffré (`.budgetbak`) vers le stockage du téléphone.
- Restauration depuis ce fichier, avec écran de confirmation (écrasement des données).
- Rappel de sauvegarde si aucune depuis 30 jours.

### 4.11 Sécurité

- Verrouillage biométrique (empreinte / visage) à l'ouverture et au retour au premier plan.
- Repli sur le code de l'appareil.
- Option désactivable dans les réglages.

### 4.12 Notifications

| Événement | Moment |
|---|---|
| Échéance à payer | J-3 et jour J |
| Enveloppe à 80 % | à l'atteinte |
| Enveloppe dépassée | à l'atteinte |
| Nouvelle période ouverte | jour de début de période |
| Sauvegarde à faire | 30 jours après la dernière |

---

## 5. Écrans

```
┌ Accueil (Dashboard)
│   Anneau de répartition — arcs par catégorie dépensée, « À payer », « Libre »
│     avec le reste-à-vivre et le reste/jour au centre, légende dessous
│   Jours restants
│   Prochaines échéances (3)
│   Enveloppes les plus tendues (3)
│   Dernières transactions (5)
│   FAB → Ajout rapide
│
├ Transactions
│   Liste groupée par jour, recherche, filtres (catégorie, compte, période)
│   Détail / édition
│
├ Budgets
│   Enveloppes du mois + barres
│   Charges fixes & échéances (à payer / payées)
│   Objectifs d'épargne
│   Dettes & crédits
│
├ Stats
│   Sélecteur de période, graphiques, comparaisons
│
└ Réglages
    Comptes · Catégories · Récurrences · Période budgétaire
    Thème · Biométrie · Notifications · Sauvegarde
```

Navigation : `NavigationBar` M3 à 4 onglets + Réglages accessible depuis l'appbar de l'accueil.

---

## 6. Direction artistique — Material 3 Expressive

**État réel du SDK (vérifié sur Flutter 3.44.2 stable)**

| Élément Expressive | Disponible ? |
|---|---|
| `DynamicSchemeVariant.expressive` | ✅ |
| Couleur dynamique (Material You) | ✅ via `dynamic_color` |
| Tokens de motion `Durations` / `Easing` | ✅ |
| `CarouselView` | ✅ |
| `ButtonGroup`, `SplitButton`, `FabMenu`, `LoadingIndicator` | ❌ pas dans stable → **reconstruits à la main** |
| Shape morphing (formes qui se déforment au press) | ❌ → implémenté maison |

**Parti pris visuel**
- Couleurs : `ColorScheme.fromSeed(dynamicSchemeVariant: expressive)`, seed = couleur du fond d'écran, repli sur un violet profond.
- Formes : rayons généreux et **différenciés** (petits éléments 12dp, cartes 20dp, conteneurs héros 28dp+). Morphing cercle → trèfle sur le FAB au press.
- Typo : hiérarchie très contrastée. Le reste-à-vivre en `displayLarge`, le reste en `bodyMedium`. Chiffres en variante tabulaire.
- Motion : ressorts (`spring`) plutôt que courbes linéaires ; les montants s'animent quand ils changent.
- Couleur porteuse de sens : chaque catégorie a sa couleur, harmonisée au schéma dynamique.

---

## 7. Catégories par défaut

**Dépenses** — Logement · Alimentation (Courses, Restaurant, Boulangerie) · Transport (Carburant, Transports en commun, Entretien) · Factures & abonnements · Santé · Loisirs · Shopping · Éducation · Voyages · Cadeaux · Épargne · Impôts · Divers

**Revenus** — Salaire · Prime · Allocations · Freelance · Remboursement · Autre

---

## 8. Hors périmètre (assumé)

- **Connexion bancaire automatique (Open Banking / DSP2)** — étudié le 2026-07-10, écarté. L'API DSP2 du Crédit Agricole existe (`developer.credit-agricole.fr`) mais l'accès direct exige un agrément AISP (ACPR) + certificats eIDAS, inaccessibles à un particulier. Les agrégateurs (Powens, Tink, Enable Banking…) contournent l'agrément mais imposent **backend serveur + données via un tiers + connexion permanente + coûts** → incompatible avec le principe « 100 % hors ligne ». **Voie retenue : import de fichiers exportés depuis l'espace client CA (CSV déjà supporté ; OFX recommandé en complément).**
- Multi-devises
- Synchronisation multi-appareils / cloud
- Export PDF ou CSV
- iOS, Web, Desktop
- Multi-utilisateurs

---

## 9. Décisions ouvertes

| # | Sujet | Statut |
|---|---|---|
| D1 | ~~`minSdk 36`~~ → ~~`31`~~ → **`26` (révisé le 2026-07-28)**. 36 rendait la fiche installable par une fraction négligeable du parc ; 31 restait inutilement haut, rien dans l'app ne l'exigeait. | 🟢 tranché |
| D9 | **`USE_FINGERPRINT` retirée du manifeste fusionné** (2026-07-28). Injectée par `local_auth`, morte depuis l'API 28, mais Play la traduit en `android.hardware.fingerprint` **requis** et écarte tout appareil sans lecteur d'empreinte. La biométrie est optionnelle dans Budgie et retombe sur le code de l'appareil : la fonctionnalité est déclarée `required="false"`. | 🟢 tranché |
| D6 | **La permission `INTERNET` est présente dans le build release.** Injectée par `transport-backend-cct` (télémétrie Google), dépendance de ML Kit / scanner de tickets. Les données budgétaires, elles, ne sortent jamais. Arbitrage du 2026-07-14 : **on garde ML Kit et on assume**, en formulant la promesse honnêtement (README, CLAUDE) et en le déclarant dans le *Data Safety* de Play. | 🟢 tranché |
| D2 | Début de période : **1er du mois**, modifiable dans les réglages. | 🟢 tranché |
| D3 | Photo de ticket : stockage local des images (fait grossir la sauvegarde). Phase 3. | 🟢 tranché |
| D4 | Montant du salaire à pré-remplir dans la récurrence. | 🟡 en attente |
