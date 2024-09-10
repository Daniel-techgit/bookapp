import 'package:price_app/features/utils/exports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class SearchProvider with ChangeNotifier {
  List<BookModel> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  List<BookModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> searchBooks(String query) async {
    print('SearchProvider: Searching for books with query: $query');
    _isLoading = true;
    _error = null;
    notifyListeners();

    final url = Uri.parse('https://book-app-backend-theta.vercel.app/api/search?query=$query');
    try {
      print('SearchProvider: Sending GET request to $url');
      final response = await http.get(url);
      print('SearchProvider: Received response with status code: ${response.statusCode}');
      print('SearchProvider: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> booksJson = json.decode(response.body)[0];
        _searchResults = booksJson.map((book) => BookModel.fromJson(book)).toList();
        print('SearchProvider: Parsed ${_searchResults.length} books from response');
        if (_searchResults.isEmpty) {
          _error = 'No books found';
        }
      } else if (response.statusCode == 404) {
        _error = 'No books found';
      } else {
        _error = 'Failed to load search results';
      }
    } catch (e) {
      print('SearchProvider: An error occurred: $e');
      _error = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
      print('SearchProvider: Search completed. Error: $_error, Results: ${_searchResults.length}');
    }
  }
}