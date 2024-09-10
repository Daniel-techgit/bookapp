import 'package:price_app/features/utils/exports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CartProvider with ChangeNotifier {
  List<dynamic> _cartBooks = [];
  bool _isLoading = false;
  final _secureStorage = const FlutterSecureStorage();

  List<dynamic> get cartBooks => _cartBooks;
  bool get isLoading => _isLoading;

  Future<void> fetchCartData() async {
    _isLoading = true;
    notifyListeners();

    String? token = await _secureStorage.read(key: 'token');
    try {
      Map<String, dynamic> userCart = await fetchUserCart(token!);
      _cartBooks = userCart['books'];
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      print('Error: $error');
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to fetch cart. Please try again.');
    }
    }

  Future<Map<String, dynamic>> fetchUserCart(String token) async {
    final response = await http.get(
      Uri.parse('https://book-app-backend-theta.vercel.app/api/viewCart'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user cart');
    }
  }

  double calculateTotal() {
    return _cartBooks.fold(0, (sum, cartItem) {
      final book = cartItem['bookId'];
      if (book == null) {
        print('Warning: book is null for cart item: $cartItem');
        return sum;
      }

      String priceString = book['price']?.toString() ?? '0';
      priceString = priceString.replaceAll('\$', '').trim();
      double price = double.tryParse(priceString) ?? 0;

      return sum + price;
    });
  }

  Future<void> removeFromCart(String bookId) async {
    print('Removing book with ID: $bookId');
    String? token = await _secureStorage.read(key: 'token');
    try {
      final response = await http.delete(
        Uri.parse('https://book-app-backend-theta.vercel.app/api/deleteCart?bookId=$bookId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'bookId': bookId}),
      );

      if (response.statusCode == 200) {
        _cartBooks.removeWhere((item) => item['bookId']['_id'] == bookId);
        notifyListeners();
      } else {
        print('Failed to remove book. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to remove book from cart');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to remove book. Please try again.');
    }
    }

  Future<void> clearCart() async {
    String? token = await _secureStorage.read(key: 'token');
    try {
      final response = await http.delete(
        Uri.parse('https://book-app-backend-theta.vercel.app/api/clearCart'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _cartBooks.clear();
        notifyListeners();
      } else {
        throw Exception('Failed to clear cart');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to clear cart. Please try again.');
    }
    }
}