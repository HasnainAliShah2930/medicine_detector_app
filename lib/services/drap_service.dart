import 'package:cloud_functions/cloud_functions.dart';

class DrapService {
  static Future<bool> verifyRegistration(String regNo) async {
    try {
      final callable =
      FirebaseFunctions.instance.httpsCallable('verifyDRAP');

      final result =
      await callable.call({"registration_number": regNo});

      return result.data["valid"] == true;
    } catch (e) {
      // In case the cloud function is not yet deployed or fails,
      // you might want to return true for testing or handle the error.
      return false;
    }
  }
}
