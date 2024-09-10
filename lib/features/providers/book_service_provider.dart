import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:price_app/features/utils/exports.dart';

class BookProvider extends ChangeNotifier {
  final _secureStorage = const FlutterSecureStorage();
  BookModel? _currentBook;
  bool _isLoading = false;
  String? _error;

  BookModel? get currentBook => _currentBook;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchBookData(String bookId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://book-app-backend-theta.vercel.app/api/bookId?_id=$bookId'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)[0];
        _currentBook = BookModel.fromJson(jsonData);
      } else {
        _error = 'Failed to fetch book data';
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error fetching book data: $e';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBookToCart(String bookId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final token = await _secureStorage.read(key: 'token');

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('https://book-app-backend-theta.vercel.app/api/add-to-cart'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'bookId': bookId,
          }),
        );

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200) {
          print(responseData['message']); // Book added to cart
        } else if (response.statusCode == 400) {
          _error = responseData['error'];
          notifyListeners();// Book already in cart
        } else {
          _error = 'Failed to add book to cart: ${responseData['error']}';
          notifyListeners();
        }
      } catch (e) {
        _error = 'Error occurred while adding book to cart: $e';
        notifyListeners();
      }
    } else {
      _error = 'Token not found';
      notifyListeners();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addBookToLibrary(String bookId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final token = await _secureStorage.read(key: 'token');

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('https://book-app-backend-theta.vercel.app/api/add-to-library'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'bookId': bookId,
          }),
        );

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200) {
          print(responseData['message']); // Book added to library
        } else if (response.statusCode == 400) {
          _error = responseData['error'];
          notifyListeners();// Book already in library
        } else {
          _error = 'Failed to add book to library: ${responseData['error']}';
          notifyListeners();
        }
      } catch (e) {
        _error = 'Error occurred while adding book to library: $e';
        notifyListeners();
      }
    } else {
      _error = 'Token not found';
      notifyListeners();
    }

    _isLoading = false;
    notifyListeners();
  }
}