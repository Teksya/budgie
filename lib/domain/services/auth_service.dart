import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

/// Thin wrapper around the biometric / device-credential prompt.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final _auth = LocalAuthentication();

  /// Whether the device can prompt at all (biometrics or a device PIN set up).
  Future<bool> canAuthenticate() async {
    try {
      return await _auth.isDeviceSupported();
    } on Object catch (e) {
      debugPrint('AuthService.canAuthenticate failed: $e');
      return false;
    }
  }

  /// Prompts the user. Falls back to the device PIN/pattern if biometrics
  /// are unavailable. Returns true only on success.
  Future<bool> authenticate() async {
    try {
      // local_auth 3.x exposes the flags directly (no `options`). Keeping
      // biometricOnly false lets the device PIN act as a fallback.
      return await _auth.authenticate(
        localizedReason: 'Déverrouille ton budget',
        persistAcrossBackgrounding: true,
      );
    } on Object catch (e) {
      debugPrint('AuthService.authenticate failed: $e');
      return false;
    }
  }
}
