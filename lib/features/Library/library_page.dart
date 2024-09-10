import 'package:price_app/features/utils/exports.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final _secureStorage = const FlutterSecureStorage();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    String? token = await _secureStorage.read(key: 'token');
    await Provider.of<LibraryProvider>(context, listen: false).fetchUserLibraryData(token!);
    }

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  void _showLendDialog(BuildContext context, dynamic book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            bool isLending = false;
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Lend "${book['bookId']['title']}"',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: "Enter borrower's email or username",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: isLending ? null : () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: isLending
                              ? null
                              : () async {
                            setModalState(() => isLending = true);
                            await Future.delayed(const Duration(seconds: 2));
                            setModalState(() => isLending = false);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('This function is coming soon')),
                            );
                          },
                          child: isLending
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : const Text('Lend'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBookItem(dynamic book, bool isGridView) {
    final bookDetails = book['bookId'];
    final pdfUrl = bookDetails['pdfUrl'] ?? '';

    if (bookDetails == null) {
      return const ListTile(
        leading: Icon(Icons.book),
        title: Text('Book details not available'),
      );
    }

    Widget bookImage = bookDetails['imageUrl'] != null
        ? AspectRatio(
      aspectRatio: 3 / 4,
      child: Image.network(
        bookDetails['imageUrl'],
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
      ),
    )
        : AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        color: Colors.grey[300],
        child: Icon(Icons.book, size: isGridView ? 50 : 30),
      ),
    );

    Widget bookInfo = Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bookDetails['title'] ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            bookDetails['author'] ?? '',
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(8)),
                  onPressed: () async {
                    if (pdfUrl.isNotEmpty) {
                      // Show loading dialog
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.green,
                          ));
                        },
                      );

                      // Simulate loading time
                      await Future.delayed(const Duration(seconds: 2));

                      // Dismiss the loading dialog
                      Navigator.of(context).pop();

                      // Navigate to the reader page
                      Navigator.pushNamed(
                        context,
                        '/reader',
                        arguments: {
                          'bookTitle': bookDetails['title'] ?? 'Book',
                          'pdfUrl': pdfUrl,
                          'localPdfPath': null,
                          // Add this if you have a local path
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('PDF not available')),
                      );
                    }
                  },

                  // onPressed: () async {
                  //   if (pdfUrl.isNotEmpty) {
                  //     showDialog(
                  //       context: context,
                  //       barrierDismissible: false,
                  //       builder: (BuildContext context) {
                  //         return const Center(child: CircularProgressIndicator(
                  //           color: Colors.green,
                  //         ));
                  //       },
                  //     );
                  //     await Future.delayed(const Duration(seconds: 2));
                  //     Navigator.of(context).pop();
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => PDFViewerPage(
                  //           pdfUrl: pdfUrl,
                  //           bookTitle: bookDetails['title'] ?? 'Book',
                  //         ),
                  //       ),
                  //     );
                  //   } else {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(content: Text('PDF not available')),
                  //     );
                  //   }
                  // },

                  child: const Text('Read', style: TextStyle(fontSize: 12, color: Color(0xFF0B6F17))),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(8)),
                  onPressed: () => _showLendDialog(context, book),
                  child: const Text('Lend', style: TextStyle(fontSize: 12, color: Color(0xFF0B6F17))),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (isGridView) {
      return Card(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: bookImage),
            Padding(
              padding: const EdgeInsets.all(8),
              child: bookInfo,
            ),
          ],
        ),
      );
    } else {
      return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: 80,
                  child: bookImage
              ),
              const SizedBox(width: 16),
              Expanded(child: bookInfo),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.of(context).pushReplacementNamed('/home'); // Replace with your home route
        return false;
      },
      child: Consumer<LibraryProvider>(
        builder: (context, libraryProvider, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF0B6F17),
              elevation: 200,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back,
                  color: Colors.white,),
                onPressed: () => Navigator.of(context).pushReplacementNamed('/home'), // Replace with your home route
              ),
              title: Text('My Library (${libraryProvider.libraryBooks.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              actions: [
                IconButton(
                  icon: Icon(libraryProvider.isGridView ? Icons.list : Icons.grid_view,
                  color: Colors.white,),
                  onPressed: () => libraryProvider.setGridView(!libraryProvider.isGridView),
                ),
              ],
            ),
            body: libraryProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: _fetchData,
              child: libraryProvider.isGridView
                  ? GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: libraryProvider.libraryBooks.length,
                itemBuilder: (context, index) => _buildBookItem(libraryProvider.libraryBooks[index], true),
              )
                  : ListView.builder(
                itemCount: libraryProvider.libraryBooks.length,
                itemBuilder: (context, index) => _buildBookItem(libraryProvider.libraryBooks[index], false),
              ),
            ),
            // bottomNavigationBar: CustomBottomNavigationBar(
            //   currentIndex: _currentIndex,
            //   onTap: _onItemTapped,
            // ),
          );
        },
      ),
    );
  }
}


















