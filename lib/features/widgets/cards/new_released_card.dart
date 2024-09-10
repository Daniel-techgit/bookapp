// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:price_app/features/utils/exports.dart';
//
// class NewReleaseContainer extends StatefulWidget {
//   const NewReleaseContainer({super.key});
//
//   @override
//   _NewReleaseContainerState createState() => _NewReleaseContainerState();
// }
//
// class _NewReleaseContainerState extends State<NewReleaseContainer> {
//   BookModel? latestBook;
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     loadLatestBook();
//   }
//
//   Future<void> loadLatestBook() async {
//     setState(() => _isLoading = true);
//     try {
//       // Try to load from cache first
//       final cachedBook = await _getCachedBook();
//       if (cachedBook != null) {
//         setState(() {
//           latestBook = cachedBook;
//           _isLoading = false;
//         });
//         return;
//       }
//
//       // If not in cache, fetch from network
//       await fetchLatestBook();
//     } catch (e) {
//       print('Error loading latest book: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> fetchLatestBook() async {
//     try {
//       final response = await http.get(Uri.parse('https://book-app-backend-theta.vercel.app/api/new-release-section'));
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final newLatestBook = BookModel.fromJson(data[0]);
//         setState(() {
//           latestBook = newLatestBook;
//         });
//         // Cache the fetched book
//         await _cacheBook(newLatestBook);
//       } else {
//         print('Failed to load latest book');
//       }
//     } catch (e) {
//       print('Error fetching latest book: $e');
//     }
//   }
//
//   Future<void> _cacheBook(BookModel books) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('latest_book', jsonEncode(books));
//     await prefs.setString('latest_book_timestamp', DateTime.now().toIso8601String());
//   }
//
//   Future<BookModel?> _getCachedBook() async {
//     final prefs = await SharedPreferences.getInstance();
//     final cachedBookJson = prefs.getString('latest_book');
//     final cacheTimestamp = prefs.getString('latest_book_timestamp');
//
//     if (cachedBookJson != null && cacheTimestamp != null) {
//       final cacheDateTime = DateTime.parse(cacheTimestamp);
//       final now = DateTime.now();
//
//       // Check if cache is less than 24 hours old
//       if (now.difference(cacheDateTime).inHours < 24) {
//         return BookModel.fromJson(jsonDecode(cachedBookJson));
//       }
//     }
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               gradient: SweepGradient(
//                 colors: [Color(0xFFC6FCDB),Colors.white,Color(0xFFC6FCDB),Colors.white,Colors.white,Color(0xFFC6FCDB),Colors.white,Colors.white],
//                 center: Alignment.centerRight,
//                 startAngle: 0.75,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey,
//                   offset: Offset(2.0, 2.0),
//                   blurRadius: 4,
//                   spreadRadius: 0,
//                   blurStyle: BlurStyle.normal,
//                 ),
//               ],
//             ),
//             child: latestBook == null
//                 ? const SizedBox(height: 120, child: Center(child: Text('No new release available')))
//                 : Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 32.0, left: 16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           latestBook!.title,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           'by ${latestBook!.author}',
//                           style: const TextStyle(
//                             color: Colors.black54,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => BookDetailsScreen(
//                           bookId: latestBook!.id,
//                         ),
//                       ),
//                     );
//                   },
//                   child: ClipRRect(
//                     borderRadius: const BorderRadius.only(
//                       topRight: Radius.circular(8),
//                       bottomRight: Radius.circular(8),
//                     ),
//                     child: Image.network(
//                       latestBook!.imageUrl,
//                       height: 120,
//                       width: 80,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 0,
//             left: 0,
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Color(0xFF0B6F17),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(8),
//                   bottomRight: Radius.circular(8),
//                 ),
//               ),
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 8,
//                 vertical: 4,
//               ),
//               child: const Text(
//                 'New Release',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
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
// }
















import "package:price_app/features/utils/exports.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewReleaseContainer extends StatefulWidget {
  const NewReleaseContainer({super.key});

  @override
  _NewReleaseContainerState createState() => _NewReleaseContainerState();
}

class _NewReleaseContainerState extends State<NewReleaseContainer> {
  BookModel? latestBook;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchLatestBook();
  }

  Future<void> fetchLatestBook() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('https://book-app-backend-theta.vercel.app/api/new-release-section'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          latestBook = BookModel.fromJson(data[0]);
        });
      } else {
        // Handle error
        print('Failed to load latest book');
      }
    } catch (e) {
      print('Error fetching latest book: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              gradient: SweepGradient(
                colors: [Color(0xFFC6FCDB),Colors.white,Color(0xFFC6FCDB),Colors.white,Colors.white,Color(0xFFC6FCDB),Colors.white,Colors.white],
                center: Alignment.centerRight,
                startAngle: 0.75,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(2.0, 2.0),
                  blurRadius: 4,
                  spreadRadius: 0,
                  blurStyle: BlurStyle.normal,
                ),
              ],
            ),
            child: latestBook == null
                ? const SizedBox(height: 120, child: Center(child: Text('No new release available')))
                : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32.0, left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          latestBook!.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'by ${latestBook!.author}',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print(latestBook!.title);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsScreen(
                          bookId: latestBook!.id,
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    child: Image.network(
                      latestBook!.imageUrl,
                      height: 120,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: const Color(0xFF0D5415),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              child: const Text(
                'New Release',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
















// import "package:price_app/features/utils/exports.dart";
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
//
// class NewReleaseContainer extends StatefulWidget {
//   const NewReleaseContainer({super.key});
//
//   @override
//   _NewReleaseContainerState createState() => _NewReleaseContainerState();
// }
//
// class _NewReleaseContainerState extends State<NewReleaseContainer> {
//   BookModel? latestBook;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchLatestBook();
//   }
//
//   Future<void> fetchLatestBook() async {
//     final response =
//     await http.get(Uri.parse('https://book-app-backend-theta.vercel.app/api/new-release-section'));
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         latestBook = BookModel.fromJson(data[0]);
//       });
//     } else {
//       // Handle error
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(8.0),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: latestBook == null
//                 ? const Center(child: CircularProgressIndicator())
//                 : Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 32.0, left: 16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           latestBook!.title,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           'by ${latestBook!.author}',
//                           style: const TextStyle(
//                             color: Colors.black54,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     print(latestBook!.title);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => BookDetailsScreen(
//                           bookId: latestBook!.id, // Pass the book ID
//                         ),
//                       ),
//                     );
//                   },
//                   child: ClipRRect(
//                     borderRadius: const BorderRadius.only(
//                       topRight: Radius.circular(8),
//                       bottomRight: Radius.circular(8),
//                     ),
//                     child: Image.network(
//                       latestBook!.imageUrl,
//                       height: 120,
//                       width: 80,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 0,
//             left: 0,
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(8),
//                   bottomRight: Radius.circular(8),
//                 ),
//               ),
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 8,
//                 vertical: 4,
//               ),
//               child: const Text(
//                 'New Release',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }