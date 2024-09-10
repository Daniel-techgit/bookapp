import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendOTP(String email) async {

  final response = await http.post(
    Uri.parse('https://bookappbackend-csjm.onrender.com/api/forgetPassword'), // Note the single forward slash
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{
      'email': email,
    }),
  );

  if (response.statusCode == 200) {
    // OTP sent successfully
    print('OTP sent to $email');
  } else {
    // Handle error
    print('Failed to send OTP: ${response.body}');
  }
}