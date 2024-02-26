// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<String> signIn(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signin'), // Update with your sign-in endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      // Successfully signed in, return the access token
      return jsonDecode(response.body)['accessToken'];
    } else {
      // Failed to sign in
      throw Exception('Failed to sign in');
    }
  }

  Future<List<Customer>> getCustomers(String accessToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/customers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJzdXNhbiIsImlhdCI6MTcwODEwOTQwNCwiZXhwIjoxNzA4MTk1ODA0fQ.xtrHffOfY2lYigS-bPTmmmLDxR0SFWEesXWo6qg3yPlcKHx-iii0fvR_w4RmkF_Uur4swWBifFgJarsbOKd8dA',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Customer> customers =
          data.map((json) => Customer.fromJson(json)).toList();
      return customers;
    } else {
      throw Exception('Failed to load customers');
    }
  }
}
