import 'package:price_app/features/utils/exports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LibraryProvider with ChangeNotifier {
  List<dynamic> _libraryBooks = [];
  bool _isLoading = false;
  bool _isGridView = false;

  List<dynamic> get libraryBooks => _libraryBooks;
  bool get isLoading => _isLoading;
  bool get isGridView => _isGridView;

  LibraryProvider() {
    _loadFromLocal();
  }

  void setGridView(bool value) {
    _isGridView = value;
    notifyListeners();
  }

  Future<void> _loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final String? libraryData = prefs.getString('libraryBooks');
    if (libraryData != null) {
      _libraryBooks = jsonDecode(libraryData);
      notifyListeners();
    }
  }

  Future<void> _saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('libraryBooks', jsonEncode(_libraryBooks));
  }

  Future<void> fetchUserLibraryData(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://book-app-backend-theta.vercel.app/api/viewLibrary'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> userLibrary = jsonDecode(response.body);
        _libraryBooks = userLibrary['books'];
        await _saveToLocal();
      } else {
        throw Exception('Failed to fetch user library');
      }
    } catch (error) {
      print('Error: $error');
      await _loadFromLocal();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}