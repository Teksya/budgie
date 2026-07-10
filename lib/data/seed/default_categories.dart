import 'package:budget/data/db/enums.dart';

/// A category inserted on first launch. [children] become sub-categories.
class SeedCategory {
  const SeedCategory(
    this.name,
    this.kind,
    this.iconKey,
    this.color, {
    this.children = const [],
    this.isSystem = false,
  });

  final String name;
  final CategoryKind kind;
  final String iconKey;
  final int color;
  final List<SeedCategory> children;
  final bool isSystem;
}

/// Hand-picked hues, spread around the wheel so adjacent slices of the pie
/// chart never look alike.
const _blue = 0xFF3D7EFF;
const _green = 0xFF2E9E62;
const _amber = 0xFFE8A33D;
const _red = 0xFFE05252;
const _purple = 0xFF8B5CF6;
const _teal = 0xFF14A8A0;
const _pink = 0xFFE0559C;
const _indigo = 0xFF5B5BD6;
const _brown = 0xFF9C6B3E;
const _slate = 0xFF6B7280;
const _lime = 0xFF7CB342;
const _orange = 0xFFF2762E;

const List<SeedCategory> kDefaultCategories = [
  // ── Expenses ──────────────────────────────────────────────────────────
  SeedCategory('Logement', CategoryKind.expense, 'home', _blue),
  SeedCategory(
    'Alimentation',
    CategoryKind.expense,
    'cart',
    _green,
    children: [
      SeedCategory('Courses', CategoryKind.expense, 'cart', _green),
      SeedCategory('Restaurant', CategoryKind.expense, 'restaurant', _green),
      SeedCategory('Boulangerie', CategoryKind.expense, 'bread', _green),
    ],
  ),
  SeedCategory(
    'Transport',
    CategoryKind.expense,
    'car',
    _amber,
    children: [
      SeedCategory('Carburant', CategoryKind.expense, 'fuel', _amber),
      SeedCategory('Transports en commun', CategoryKind.expense, 'bus', _amber),
      SeedCategory('Entretien', CategoryKind.expense, 'tools', _amber),
    ],
  ),
  SeedCategory(
    'Factures & abonnements',
    CategoryKind.expense,
    'receipt',
    _indigo,
    children: [
      SeedCategory('Électricité', CategoryKind.expense, 'bolt', _indigo),
      SeedCategory('Eau', CategoryKind.expense, 'water', _indigo),
      SeedCategory('Internet', CategoryKind.expense, 'wifi', _indigo),
      SeedCategory('Téléphone', CategoryKind.expense, 'phone', _indigo),
      SeedCategory('Assurances', CategoryKind.expense, 'insurance', _indigo),
      SeedCategory('Abonnements', CategoryKind.expense, 'subscription', _indigo),
    ],
  ),
  SeedCategory('Santé', CategoryKind.expense, 'health', _red),
  SeedCategory('Loisirs', CategoryKind.expense, 'fun', _purple),
  SeedCategory('Shopping', CategoryKind.expense, 'shopping', _pink),
  SeedCategory('Sport', CategoryKind.expense, 'sport', _lime),
  SeedCategory('Éducation', CategoryKind.expense, 'school', _teal),
  SeedCategory('Voyages', CategoryKind.expense, 'plane', _orange),
  SeedCategory('Cadeaux', CategoryKind.expense, 'gift', _pink),
  SeedCategory('Animaux', CategoryKind.expense, 'pets', _brown),
  SeedCategory('Impôts', CategoryKind.expense, 'tax', _slate),
  SeedCategory('Épargne', CategoryKind.expense, 'piggy', _teal),
  SeedCategory('Crédits & dettes', CategoryKind.expense, 'debt', _slate),
  SeedCategory(
    'Non catégorisé',
    CategoryKind.expense,
    'more',
    _slate,
    isSystem: true,
  ),

  // ── Income ───────────────────────────────────────────────────────────
  SeedCategory('Salaire', CategoryKind.income, 'salary', _green),
  SeedCategory('Prime', CategoryKind.income, 'bonus', _amber),
  SeedCategory('Allocations', CategoryKind.income, 'allowance', _blue),
  SeedCategory('Freelance', CategoryKind.income, 'freelance', _purple),
  SeedCategory('Remboursement', CategoryKind.income, 'refund', _teal),
  SeedCategory('Autre revenu', CategoryKind.income, 'trending', _slate),
];
