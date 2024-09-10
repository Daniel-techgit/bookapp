import "package:price_app/features/utils/exports.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProvider with ChangeNotifier {
  User? _user;
  User? get user => _user;

  Future<void> fetchUserProfile(String userId) async {
    print('Fetching user profile for userId: $userId');
    try {
      final response = await http.get(Uri.parse('https://book-app-backend-theta.vercel.app/api/userProfile?userId=$userId'));
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Decoded response data: $responseData');

        if (responseData['data'] != null) {
          try {
            _user = User.fromJson(responseData['data']);
            notifyListeners();
          } catch (e) {
            print('Error creating User object: $e');
            throw Exception('Failed to parse user data: $e');
          }
        } else {
          throw Exception('Data is null in the response');
        }
      } else {
        throw Exception('Failed to load user profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchUserProfile: $e');
      throw Exception('Failed to load user profile: $e');
    }
  }
}