// class LibraryPage extends StatefulWidget {
//   @override
//   _LibraryPageState createState() => _LibraryPageState();
// }
//
// class _LibraryPageState extends State<LibraryPage> {
//   List<dynamic> libraryBooks = [];
//   final _secureStorage = const FlutterSecureStorage();
//   bool _isGridView = false;
//   bool _isLoading = false;
//   int _currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserLibraryData();
//   }
//
//   void _onItemTapped(int index) {
//     setState(() => _currentIndex = index);
//     navigateToScreen(context, index);
//   }
//
//   Future<void> fetchUserLibraryData() async {
//     setState(() => _isLoading = true);
//     String? token = await _secureStorage.read(key: 'token');
//     if (token != null) {
//       try {
//         Map<String, dynamic> userLibrary = await fetchUserLibrary(token);
//         setState(() {
//           libraryBooks = userLibrary['books'];
//           _isLoading = false;
//         });
//       } catch (error) {
//         print('Error: $error');
//         setState(() => _isLoading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to fetch library. Please try again.')),
//         );
//       }
//     } else {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please log in to view your library.')),
//       );
//     }
//   }
//
//   Future<Map<String, dynamic>> fetchUserLibrary(String token) async {
//     final response = await http.get(
//       Uri.parse('https://book-app-backend-theta.vercel.app/api/viewLibrary'),
//       headers: {'Authorization': 'Bearer $token'},
//     );
//
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to fetch user library');
//     }
//   }
//
//   void _showLendDialog(BuildContext context, dynamic book) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setModalState) {
//             bool _isLending = false;
//             return Padding(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               child: Container(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Text('Lend "${book['bookId']['title']}"',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 16),
//                     TextField(
//                       decoration: InputDecoration(
//                         hintText: "Enter borrower's email or username",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: <Widget>[
//                         ElevatedButton(
//                           child: Text('Cancel'),
//                           onPressed: _isLending ? null : () => Navigator.pop(context),
//                         ),
//                         ElevatedButton(
//                           child: _isLending
//                               ? SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                             ),
//                           )
//                               : Text('Lend'),
//                           onPressed: _isLending
//                               ? null
//                               : () async {
//                             setModalState(() => _isLending = true);
//                             await Future.delayed(Duration(seconds: 2));
//                             setModalState(() => _isLending = false);
//                             Navigator.pop(context);
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text('This function is coming soon')),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildBookItem(dynamic book, bool isGridView) {
//     final bookDetails = book['bookId'];
//     final pdfUrl = bookDetails['pdfUrl'] ?? '';
//
//     if (bookDetails == null) {
//       return ListTile(
//         leading: Icon(Icons.book),
//         title: Text('Book details not available'),
//       );
//     }
//
//     Widget bookImage = bookDetails['imageUrl'] != null
//         ? AspectRatio(
//       aspectRatio: 3 / 4,
//       child: Image.network(
//         bookDetails['imageUrl'],
//         fit: BoxFit.cover,
//         loadingBuilder: (context, child, loadingProgress) {
//           if (loadingProgress == null) return child;
//           return Center(child: CircularProgressIndicator());
//         },
//       ),
//     )
//         : AspectRatio(
//       aspectRatio: 3 / 4,
//       child: Container(
//         color: Colors.grey[300],
//         child: Icon(Icons.book, size: isGridView ? 50.sp: 30.sp),
//       ),
//     );
//
//     Widget bookInfo = Flexible(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             bookDetails['title'] ?? '',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           SizedBox(height: 4.h),
//           Text(
//             bookDetails['author'] ?? '',
//             style: TextStyle(fontSize: 12.sp),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           SizedBox(height: 8.h),
//           Row(
//             children: [
//               Expanded(
//                 child: ElevatedButton(
//                   child: Text('Read', style: TextStyle(fontSize: 12.sp)),
//                   style: ElevatedButton.styleFrom(padding: EdgeInsets.all(8.w)),
//                   onPressed: () async {
//                     if (pdfUrl.isNotEmpty) {
//                       showDialog(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (BuildContext context) {
//                           return Center(child: CircularProgressIndicator());
//                         },
//                       );
//                       await Future.delayed(Duration(seconds: 2));
//                       Navigator.of(context).pop();
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PDFViewerPage(
//                               pdfUrl: pdfUrl,
//                           bookTitle: bookDetails['title'] ?? 'Book',),
//                         ),
//                       );
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('PDF not available')),
//                       );
//                     }
//                   },
//                 ),
//               ),
//               SizedBox(width: 8.w),
//               Expanded(
//                 child: ElevatedButton(
//                   child: Text('Lend', style: TextStyle(fontSize: 12.sp)),
//                   style: ElevatedButton.styleFrom(padding: EdgeInsets.all(8.w)),
//                   onPressed: () => _showLendDialog(context, book),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//
//     if (isGridView) {
//       return Card(
//         elevation: 4,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(child: bookImage),
//             Padding(
//               padding: EdgeInsets.all(8.w),
//               child: bookInfo,
//             ),
//           ],
//         ),
//       );
//     } else {
//       return Card(
//         elevation: 4,
//         child: Padding(
//           padding: EdgeInsets.all(8),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                   width: 80.w,
//                   child: bookImage
//               ),
//               SizedBox(width: 16.w),
//               Expanded(child: bookInfo),
//             ],
//           ),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Library (${libraryBooks.length})'),
//         actions: [
//           IconButton(
//             icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
//             onPressed: () => setState(() => _isGridView = !_isGridView),
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : RefreshIndicator(
//         onRefresh: fetchUserLibraryData,
//         child: _isGridView
//             ? GridView.builder(
//           padding: EdgeInsets.all(8),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             childAspectRatio: 0.6,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//           ),
//           itemCount: libraryBooks.length,
//           itemBuilder: (context, index) => _buildBookItem(libraryBooks[index], true),
//         )
//             : ListView.builder(
//           itemCount: libraryBooks.length,
//           itemBuilder: (context, index) => _buildBookItem(libraryBooks[index], false),
//         ),
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

















// import 'package:price_app/features/utils/exports.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class LibraryPage extends StatefulWidget {
//   @override
//   _LibraryPageState createState() => _LibraryPageState();
// }
//
// class _LibraryPageState extends State<LibraryPage> {
//   List<dynamic> libraryBooks = [];
//   final _secureStorage = const FlutterSecureStorage();
//   bool _isGridView = false;
//   bool _isLoading = false;
//   bool _isLending = false;
//   int _currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchUserLibraryData();
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//     navigateToScreen(context, index);
//   }
//
//   Future<void> fetchUserLibraryData() async {
//     setState(() => _isLoading = true);
//     String? token = await _secureStorage.read(key: 'token');
//     if (token != null) {
//       try {
//         Map<String, dynamic> userLibrary = await fetchUserLibrary(token);
//         setState(() {
//           libraryBooks = userLibrary['books'];
//           _isLoading = false;
//         });
//       } catch (error) {
//         print('Error: $error');
//         setState(() => _isLoading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to fetch library. Please try again.')),
//         );
//       }
//     } else {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please log in to view your library.')),
//       );
//     }
//   }
//
//   Future<Map<String, dynamic>> fetchUserLibrary(String token) async {
//     final response = await http.get(
//       Uri.parse('https://book-app-backend-theta.vercel.app/api/viewLibrary'),
//       headers: {
//         'Authorization': 'Bearer $token',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to fetch user library');
//     }
//   }
//
//   void _showBorrowDialog(BuildContext context, dynamic book) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setModalState) {
//             return Padding(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               child: Container(
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Text('Lend "${book['bookId']['title']}"',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     SizedBox(height: 16),
//                     TextField(
//                       decoration: InputDecoration(
//                         hintText: "Enter borrower's email or username",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: <Widget>[
//                         ElevatedButton(
//                           child: Text('Cancel'),
//                           onPressed: _isLending ? null : () => Navigator.pop(context),
//                         ),
//                         ElevatedButton(
//                           child: _isLending
//                               ? SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                             ),
//                           )
//                               : Text('Lend'),
//                           onPressed: _isLending
//                               ? null
//                               : () async {
//                             setModalState(() => _isLending = true);
//                             // Simulate lending process
//                             await Future.delayed(Duration(seconds: 2));
//                             setModalState(() => _isLending = false);
//                             Navigator.pop(context);
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text('Book lent successfully')),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildBookItem(dynamic book, bool isGridView) {
//     final bookDetails = book['bookId'];
//     final pdfUrl = bookDetails['pdfUrl'] ?? '';
//
//     if (bookDetails == null) {
//       return ListTile(
//         leading: Icon(Icons.book),
//         title: Text('Book details not available'),
//       );
//     }
//
//     Widget bookImage = bookDetails['imageUrl'] != null
//         ? AspectRatio(
//       aspectRatio: 3 / 4, // Standard book cover ratio
//       child: Image.network(
//         bookDetails['imageUrl'],
//         fit: BoxFit.cover,
//         loadingBuilder: (context, child, loadingProgress) {
//           if (loadingProgress == null) return child;
//           return Center(child: CircularProgressIndicator());
//         },
//       ),
//     )
//         : AspectRatio(
//       aspectRatio: 3 / 4,
//       child: Container(
//         color: Colors.grey[300],
//         child: Icon(Icons.book, size: isGridView ? 50 : 30),
//       ),
//     );
//
//
//     Widget bookInfo = Flexible(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             bookDetails['title'] ?? '',
//             style: TextStyle(fontWeight: FontWeight.bold),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           SizedBox(height: 4),
//           Text(
//             bookDetails['author'] ?? '',
//             style: TextStyle(fontSize: 12),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           SizedBox(height: 8),
//           Row(
//             children: [
//               ElevatedButton(
//                 child: Text('Read'),
//                 onPressed: () async {
//                   if (pdfUrl.isNotEmpty) {
//                     // Show loading indicator
//                     showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (BuildContext context) {
//                         return Center(child: CircularProgressIndicator());
//                       },
//                     );
//
//                     // Simulate loading delay
//                     await Future.delayed(Duration(seconds: 2));
//
//                     // Hide loading indicator
//                     Navigator.of(context).pop();
//
//                     // Navigate to PDF viewer
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => PDFViewerPage(pdfUrl: pdfUrl),
//                       ),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('PDF not available')),
//                     );
//                   }
//                 },
//               ),
//               SizedBox(width: 8),
//               ElevatedButton(
//                 child: Text('Lend'),
//                 onPressed: () => _showBorrowDialog(context, book),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//
//     if (isGridView) {
//       return Card(
//         elevation: 4,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(child: bookImage),
//             Padding(
//               padding: EdgeInsets.all(8),
//               child: bookInfo,
//             ),
//           ],
//         ),
//       );
//     } else {
//       return Card(
//         elevation: 4,
//         child: Padding(
//           padding: EdgeInsets.all(8),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 width: 80,
//                   child: bookImage
//               ),
//               SizedBox(width: 16),
//               Expanded(child: bookInfo),
//             ],
//           ),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Library (${libraryBooks.length})'),
//         actions: [
//           IconButton(
//             icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
//             onPressed: () {
//               setState(() {
//                 _isGridView = !_isGridView;
//               });
//             },
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : RefreshIndicator(
//         onRefresh: fetchUserLibraryData,
//         child: _isGridView
//             ? GridView.builder(
//           padding: EdgeInsets.all(8),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             childAspectRatio: 0.6,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//           ),
//           itemCount: libraryBooks.length,
//           itemBuilder: (context, index) {
//             return _buildBookItem(libraryBooks[index], true);
//           },
//         )
//             : ListView.builder(
//           itemCount: libraryBooks.length,
//           itemBuilder: (context, index) {
//             return _buildBookItem(libraryBooks[index], false);
//           },
//         ),
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }