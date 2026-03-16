import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenRouterService {
  static const String apiKey = "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";

  static Future<String> analyzeMedicine(String medicineName) async {
    final url = Uri.parse("https://openrouter.ai/api/v1/chat/completions");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "openai/gpt-3.5-turbo",
        "messages": [
          {
            "role": "user",
            "content":
            "Explain this medicine: $medicineName. What is it used for? Side effects?"
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      return "Error: ${response.body}";
    }
  }
}