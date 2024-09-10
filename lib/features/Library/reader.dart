import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:price_app/features/utils/exports.dart';

class PdfViewerProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class PDFViewerPage extends StatefulWidget {
  final String pdfUrl;
  final String bookTitle;

  const PDFViewerPage({Key? key, required this.pdfUrl, required this.bookTitle}) : super(key: key);

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> with WidgetsBindingObserver {
  late PdfViewerController _pdfViewerController;
  int _currentIndex = 0;
  String? _localPdfPath;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    WidgetsBinding.instance.addObserver(this);
    if (!kIsWeb) {
      _downloadAndCachePdf();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      SystemChannels.platform.invokeMethod('SystemUiOverlay.setSystemUIOverlayStyle', const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ));
    }
  }

  Future<void> _downloadAndCachePdf() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${widget.bookTitle}.pdf');

      if (await file.exists()) {
        setState(() => _localPdfPath = file.path);
      } else {
        final response = await http.get(Uri.parse(widget.pdfUrl));
        await file.writeAsBytes(response.bodyBytes);
        setState(() => _localPdfPath = file.path);
      }
    } catch (e) {
      print('Error caching PDF: $e');
      // Fallback to network loading
      setState(() => _localPdfPath = null);
    }
  }

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PdfViewerProvider(),
      child: Consumer<PdfViewerProvider>(
        builder: (context, pdfProvider, child) {
          return Theme(
            data: pdfProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.bookTitle),
                actions: [
                  IconButton(
                    icon: Icon(pdfProvider.isDarkMode ? Icons.brightness_7 : Icons.brightness_4),
                    onPressed: pdfProvider.toggleDarkMode,
                  ),
                ],
              ),
              body: kIsWeb || _localPdfPath == null
                  ? SfPdfViewer.network(
                widget.pdfUrl,
                controller: _pdfViewerController,
                enableTextSelection: false,
                enableDocumentLinkAnnotation: false,
                enableHyperlinkNavigation: false,
                pageSpacing: 4,
                scrollDirection: PdfScrollDirection.vertical,
                canShowScrollHead: false,
                canShowPaginationDialog: false,
                initialZoomLevel: 1.0,
                interactionMode: PdfInteractionMode.pan,
                pageLayoutMode: pdfProvider.isDarkMode ? PdfPageLayoutMode.single : PdfPageLayoutMode.continuous,
              )
                  : Container(
                color: pdfProvider.isDarkMode ? Colors.black87 : Colors.white,
                child: SfPdfViewer.file(
                  File(_localPdfPath!),
                  controller: _pdfViewerController,
                  enableTextSelection: false,
                  enableDocumentLinkAnnotation: false,
                  enableHyperlinkNavigation: false,
                  pageSpacing: 4,
                  scrollDirection: PdfScrollDirection.vertical,
                  canShowScrollHead: false,
                  canShowPaginationDialog: false,
                  initialZoomLevel: 1.0,
                  interactionMode: PdfInteractionMode.pan,
                  pageLayoutMode: pdfProvider.isDarkMode ? PdfPageLayoutMode.single : PdfPageLayoutMode.continuous,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}



// import 'dart:async';
// import 'package:price_app/features/utils/exports.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
//
//
// class PdfViewerProvider extends ChangeNotifier {
//   bool _isDarkMode = false;
//   bool get isDarkMode => _isDarkMode;
//
//   void toggleDarkMode() {
//     _isDarkMode = !_isDarkMode;
//     notifyListeners();
//   }
// }
//
// class PDFViewerPage extends StatefulWidget {
//   final String pdfUrl;
//   final String bookTitle;
//
//   const PDFViewerPage({super.key, required this.pdfUrl, required this.bookTitle});
//
//   @override
//   _PDFViewerPageState createState() => _PDFViewerPageState();
// }
//
// class _PDFViewerPageState extends State<PDFViewerPage> with WidgetsBindingObserver {
//   late PdfViewerController _pdfViewerController;
//   int _currentIndex = 0;
//   String? _localPdfPath;
//
//   @override
//   void initState() {
//     super.initState();
//     _pdfViewerController = PdfViewerController();
//     WidgetsBinding.instance.addObserver(this);
//     _downloadAndCachePdf();
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       SystemChannels.platform.invokeMethod('SystemUiOverlay.setSystemUIOverlayStyle', const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//       ));
//     }
//   }
//
//   Future<void> _downloadAndCachePdf() async {
//     final directory = await getApplicationDocumentsDirectory();
//     final file = File('${directory.path}/${widget.bookTitle}.pdf');
//
//     if (await file.exists()) {
//       setState(() => _localPdfPath = file.path);
//     } else {
//       final response = await http.get(Uri.parse(widget.pdfUrl));
//       await file.writeAsBytes(response.bodyBytes);
//       setState(() => _localPdfPath = file.path);
//     }
//   }
//
//   void _onItemTapped(int index) {
//     setState(() => _currentIndex = index);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => PdfViewerProvider(),
//       child: Consumer<PdfViewerProvider>(
//         builder: (context, pdfProvider, child) {
//           return Theme(
//             data: pdfProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
//             child: Scaffold(
//               appBar: AppBar(
//                 title: Text(widget.bookTitle),
//                 actions: [
//                   IconButton(
//                     icon: Icon(pdfProvider.isDarkMode ? Icons.brightness_7 : Icons.brightness_4),
//                     onPressed: pdfProvider.toggleDarkMode,
//                   ),
//                 ],
//               ),
//               body: _localPdfPath == null
//                   ? const Center(child: CircularProgressIndicator())
//                   : Container(
//                 color: pdfProvider.isDarkMode ? Colors.black87 : Colors.white,
//                 child: SfPdfViewer.file(
//                   File(_localPdfPath!),
//                   controller: _pdfViewerController,
//                   enableTextSelection: false,
//                   enableDocumentLinkAnnotation: false,
//                   enableHyperlinkNavigation: false,
//                   pageSpacing: 4,
//                   scrollDirection: PdfScrollDirection.vertical,
//                   canShowScrollHead: false,
//                   canShowPaginationDialog: false,
//                   initialZoomLevel: 1.0,
//                   interactionMode: PdfInteractionMode.pan,
//                   pageLayoutMode: pdfProvider.isDarkMode ? PdfPageLayoutMode.single : PdfPageLayoutMode.continuous,
//                 ),
//               ),
//               bottomNavigationBar: CustomBottomNavigationBar(
//                 currentIndex: _currentIndex,
//                 onTap: _onItemTapped,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//





// class PDFViewerPage extends StatefulWidget {
//   final String pdfUrl;
//   final String bookTitle;
//
//   PDFViewerPage({required this.pdfUrl, required this.bookTitle});
//
//   @override
//   _PDFViewerPageState createState() => _PDFViewerPageState();
// }
//
// class _PDFViewerPageState extends State<PDFViewerPage> with WidgetsBindingObserver {
//   late PdfViewerController _pdfViewerController;
//   int _currentIndex = 0;
//   bool _isControlsVisible = true;
//   Timer? _controlsTimer;
//   bool _isDarkMode = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _pdfViewerController = PdfViewerController();
//     WidgetsBinding.instance.addObserver(this);
//     _startControlsTimer();
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _controlsTimer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       // App is in background, disable screenshot
//       SystemChannels.platform.invokeMethod('SystemUiOverlay.setSystemUIOverlayStyle', SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//       ));
//     }
//   }
//
//   void _startControlsTimer() {
//     _controlsTimer?.cancel();
//     _controlsTimer = Timer(Duration(seconds: 3), () {
//       setState(() {
//         _isControlsVisible = false;
//       });
//     });
//   }
//
//   void _toggleControls() {
//     setState(() {
//       _isControlsVisible = !_isControlsVisible;
//     });
//     if (_isControlsVisible) {
//       _startControlsTimer();
//     }
//   }
//
//   void _toggleDarkMode() {
//     setState(() {
//       _isDarkMode = !_isDarkMode;
//     });
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//     navigateToScreen(context, index);
//   }
//
//   @override
//
//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
//       child: Scaffold(
//         appBar: _isControlsVisible ? AppBar(
//           title: Text(widget.bookTitle),
//           actions: [
//             IconButton(
//               icon: Icon(_isDarkMode ? Icons.brightness_7 : Icons.brightness_4),
//               onPressed: _toggleDarkMode,
//             ),
//           ],
//         ) : null,
//         body: Stack(
//           children: [
//             Container(
//               color: _isDarkMode ? Colors.black87 : Colors.white,
//               child: SfPdfViewer.network(
//                 widget.pdfUrl,
//                 controller: _pdfViewerController,
//                 enableTextSelection: false,
//                 enableDocumentLinkAnnotation: false,
//                 enableHyperlinkNavigation: false,
//                 pageSpacing: 4,
//                 scrollDirection: PdfScrollDirection.vertical,
//                 canShowScrollHead: false,
//                 canShowPaginationDialog: false,
//                 initialZoomLevel: 1.0,
//                 interactionMode: PdfInteractionMode.pan,
//                 pageLayoutMode: _isDarkMode ? PdfPageLayoutMode.single : PdfPageLayoutMode.continuous,
//               ),
//             ),
//             if (_isControlsVisible)
//               Positioned(
//                 bottom: 16,
//                 left: 16,
//                 right: 16,
//                 child: Container(
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: _isDarkMode ? Colors.grey[800]!.withOpacity(0.8) : Colors.white.withOpacity(0.8),
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.zoom_out),
//                         onPressed: () {
//                           _pdfViewerController.zoomLevel -= 0.1;
//                           _startControlsTimer();
//                         },
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.zoom_in),
//                         onPressed: () {
//                           _pdfViewerController.zoomLevel += 0.1;
//                           _startControlsTimer();
//                         },
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.bookmark_border),
//                         onPressed: () {
//                           // TODO: Implement bookmark functionality
//                           _startControlsTimer();
//                         },
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.search),
//                         onPressed: () {
//                           // TODO: Implement search functionality
//                           _startControlsTimer();
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         bottomNavigationBar: _isControlsVisible ? CustomBottomNavigationBar(
//           currentIndex: _currentIndex,
//           onTap: (index) {
//             setState(() {
//               _currentIndex = index;
//             });
//             _onItemTapped;
//           },
//         ) : null,
//       ),
//     );
//   }
// }











// class PDFViewerPage extends StatefulWidget {
//   final String pdfUrl;
//
//   PDFViewerPage({required this.pdfUrl});
//
//   @override
//   _PDFViewerPageState createState() => _PDFViewerPageState();
// }
//
// class _PDFViewerPageState extends State<PDFViewerPage> {
//   late PdfViewerController _pdfViewerController;
//   int _currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _pdfViewerController = PdfViewerController();
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//     navigateToScreen(context, index);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Viewer'),
//       ),
//       backgroundColor: Colors.grey[200], // Set background color
//       body: Stack(
//         children: [
//           if (widget.pdfUrl != null && widget.pdfUrl.isNotEmpty)
//           SfPdfViewer.network(
//             widget.pdfUrl,
//             controller: _pdfViewerController,
//             enableTextSelection: false,
//             enableDocumentLinkAnnotation: false,
//             enableHyperlinkNavigation: false,
//             pageSpacing: 4,
//             scrollDirection: PdfScrollDirection.horizontal,
//             canShowScrollHead: false,
//             initialZoomLevel: 0.9, // Set initial zoom level
//            // Enable animations
//           ),
//           Positioned(
//             bottom: 16,
//             left: 16,
//             right: 16,
//             child: Container(
//               height: 50,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.zoom_out),
//                     onPressed: () {
//                       _pdfViewerController.zoomLevel -= 0.1;
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.zoom_in),
//                     onPressed: () {
//                       _pdfViewerController.zoomLevel += 0.1;
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.navigate_before),
//                     onPressed: () {
//                       _pdfViewerController.jumpToPage(
//                         _pdfViewerController.pageNumber - 1,
//                       );
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.navigate_next),
//                     onPressed: () {
//                       _pdfViewerController.jumpToPage(
//                         _pdfViewerController.pageNumber + 1,
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }