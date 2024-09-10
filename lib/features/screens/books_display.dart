import "package:price_app/features/utils/exports.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

class BooksDisplay extends StatefulWidget {
  const BooksDisplay({Key? key}) : super(key: key);

  @override
  State<BooksDisplay> createState() => _BooksDisplayState();
}

class _BooksDisplayState extends State<BooksDisplay> {
  List<BookModel> _books = [];
  bool _isLoading = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    setState(() => _isLoading = true);
    try {
      const url = 'https://book-app-backend-theta.vercel.app/api/category';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)[0];
        setState(() {
          _books = data.map((json) => BookModel.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print('Error fetching books: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        title: 'Books',
        onSearch: (query) {
          setState(() {
            _isSearching = true;
          });
          Provider.of<SearchProvider>(context, listen: false).searchBooks(query);
        },
        onCancelSearch: () {
          setState(() {
            _isSearching = false;
          });
          _fetchBooks(); // Reload all books when search is cancelled
        },
      ),
      body: Stack(
        children: [
          _isSearching
              ? Consumer<SearchProvider>(
            builder: (context, searchProvider, child) {
              return _buildBookGrid(searchProvider.searchResults);
            },
          )
              : _buildBookGrid(_books),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF0B6F17),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBookGrid(List<BookModel> books) {
    return books.isEmpty
        ? const Center(child: Text('No books available'))
        : GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailsScreen(
                  bookId: book.id,
                ),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                book.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}




// import "package:price_app/features/utils/exports.dart";
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class BooksDisplay extends StatefulWidget {
//   final String initialCategory;
//
//   const BooksDisplay({super.key, required this.initialCategory});
//
//   @override
//   State<BooksDisplay> createState() => _BooksDisplayState();
// }
//
// class _BooksDisplayState extends State<BooksDisplay> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   List<BookModel> _books = [];
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     _tabController.addListener(_handleTabSelection);
//     _setInitialTab();
//     _fetchBooks();
//   }
//
//   void _setInitialTab() {
//     switch (widget.initialCategory) {
//       case 'all':
//         _tabController.index = 0;
//         break;
//       case 'study':
//         _tabController.index = 1;
//         break;
//       case 'marriage':
//         _tabController.index = 2;
//         break;
//       case 'outreach':
//         _tabController.index = 3;
//         break;
//     }
//   }
//
//   void _handleTabSelection() {
//     if (_tabController.indexIsChanging) {
//       _fetchBooks();
//     }
//   }
//
//   Future<void> _fetchBooks() async {
//     setState(() => _isLoading = true);
//     try {
//       String url = 'https://book-app-backend-theta.vercel.app/api/category';
//       String category = '';
//
//       switch (_tabController.index) {
//         case 0:
//           category = '';
//           break;
//         case 1:
//           category = 'study books';
//           break;
//         case 2:
//           category = 'marriage books';
//           break;
//         case 3:
//           category = 'outreach books';
//           break;
//       }
//
//       if (category.isNotEmpty) {
//         url += '?query=$category';
//       }
//
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body)[0];
//         setState(() {
//           _books = data.map((json) => BookModel.fromJson(json)).toList();
//         });
//       } else {
//         throw Exception('Failed to load books');
//       }
//     } catch (e) {
//       print('Error fetching books: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Book App'),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'All'),
//             Tab(text: 'Study'),
//             Tab(text: 'Marriage'),
//             Tab(text: 'Outreach'),
//           ],
//         ),
//       ),
//       body: Stack(
//         children: [
//           TabBarView(
//             controller: _tabController,
//             children: List.generate(4, (index) => _buildBookGrid()),
//           ),
//           if (_isLoading)
//             Container(
//               color: Colors.black54,
//               child: const Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBookGrid() {
//     return _books.isEmpty
//         ? const Center(child: Text('No books available'))
//         : GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         childAspectRatio: 0.7,
//       ),
//       itemCount: _books.length,
//       itemBuilder: (context, index) {
//         final book = _books[index];
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => BookDetailsScreen(
//                   bookId: book.id,
//                 ),
//               ),
//             );
//           },
//           child: Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(5),
//               child: Image.network(
//                 book.imageUrl,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     _tabController.removeListener(_handleTabSelection);
//     _tabController.dispose();
//     super.dispose();
//   }
// }