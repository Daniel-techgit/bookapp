// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// final _secureStorage = const FlutterSecureStorage();
//
// Future<void> addBookToLibrary(String bookId) async {
//   print("Start of addBookToLibrary function");
//   final token = await _secureStorage.read(key: 'token');
//   print("Token retrieval attempt completed");
//
//   if (token != null) {
//     print("Token found: ${token.substring(0, 10)}...");
//     try {
//       final response = await http.post(
//         Uri.parse('https://book-app-backend-theta.vercel.app/api/add-to-library'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'bookId': bookId,
//         }),
//       );
//
//       print('Response status code: ${response.statusCode}');
//       print('Response body: ${response.body}');
//
//       final responseData = jsonDecode(response.body);
//
//       if (response.statusCode == 200) {
//         print(responseData['message']); // This should print "Book added to library"
//       } else if (response.statusCode == 400) {
//         print(responseData['error']); // This should print "Book already in library" if that's the case
//       } else {
//         print('Failed to add book to library: ${responseData['error']}');
//       }
//     } catch (e) {
//       print('Error occurred while adding book to library: $e');
//     }
//   } else {
//     print('Token not found');
//   }
//   print("End of addBookToLibrary function");
// }
//
//
// Future<void> addBookToCart(String bookId) async {
//   print("Start of addBookToCart function");
//   final token = await _secureStorage.read(key: 'token');
//   print("Token retrieval attempt completed");
//
//   if (token != null) {
//     print("Token found: ${token.substring(0, 10)}...");
//     try {
//       final response = await http.post(
//         Uri.parse('https://book-app-backend-theta.vercel.app/api/add-to-cart'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'bookId': bookId,
//         }),
//       );
//
//       print('Response status code: ${response.statusCode}');
//       print('Response body: ${response.body}');
//
//       final responseData = jsonDecode(response.body);
//
//       if (response.statusCode == 200) {
//         print(responseData['message']); // This should print "Book added to cart"
//       } else if (response.statusCode == 400) {
//         print(responseData['error']); // This should print "Book already in cart" if that's the case
//       } else {
//         print('Failed to add book to cart: ${responseData['error']}');
//       }
//     } catch (e) {
//       print('Error occurred while adding book to cart: $e');
//     }
//   } else {
//     print('Token not found');
//   }
//   print("End of addBookToCart function");
// }