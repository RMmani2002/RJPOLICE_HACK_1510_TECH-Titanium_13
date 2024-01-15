import 'package:local_auth/local_auth.dart';

class FingerprintManager {
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
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  void executeAlgorithm() {
    // Your algorithm or logic here
    print('Executing my algorithm!');
  }

  void performAuthenticationAndAlgorithm() async {
    bool isAuthenticated = await authenticate();
    if (isAuthenticated) {
      executeAlgorithm();
    } else {
      // Handle failed authentication
      print('Authentication failed!');
    }
  }
}

void main() async {
  FingerprintManager fingerprintManager = FingerprintManager();

  
  // Call the function to perform authentication and execute the algorithm
  fingerprintManager.performAuthenticationAndAlgorithm();
}
