import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/data/repositories/settings_repository.dart';
import 'package:budget/domain/services/auth_service.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Gates the whole app behind a biometric prompt when the lock is enabled.
/// Re-locks whenever the app is backgrounded.
class AppLock extends ConsumerStatefulWidget {
  const AppLock({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AppLock> createState() => _AppLockState();
}

class _AppLockState extends ConsumerState<AppLock>
    with WidgetsBindingObserver {
  bool _unlocked = false;
  bool _prompting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Lock again once the app leaves the foreground.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _unlocked = false;
    }
  }

  bool get _enabled =>
      ref.watch(settingsProvider).value?.biometricEnabled ?? false;

  Future<void> _promptUnlock(String reason) async {
    if (_prompting) return;
    _prompting = true;
    final ok = await AuthService.instance.authenticate(reason);
    _prompting = false;
    if (ok && mounted) setState(() => _unlocked = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_enabled || _unlocked) return widget.child;

    final l = L.of(context);
    // Kick off the prompt automatically the first time we show the lock.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _promptUnlock(l.unlockReason),
    );

    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: ShapeDecoration(
                shape: AppShapes.hero,
                color: scheme.primaryContainer,
              ),
              child: Icon(
                Icons.lock_outline,
                size: 48,
                color: scheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l.lockedTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            FilledButton.icon(
              onPressed: () => _promptUnlock(l.unlockReason),
              icon: const Icon(Icons.fingerprint),
              label: Text(l.unlock),
            ),
          ],
        ),
      ),
    );
  }
}
