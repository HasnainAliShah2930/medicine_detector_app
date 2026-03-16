import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class OpenRouterService {
  static const String apiKey = "ADD API KEY";

  Future<String> analyzeMedicine(String medicineName) async {
    final url = Uri.parse("https://openrouter.ai/api/v1/chat/completions");

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
          "HTTP-Referer": "http://localhost:3000",
          "X-Title": "Medicine Analyzer",
        },
        body: jsonEncode({
          "model": "openai/gpt-3.5-turbo",
          "messages": [
            {
              "role": "user",
              "content":
                  "Analyze the medicine '$medicineName' and provide the following details:\n"
                  "1. Rate the medicine (out of 5).\n"
                  "2. Explain what the medicine is used for.\n"
                  "3. Identify the manufacturing company.\n"
                  "4. Provide all other relevant details like dosage, precautions, etc.\n"
                  "Please provide the response in a clear, structured format."
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"];
      } else {
        return "Error from OpenRouter: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "Error connecting to service: $e";
    }
  }

  Future<String> analyzeMedicineImage(File imageFile) async {
    final url = Uri.parse("https://openrouter.ai/api/v1/chat/completions");

    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
          "HTTP-Referer": "http://localhost:3000",
          "X-Title": "Medicine Analyzer",
        },
        body: jsonEncode({
          "model": "google/gemini-flash-1.5",
          "messages": [
            {
              "role": "user",
              "content": [
                {
                  "type": "text",
                  "text": "Extract medicine data from this image and then search for its details: "
                          "Rate (out of 5), Usage, Manufacturing Company, and other relevant info. "
                          "Provide the response in a structured format."
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
        return "Error from OpenRouter: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "Error connecting to service: $e";
    }
  }
}
