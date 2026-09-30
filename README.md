# Budgie

A private, offline personal budgeting app for Android, built with Flutter.

Budgie answers one question at a glance: **how much can I still spend before the
end of the month?** Recurring income and fixed charges are handled
automatically, so day‑to‑day logging stays fast — by receipt scan, one‑tap
favourites, a home‑screen widget, or a quick manual entry.

Everything runs on the device. No account, no server, no third party: your
financial data never leaves your phone.

## Features

- **Left‑to‑spend** — a live figure of what you can spend, per period and per day.
- **Budget periods** — start the month on any day (e.g. your pay day), with
  carry‑over from one month to the next, recomputed in cascade when you edit the
  past.
- **Recurring income & charges** — salary, rent, bills and subscriptions
  materialise automatically each period; variable charges track their real
  amount over time.
- **Envelopes** — a monthly cap per category with 80% / 100% alerts and rollover.
- **Savings goals** and **debts / instalments** tracking.
- **On‑device receipt scanning** (Google ML Kit) that pre‑fills the amount.
- **Fast entry** — big keypad, one‑tap favourites, category guessed from the note.
- **Home‑screen widgets** — left‑to‑spend, next bill, and a quick‑add button.
- **Stats** — spending by category and income‑vs‑expense over time.
- **Encrypted backup / restore**, biometric lock, and daily logging reminders.
- **Multi‑currency**, **French / English**, phone and tablet layouts.

## Tech stack

- Flutter (Material 3 Expressive), Riverpod for state.
- Drift (SQLite) for local storage, with versioned migrations.
- `google_mlkit_text_recognition`, `home_widget`, `flutter_local_notifications`,
  `local_auth`, `fl_chart`.

## Getting started

```bash
flutter pub get
dart run build_runner build   # generates Drift + code
flutter run
```

Requires Flutter 3.44+ and the Android SDK.

## Architecture

Feature‑first, with a clear layer split: `widget → Riverpod provider → service →
repository → Drift DAO`. Amounts are always integer cents via a `Money` type —
never `double`. See `docs/ARCHITECTURE.md` for the data model and formulas, and
`docs/SPEC.md` for the product rules.

## Privacy

Your budget stays on your phone. There is no account, no backend, and no code in
this app that sends your financial data anywhere. The only way your data leaves
the device is a backup file you explicitly export — and it is encrypted with a
password you choose.

One honest caveat: the release build does hold the `INTERNET` permission. It is
pulled in by Google ML Kit, which powers the optional receipt scanner, and its
bundled telemetry component (`transport-backend-cct`) reports usage diagnostics
to Google. Text recognition itself runs entirely on-device. So "offline" is true
of your budget, not of every byte the app is capable of sending.

## License

Released under the MIT License — see [LICENSE](LICENSE).
