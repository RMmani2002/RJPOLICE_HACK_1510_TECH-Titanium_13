import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FingerprintManager {
  final databaseReference = FirebaseDatabase.instance.reference().child('user');
  final userId = FirebaseAuth.instance.currentUser!.uid;
  LocalAuthentication authentication = LocalAuthentication();

  Future<bool> authenticate() async {
    final bool isBiometricAvailable =
    await authentication.isDeviceSupported();
    if (!isBiometricAvailable) return false;
    try {
      return await authentication.authenticate(
        localizedReason: "Authenticate to view your secret",
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      print("Authentication Error: $e");
      return false;
    }
  }

  void pushFingerprintStatus(bool isFingerprintAuthenticated) {
    String status = isFingerprintAuthenticated ? 'true' : 'false';
    databaseReference.child(userId).child('fingerprint').child('status').set(status);
  }

  void performAuthenticationAndPushStatus() async {
    bool isAuthenticated = await authenticate();
    pushFingerprintStatus(isAuthenticated);

    if (isAuthenticated) {
      print('Fingerprint authentication successful!');
    } else {
      print('Fingerprint authentication failed!');
    }
  }
}

void main() async {
  FingerprintManager fingerprintManager = FingerprintManager();

  // Call the function to perform authentication and push status to the database
  fingerprintManager.performAuthenticationAndPushStatus();
}
