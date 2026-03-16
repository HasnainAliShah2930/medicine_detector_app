import 'dart:io';
import 'package:flutter/material.dart';
import '../services/openai_service.dart';

class MedicineViewModel extends ChangeNotifier {
  final OpenAIService _openAIService = OpenAIService();

  String? analysisResult;
  bool isLoading = false;

  Future<void> analyzeMedicineName(String medicineName) async {
    isLoading = true;
    analysisResult = null;
    notifyListeners();

    try {
      analysisResult = await _openAIService.analyzeMedicine(medicineName);
    } catch (e) {
      analysisResult = "Error analyzing medicine: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> analyzeMedicineImage(File imageFile) async {
    isLoading = true;
    analysisResult = null;
    notifyListeners();

    try {
      analysisResult = await _openAIService.analyzeMedicineImage(imageFile);
    } catch (e) {
      analysisResult = "Error analyzing medicine: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
