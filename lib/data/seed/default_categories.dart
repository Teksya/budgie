import 'package:budget/data/db/enums.dart';
import 'package:budget/l10n/app_localizations.dart';

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

/// The categories every fresh install starts with, named in [l].
///
/// These become ordinary editable rows the moment they are inserted, so they
/// are translated once, at first launch, and never again — switching the app
/// language later does not rename a category the user may have edited.
List<SeedCategory> defaultCategories(L l) => [
  // ── Expenses ──────────────────────────────────────────────────────────
  SeedCategory(l.catHousing, CategoryKind.expense, 'home', _blue),
  SeedCategory(
    l.catFood,
    CategoryKind.expense,
    'cart',
    _green,
    children: [
      SeedCategory(l.catGroceries, CategoryKind.expense, 'cart', _green),
      // Own hue, not the parent's: groceries and restaurant are the two
      // budgets people set side by side, and two greens make one blur arc.
      SeedCategory(l.catRestaurant, CategoryKind.expense, 'restaurant', _orange),
      SeedCategory(l.catBakery, CategoryKind.expense, 'bread', _green),
    ],
  ),
  SeedCategory(
    l.catTransport,
    CategoryKind.expense,
    'car',
    _amber,
    children: [
      SeedCategory(l.catFuel, CategoryKind.expense, 'fuel', _amber),
      SeedCategory(l.catPublicTransport, CategoryKind.expense, 'bus', _amber),
      SeedCategory(l.catVehicleUpkeep, CategoryKind.expense, 'tools', _amber),
    ],
  ),
  SeedCategory(
    l.catBills,
    CategoryKind.expense,
    'receipt',
    _indigo,
    children: [
      SeedCategory(l.catElectricity, CategoryKind.expense, 'bolt', _indigo),
      SeedCategory(l.catWater, CategoryKind.expense, 'water', _indigo),
      SeedCategory(l.catInternet, CategoryKind.expense, 'wifi', _indigo),
      SeedCategory(l.catPhone, CategoryKind.expense, 'phone', _indigo),
      SeedCategory(l.catInsurance, CategoryKind.expense, 'insurance', _indigo),
      SeedCategory(
        l.catSubscriptions,
        CategoryKind.expense,
        'subscription',
        _indigo,
      ),
    ],
  ),
  SeedCategory(l.catHealth, CategoryKind.expense, 'health', _red),
  SeedCategory(l.catLeisure, CategoryKind.expense, 'fun', _purple),
  SeedCategory(l.catShopping, CategoryKind.expense, 'shopping', _pink),
  SeedCategory(l.catSport, CategoryKind.expense, 'sport', _lime),
  SeedCategory(l.catEducation, CategoryKind.expense, 'school', _teal),
  SeedCategory(l.catTravel, CategoryKind.expense, 'plane', _orange),
  SeedCategory(l.catGifts, CategoryKind.expense, 'gift', _pink),
  SeedCategory(l.catPets, CategoryKind.expense, 'pets', _brown),
  SeedCategory(l.catTaxes, CategoryKind.expense, 'tax', _slate),
  SeedCategory(l.catSavings, CategoryKind.expense, 'piggy', _teal),
  SeedCategory(l.catDebts, CategoryKind.expense, 'debt', _slate),
  SeedCategory(
    l.uncategorized,
    CategoryKind.expense,
    'more',
    _slate,
    isSystem: true,
  ),

  // ── Income ───────────────────────────────────────────────────────────
  SeedCategory(l.catSalary, CategoryKind.income, 'salary', _green),
  SeedCategory(l.catBonus, CategoryKind.income, 'bonus', _amber),
  SeedCategory(l.catBenefits, CategoryKind.income, 'allowance', _blue),
  SeedCategory(l.catFreelance, CategoryKind.income, 'freelance', _purple),
  SeedCategory(l.catRefund, CategoryKind.income, 'refund', _teal),
  SeedCategory(l.catOtherIncome, CategoryKind.income, 'trending', _slate),
];
