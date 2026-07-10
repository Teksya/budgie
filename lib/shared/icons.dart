import 'package:flutter/material.dart';

/// Icons are persisted by **key**, never by `IconData.codePoint`.
///
/// Building an `IconData` from a runtime integer defeats Flutter's icon
/// tree-shaking: the release build either strips the glyph (blank squares) or
/// the build fails outright. A const lookup table keeps every referenced icon
/// statically visible to the compiler.
const Map<String, IconData> kIcons = {
  // Accounts
  'wallet': Icons.account_balance_wallet_outlined,
  'bank': Icons.account_balance_outlined,
  'cash': Icons.payments_outlined,
  'piggy': Icons.savings_outlined,
  'card': Icons.credit_card_outlined,

  // Expense categories
  'home': Icons.home_outlined,
  'cart': Icons.shopping_cart_outlined,
  'restaurant': Icons.restaurant_outlined,
  'bread': Icons.bakery_dining_outlined,
  'car': Icons.directions_car_outlined,
  'fuel': Icons.local_gas_station_outlined,
  'bus': Icons.directions_bus_outlined,
  'tools': Icons.build_outlined,
  'bolt': Icons.bolt_outlined,
  'water': Icons.water_drop_outlined,
  'wifi': Icons.wifi_outlined,
  'phone': Icons.smartphone_outlined,
  'receipt': Icons.receipt_long_outlined,
  'health': Icons.favorite_outline,
  'fun': Icons.sports_esports_outlined,
  'shopping': Icons.shopping_bag_outlined,
  'school': Icons.school_outlined,
  'plane': Icons.flight_outlined,
  'gift': Icons.card_giftcard_outlined,
  'tax': Icons.gavel_outlined,
  'pets': Icons.pets_outlined,
  'sport': Icons.fitness_center_outlined,
  'subscription': Icons.subscriptions_outlined,
  'insurance': Icons.shield_outlined,
  'tag': Icons.sell_outlined,

  // Income categories
  'salary': Icons.work_outline,
  'bonus': Icons.emoji_events_outlined,
  'allowance': Icons.volunteer_activism_outlined,
  'freelance': Icons.laptop_mac_outlined,
  'refund': Icons.undo_outlined,
  'trending': Icons.trending_up_outlined,

  // Misc
  'target': Icons.flag_outlined,
  'debt': Icons.handshake_outlined,
  'more': Icons.more_horiz_outlined,
};

IconData iconFor(String? key) => kIcons[key] ?? Icons.sell_outlined;
