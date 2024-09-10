import 'package:price_app/features/utils/exports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {

  Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    final url = Uri.parse(ApiRoutes.registerEndpoint);
    try{
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
        }),
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'status': 'success',
          'message': 'Registration successful',
          'data': responseData,
        };
      } else {
        return {
          'status': 'error',
          'message': responseData['error'] ?? 'Registration failed',
          'statusCode': response.statusCode,
        };
      }
    }catch(e){
      return {
        'status': 'error',
        'message': 'Network error occurred',
        'statusCode': 500,
      };
    }

}

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(ApiRoutes.loginEndpoint);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        'status': 'success',
        'message': responseData['message'] ?? 'Login successful',
        'data': responseData,
      };
    } else if(response.statusCode == 401){
      return {
        'status': 'error',
        'message': responseData['error'] ?? 'Invalid email or password',
      };
    } else {
      return {
        'status': 'error',
        'message': responseData['error'] ?? 'An unexpected error occurred',
      };
    }
  }
}
