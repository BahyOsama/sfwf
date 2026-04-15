import 'dart:convert';
import 'package:http/http.dart' as http;

class AIAnalyzer {
  final String? openAiKey;

  AIAnalyzer({this.openAiKey});

  Future<AIReport> analyzePage(String htmlContent, String url) async {
    final report = AIReport();
    if (!htmlContent.contains('<meta name="description"')) {
      report.suggestions.add('Missing meta description tag');
    }
    if (!htmlContent.contains('<h1')) {
      report.suggestions.add('No H1 heading found');
    }
    if (!htmlContent.contains('<img alt=')) {
      report.suggestions.add('Some images missing alt attributes');
    }
    if (htmlContent.length < 500) {
      report.suggestions.add('Page content is too short (<500 chars)');
    }

    if (openAiKey != null && openAiKey!.isNotEmpty) {
      try {
        final aiSuggestion = await _callOpenAI(htmlContent);
        report.aiSuggestions = aiSuggestion;
      } catch (e) {
        report.aiSuggestions = 'AI analysis failed: $e';
      }
    }
    return report;
  }

  Future<String> _callOpenAI(String html) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $openAiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content':
                'You are an SEO expert. Analyze the HTML and provide 3-5 specific recommendations to improve SEO and performance.'
          },
          {'role': 'user', 'content': 'Here is the HTML: $html'}
        ],
        'max_tokens': 300,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      return 'OpenAI API error: ${response.statusCode}';
    }
  }
}

class AIReport {
  List<String> suggestions = [];
  String? aiSuggestions;

  @override
  String toString() {
    return 'Suggestions:\n${suggestions.map((s) => '- $s').join('\n')}\n\nAI:\n$aiSuggestions';
  }
}
