import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImageAnalysisService {
  // Using OpenRouter key as it provides access to free models when OpenAI quota is empty
  static const String apiKey = "add api key";

  Future<String> analyzeMedicineImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Using OpenRouter endpoint with a FREE vision model
      final response = await http.post(
        Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
          "HTTP-Referer": "http://localhost:3000", // Required for OpenRouter
        },
        body: jsonEncode({
          "model": "google/gemini-pro-1.5-exp:free", // A free vision model
          "messages": [
            {
              "role": "user",
              "content": [
                {
                  "type": "text",
                  "text": "Analyze this medicine box and provide details: Rating (out of 5), Usage, Manufacturing Company, and other relevant info. Provide the response in a structured format."
                },
                {
                  "type": "image_url",
                  "image_url": {
                    "url": "data:image/jpeg;base64,$base64Image"
                  }
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"] ?? "No details found.";
      } else {
        return "Error: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "Error connecting to service: $e";
    }
  }
}
