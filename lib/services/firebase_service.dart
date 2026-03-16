import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medicine_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Medicine?> getMedicine(String barcode) async {
    final doc =
    await _firestore.collection('medicines').doc(barcode).get();

    if (doc.exists) {
      return Medicine.fromMap(doc.data()!);
    }
    return null;
  }
}