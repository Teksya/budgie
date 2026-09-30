import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';

/// A subscription the welcome flow offers in one tap.
///
/// Most logos come from `simple_icons` (the Simple Icons set, CC0), shipped as
/// a tree-shaken icon font: 1.4 MB of glyphs collapse to ~5 KB in the APK.
///
/// Several big brands (Disney, Amazon, Microsoft, Xbox, Nintendo, Canal+,
/// OpenAI) had their marks **removed from that set at the trademark holder's
/// request**, so they carry an [asset] instead — a 144 px PNG bundled with the
/// app. Bundled, never fetched: a logo CDN would turn every tile into a
/// network call telling a third party which brands the user subscribes to,
/// which is exactly what this app promises not to do.
@immutable
class SubscriptionPreset {
  const SubscriptionPreset(
    this.name,
    this.short,
    this.color,
    this.euros, {
    this.icon,
    this.asset,
  });

  final String name;

  /// One or two letters. Last resort, when there is neither icon nor asset.
  final String short;

  /// The brand's own colour, used as the tile background behind [icon].
  /// Taken from `SimpleIconColors` when the brand is in the set, so colour and
  /// glyph can never drift apart. Ignored when [asset] is set — those PNGs are
  /// full app icons and bring their own background.
  final Color color;

  /// Typical monthly price in euros — a starting point, always editable, and
  /// certain to go stale.
  final double euros;

  /// Monochrome brand glyph from the icon font.
  final IconData? icon;

  /// Full-colour brand icon under `assets/brands/`.
  final String? asset;
}

/// Ordered roughly by how common they are in France.
const List<SubscriptionPreset> kSubscriptionPresets = [
  SubscriptionPreset('Netflix', 'N', SimpleIconColors.netflix, 13.49,
      icon: SimpleIcons.netflix),
  SubscriptionPreset('Spotify', 'S', SimpleIconColors.spotify, 11.99,
      icon: SimpleIcons.spotify),
  SubscriptionPreset('Disney+', 'D+', Color(0xFF113CCF), 11.99,
      asset: 'assets/brands/disneyplus.png'),
  SubscriptionPreset('Amazon Prime', 'aP', Color(0xFF00A8E1), 6.99,
      asset: 'assets/brands/primevideo.png'),
  SubscriptionPreset('YouTube Premium', 'YT', SimpleIconColors.youtube, 12.99,
      icon: SimpleIcons.youtube),
  SubscriptionPreset('Canal+', 'C+', Color(0xFF1A1A1A), 19.99,
      asset: 'assets/brands/canalplus.png'),
  SubscriptionPreset('Apple TV+', 'tv', SimpleIconColors.appletv, 9.99,
      icon: SimpleIcons.appletv),
  SubscriptionPreset('Apple Music', 'AM', SimpleIconColors.applemusic, 10.99,
      icon: SimpleIcons.applemusic),
  SubscriptionPreset('Deezer', 'Dz', SimpleIconColors.deezer, 11.99,
      icon: SimpleIcons.deezer),
  SubscriptionPreset('Crunchyroll', 'Cr', SimpleIconColors.crunchyroll, 6.50,
      icon: SimpleIcons.crunchyroll),
  SubscriptionPreset('Twitch', 'Tw', SimpleIconColors.twitch, 4.99,
      icon: SimpleIcons.twitch),
  SubscriptionPreset('ChatGPT', 'AI', Color(0xFF10A37F), 23,
      asset: 'assets/brands/chatgpt.png'),
  SubscriptionPreset('Claude', 'Cl', SimpleIconColors.claude, 22,
      icon: SimpleIcons.claude),
  SubscriptionPreset('iCloud+', 'iC', SimpleIconColors.icloud, 2.99,
      icon: SimpleIcons.icloud),
  SubscriptionPreset('Google One', 'G1', SimpleIconColors.google, 1.99,
      icon: SimpleIcons.google),
  SubscriptionPreset('Microsoft 365', 'M', Color(0xFFD83B01), 10,
      asset: 'assets/brands/microsoft365.png'),
  SubscriptionPreset('Xbox Game Pass', 'Xb', Color(0xFF107C10), 12.99,
      asset: 'assets/brands/xbox.png'),
  SubscriptionPreset('PlayStation Plus', 'PS', SimpleIconColors.playstation,
      8.99, icon: SimpleIcons.playstation),
  SubscriptionPreset('Nintendo Online', 'Nt', Color(0xFFE60012), 3.99,
      asset: 'assets/brands/nintendo.png'),
  SubscriptionPreset('Paramount+', 'P+', SimpleIconColors.paramountplus, 5.99,
      icon: SimpleIcons.paramountplus),
  SubscriptionPreset('Audible', 'Ad', SimpleIconColors.audible, 9.95,
      icon: SimpleIcons.audible),
  SubscriptionPreset('Dropbox', 'Db', SimpleIconColors.dropbox, 11.99,
      icon: SimpleIcons.dropbox),
  SubscriptionPreset('Strava', 'Sv', SimpleIconColors.strava, 8.99,
      icon: SimpleIcons.strava),
  SubscriptionPreset('Salle de sport', 'Gy', Color(0xFF6B7280), 29.99,
      icon: Icons.fitness_center),
];
