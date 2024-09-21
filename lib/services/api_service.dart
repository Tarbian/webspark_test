import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future<List<dynamic>> fetchTasks(String apiUrl) async {
    final url = Uri.parse('${apiUrl}flutter/api');
    final response = await http.get(
      url,
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load tasks. Status code: ${response.statusCode}');
    }
  }

  Future<void> sendResults(String apiUrl, List<Map<String, dynamic>> results) async {
    final response = await http.post(
      Uri.parse('${apiUrl}flutter/api'),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json'
      },
      body: json.encode(results),
    );
    // print("____________________________________________");
    // print(response.body);
    // print("____________________________________________");
    if (response.statusCode != 200) {
      throw Exception('Failed to send results. Status code: ${response.body}');
    }
  }
}