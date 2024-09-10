import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:price_app/features/utils/exports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  late TabController _tabController;
  List<BookModel> _books = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging && _tabController.index != 0) {
      _fetchBooks();
    }
  }

  Future<void> _fetchBooks() async {
    setState(() => _isLoading = true);
    try {
      String url = 'https://book-app-backend-theta.vercel.app/api/category';
      String category = '';

      switch (_tabController.index) {
        case 1:
          category = 'study books';
          break;
        case 2:
          category = 'marriage books';
          break;
        case 3:
          category = 'outreach books';
          break;
      }

      if (category.isNotEmpty) {
        url += '?query=$category';
      }

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

  Widget _buildHomeTab() {
    return ListView(
      children: [
        const NewReleaseContainer(),
        SizedBox(height: 10.h),
        _buildSectionWithArrow('Suggested for you', '', () {}),
        _buildSectionWithArrow('Suggested Study Materials', 'study books', () => _tabController.animateTo(1)),
        _buildSectionWithArrow('Suggested Marriage Materials', 'marriage books', () => _tabController.animateTo(2)),
        _buildSectionWithArrow('Suggested Outreach Materials', 'outreach books', () => _tabController.animateTo(3)),
      ],
    );
  }

  Widget _buildSectionWithArrow(String title, String category, VoidCallback onArrowPressed) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward, size: 24.sp),
                onPressed: onArrowPressed,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          SuggestedBooksContainer(
            category: category,
            onArrowPressed: onArrowPressed,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 47.h),
        child: SafeArea(
          child: Column(
            children: [
              SearchAppBar(
                title: 'Books',
                onSearch: (query) {
                  setState(() => _isSearching = true);
                  Provider.of<SearchProvider>(context, listen: false).searchBooks(query);
                },
                onCancelSearch: () {
                  setState(() => _isSearching = false);
                },
              ),
              SizedBox(
                height: 47.h,
                child: TabBar(
                  controller: _tabController,
                  labelStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  labelColor: const Color(0xFF0D5415),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: const Color(0xFF0D5415),
                  indicatorWeight: 2.w,
                  isScrollable: true,
                  tabs: const [
                    Tab(text: 'All'),
                    Tab(text: 'Study'),
                    Tab(text: 'Marriage'),
                    Tab(text: 'Outreach'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isSearching
          ? const SearchResultsWidget()
          : TabBarView(
        controller: _tabController,
        children: [
          _buildHomeTab(),
          _buildCategoryTab('Study Books'),
          _buildCategoryTab('Marriage Books'),
          _buildCategoryTab('Outreach Books'),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String title) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(10.w),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
          ),
        ),
        _isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildBookGrid(),
      ],
    );
  }

  Widget _buildBookGrid() {
    return _books.isEmpty
        ? Center(child: Text('No books available', style: TextStyle(fontSize: 16.sp)))
        : GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(10.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemCount: _books.length,
      itemBuilder: (context, index) {
        final book = _books[index];
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
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.r),
              child: Image.network(
                book.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Icon(Icons.error));
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }
}





// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:price_app/features/utils/exports.dart';
//
//
// class HomePageScreen extends StatefulWidget {
//   const HomePageScreen({super.key});
//
//   @override
//   State<HomePageScreen> createState() => _HomePageScreenState();
// }
//
// class _HomePageScreenState extends State<HomePageScreen>
//     with SingleTickerProviderStateMixin {
//   bool _isSearching = false;
//   late TabController _tabController;
//   Map<String, List<BookModel>> _categoryBooks = {
//     'study books': [],
//     'marriage books': [],
//     'outreach books': [],
//   };
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     _tabController.addListener(_handleTabSelection);
//     _loadCachedBooks();
//   }
//
//   void _handleTabSelection() {
//     if (_tabController.indexIsChanging && _tabController.index != 0) {
//       _loadBooks(_getCategoryFromIndex(_tabController.index));
//     }
//   }
//
//   String _getCategoryFromIndex(int index) {
//     switch (index) {
//       case 1:
//         return 'study books';
//       case 2:
//         return 'marriage books';
//       case 3:
//         return 'outreach books';
//       default:
//         return '';
//     }
//   }
//
//   Future<void> _loadCachedBooks() async {
//     for (var category in _categoryBooks.keys) {
//       final cachedBooks = await _getCachedBooks(category);
//       if (cachedBooks != null) {
//         setState(() {
//           _categoryBooks[category] = cachedBooks;
//         });
//       } else {
//         _loadBooks(category);
//       }
//     }
//   }
//
//   Future<void> _loadBooks(String category) async {
//     setState(() => _isLoading = true);
//     try {
//       await _fetchBooks(category);
//     } catch (e) {
//       print('Error loading books: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _fetchBooks(String category) async {
//     try {
//       String url =
//           'https://book-app-backend-theta.vercel.app/api/category?query=$category';
//
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body)[0];
//         final books = data.map((json) => BookModel.fromJson(json)).toList();
//         setState(() {
//           _categoryBooks[category] = books;
//         });
//         await _cacheBooks(category, books);
//       } else {
//         throw Exception('Failed to load books');
//       }
//     } catch (e) {
//       print('Error fetching books: $e');
//     }
//   }
//
//   Future<void> _cacheBooks(String category, List<BookModel> books) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('books_$category', jsonEncode(books));
//     await prefs.setString(
//         'books_${category}_timestamp', DateTime.now().toIso8601String());
//   }
//
//   Future<List<BookModel>?> _getCachedBooks(String category) async {
//     final prefs = await SharedPreferences.getInstance();
//     final cachedBooksJson = prefs.getString('books_$category');
//     final cacheTimestamp = prefs.getString('books_${category}_timestamp');
//
//     if (cachedBooksJson != null && cacheTimestamp != null) {
//       final cacheDateTime = DateTime.parse(cacheTimestamp);
//       final now = DateTime.now();
//
//       // Check if cache is less than 24 hours old
//       if (now.difference(cacheDateTime).inHours < 24) {
//         final List<dynamic> decodedBooks = jsonDecode(cachedBooksJson);
//         return decodedBooks.map((book) => BookModel.fromJson(book)).toList();
//       }
//     }
//     return null;
//   }
//
//   Future<void> refreshCategory(String category) async {
//     await _fetchBooks(category);
//   }
//
//   Widget _buildHomeTab() {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const NewReleaseContainer(),
//           SizedBox(height: 10.h),
//           _buildSectionWithArrow('Suggested for you', '', () {}),
//           _buildSectionWithArrow('Suggested Study Materials', 'study books',
//                   () => _tabController.animateTo(1)),
//           _buildSectionWithArrow('Suggested Marriage Materials',
//               'marriage books', () => _tabController.animateTo(2)),
//           _buildSectionWithArrow('Suggested Outreach Materials',
//               'outreach books', () => _tabController.animateTo(3)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSectionWithArrow(
//       String title, String category, VoidCallback onArrowPressed) {
//     return Padding(
//       padding: EdgeInsets.all(10.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
//               ),
//             ],
//           ),
//           SizedBox(height: 10.h),
//           SuggestedBooksContainer(
//             category: category,
//             onArrowPressed: onArrowPressed,
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context, designSize: const Size(375, 812));
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight((kToolbarHeight + 47).h),
//         child: Padding(
//           padding: EdgeInsets.only(left: 1.w),
//           child: Column(
//             children: [
//               SearchAppBar(
//                 title: 'Books',
//                 onSearch: (query) {
//                   setState(() {
//                     _isSearching = true;
//                   });
//                   Provider.of<SearchProvider>(context, listen: false)
//                       .searchBooks(query);
//                 },
//                 onCancelSearch: () {
//                   setState(() {
//                     _isSearching = false;
//                   });
//                 },
//               ),
//               Transform.translate(
//                 offset: Offset(-16.w, 0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.all(0),
//                     child: TabBar(
//                       controller: _tabController,
//                       labelStyle: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       labelColor: const Color(0xFF0B6F17),
//                       labelPadding: EdgeInsets.only(left: 0, right: 35.w),
//                       unselectedLabelStyle: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       unselectedLabelColor: Colors.grey,
//                       indicatorColor: const Color(0xFF0B6F17),
//                       indicatorWeight: 1.w,
//                       isScrollable: true,
//                       tabs: const [
//                         Tab(text: 'All'),
//                         Tab(text: 'Study'),
//                         Tab(text: 'Marriage'),
//                         Tab(text: 'Outreach'),
//                       ],
//                       splashFactory: NoSplash.splashFactory,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: _isSearching
//           ? const SearchResultsWidget()
//           : TabBarView(
//         controller: _tabController,
//         children: [
//           _buildHomeTab(),
//           _buildCategoryTab('Study Books'),
//           _buildCategoryTab('Marriage Books'),
//           _buildCategoryTab('Outreach Books'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCategoryTab(String title) {
//     String category = title.toLowerCase().replaceAll(' books', ' books');
//     return RefreshIndicator(
//       onRefresh: () => refreshCategory(category),
//       child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.all(10.w),
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 18.sp,
//                 ),
//               ),
//             ),
//             _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : _buildBookGrid(category),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBookGrid(String category) {
//     final books = _categoryBooks[category] ?? [];
//     return books.isEmpty
//         ? Center(
//         child:
//         Text('No books available', style: TextStyle(fontSize: 16.sp)))
//         : GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         childAspectRatio: 0.7,
//         crossAxisSpacing: 10.w,
//         mainAxisSpacing: 10.h,
//       ),
//       itemCount: books.length,
//       itemBuilder: (context, index) {
//         final book = books[index];
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
//               borderRadius: BorderRadius.circular(5.r),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(5.r),
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




// //newest one
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:price_app/features/utils/exports.dart';
//
//
// class HomePageScreen extends StatefulWidget {
//   const HomePageScreen({super.key});
//
//   @override
//   State<HomePageScreen> createState() => _HomePageScreenState();
// }
//
// class _HomePageScreenState extends State<HomePageScreen> with SingleTickerProviderStateMixin {
//   bool _isSearching = false;
//   late TabController _tabController;
//   List<BookModel> _books = [];
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     _tabController.addListener(_handleTabSelection);
//   }
//
//   void _handleTabSelection() {
//     if (_tabController.indexIsChanging && _tabController.index != 0) {
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
//
//   Widget _buildHomeTab() {
//     return Column(
//       children: [
//         Expanded(
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const NewReleaseContainer(),
//                 SizedBox(height: 10.h),
//                 _buildSectionWithArrow('Suggested for you', '', () {}),
//                 _buildSectionWithArrow('Suggested Study Materials', 'study books', () => _tabController.animateTo(1)),
//                 _buildSectionWithArrow('Suggested Marriage Materials', 'marriage books', () => _tabController.animateTo(2)),
//                 _buildSectionWithArrow('Suggested Outreach Materials', 'outreach books', () => _tabController.animateTo(3)),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSectionWithArrow(String title, String category, VoidCallback onArrowPressed) {
//     return Padding(
//       padding: EdgeInsets.all(10.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
//               ),
//             ],
//           ),
//           SizedBox(height: 10.h),
//           SuggestedBooksContainer(
//             category: category,
//             onArrowPressed: onArrowPressed,
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Initialize ScreenUtil
//     ScreenUtil.init(context, designSize: const Size(375, 812));
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight((kToolbarHeight + 47).h),
//         child: Padding(
//           padding: EdgeInsets.only(left: 1.w),
//           child: Column(
//             children: [
//               SearchAppBar(
//                 title: 'Books',
//                 onSearch: (query) {
//                   setState(() {
//                     _isSearching = true;
//                   });
//                   Provider.of<SearchProvider>(context, listen: false).searchBooks(query);
//                 },
//                 onCancelSearch: () {
//                   setState(() {
//                     _isSearching = false;
//                   });
//                 },
//               ),
//               Transform.translate(
//                 offset: Offset(-16.w, 0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.all(0),
//                     child: TabBar(
//                       controller: _tabController,
//                       labelStyle: TextStyle(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.w500,
//                       ),
//                       labelColor: const Color(0xFF0D5415),
//                       labelPadding: EdgeInsets.only(left: 0, right: 35.w),
//                       unselectedLabelStyle: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       unselectedLabelColor: Colors.grey,
//                       indicatorColor: const Color(0xFF0D5415),
//                       indicatorWeight: 1.w,
//                       isScrollable: true,
//                       tabs: const [
//                         Tab(text: 'All'),
//                         Tab(text: 'Study'),
//                         Tab(text: 'Marriage'),
//                         Tab(text: 'Outreach'),
//                       ],
//                       splashFactory: NoSplash.splashFactory,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: _isSearching
//           ? const SearchResultsWidget()
//           : TabBarView(
//         controller: _tabController,
//         children: [
//           _buildHomeTab(),
//           _buildCategoryTab('Study Books'),
//           _buildCategoryTab('Marriage Books'),
//           _buildCategoryTab('Outreach Books'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCategoryTab(String title) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(10.w),
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontWeight: FontWeight.w700,
//                 fontSize: 18.sp,
//               ),
//             ),
//           ),
//           _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : _buildBookGrid(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBookGrid() {
//     return _books.isEmpty
//         ? Center(child: Text('No books available', style: TextStyle(fontSize: 16.sp)))
//         : GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         childAspectRatio: 0.7,
//         crossAxisSpacing: 10.w,
//         mainAxisSpacing: 10.h,
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
//               borderRadius: BorderRadius.circular(5.r),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(5.r),
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
//



// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:price_app/features/utils/exports.dart';
//
// class HomePageScreen extends StatefulWidget {
//   const HomePageScreen({super.key});
//
//   @override
//   State<HomePageScreen> createState() => _HomePageScreenState();
// }
//
// class _HomePageScreenState extends State<HomePageScreen> with SingleTickerProviderStateMixin {
//   bool _isSearching = false;
//   late TabController _tabController;
//   List<BookModel> _books = [];
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     _tabController.addListener(_handleTabSelection);
//   }
//
//   void _handleTabSelection() {
//     if (_tabController.indexIsChanging && _tabController.index != 0) {
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
//   Widget _buildHomeTab() {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const NewReleaseContainer(),
//           const SizedBox(height: 10),
//           _buildSectionWithArrow('Suggested for you', '', () {}),
//           _buildSectionWithArrow('Suggested Study Materials', 'study books', () => _tabController.animateTo(1)),
//           _buildSectionWithArrow('Suggested Marriage Materials', 'marriage books', () => _tabController.animateTo(2)),
//           _buildSectionWithArrow('Suggested Outreach Materials', 'outreach books', () => _tabController.animateTo(3)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSectionWithArrow(String title, String category, VoidCallback onArrowPressed) {
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           SuggestedBooksContainer(
//             category: category,
//             onArrowPressed: onArrowPressed,
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(kToolbarHeight + 47),
//         child: Padding(
//           padding: const EdgeInsets.only(left: 1.0),
//           child: Column(
//             children: [
//               SearchAppBar(
//                 title: 'Books',
//                 onSearch: (query) {
//                   setState(() {
//                     _isSearching = true;
//                   });
//                   Provider.of<SearchProvider>(context, listen: false).searchBooks(query);
//                 },
//                 onCancelSearch: () {
//                   setState(() {
//                     _isSearching = false;
//                   });
//                 },
//               ),
//               Transform.translate(
//                 offset: const Offset(-16, 0),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.all(0),
//                     child: TabBar(
//                       controller: _tabController,
//                       labelStyle: const TextStyle(fontSize: 18.0,),
//                       labelColor: const Color(0xFF0D5415),
//                       labelPadding: const EdgeInsets.only(left: 0, right:35),
//                       unselectedLabelColor: Colors.grey,
//                       indicatorColor: const Color(0xFF0D5415),
//                       indicatorWeight: 1.0,
//                       isScrollable:true,
//                       tabs: const [
//                         Tab(text: 'All'),
//                         Tab(text: 'Study'),
//                         Tab(text: 'Marriage'),
//                         Tab(text: 'Outreach'),
//                       ],
//                       splashFactory: NoSplash.splashFactory, // Add this line to disable the splash effect
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//       ),
//       body: _isSearching
//           ? const SearchResultsWidget()
//           : TabBarView(
//         controller: _tabController,
//         children: [
//           _buildHomeTab(),
//           _buildCategoryTab('Study Books'),
//           _buildCategoryTab('Marriage Books'),
//           _buildCategoryTab('Outreach Books'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCategoryTab(String title) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Text(
//               title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w700,
//                 fontSize: 18,
//               ),
//             ),
//           ),
//           _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : _buildBookGrid(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBookGrid() {
//     return _books.isEmpty
//         ? const Center(child: Text('No books available'))
//         : GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         childAspectRatio: 0.7,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
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
//
//
