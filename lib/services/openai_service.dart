import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class OpenAIService {
  static const String apiKey = "ADD API KEY";

  Future<String> analyzeMedicine(String medicineName) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");
    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "user",
              "content": "Analyze the medicine '$medicineName' and provide: 1. Rating (out of 5), 2. Usage, 3. Manufacturer, 4. Other relevant details. Provide a structured response."
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"];
      } else {
        final errorBody = jsonDecode(response.body);
        final message = errorBody['error']?['message'] ?? "Unknown error";
        return "OpenAI Error (${response.statusCode}): $message";
      }
    } catch (e) {
      return "Connection Error: $e";
    }
  }

  Future<String> analyzeMedicineImage(File imageFile) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-4o", // Latest OpenAI vision model
          "messages": [
            {
              "role": "user",
              "content": [
                {
                  "type": "text",
                  "text": "Analyze this medicine box and provide details: Rating, Usage, Manufacturer, and other relevant info. Provide a structured response."
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
        return data["choices"][0]["message"]["content"];
      } else {
        final errorBody = jsonDecode(response.body);
        final message = errorBody['error']?['message'] ?? "Unknown error";
        return "OpenAI Vision Error (${response.statusCode}): $message";
      }
    } catch (e) {
      return "Connection Error: $e";
    }
  }
}
