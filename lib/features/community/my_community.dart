import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:price_app/features/utils/exports.dart";

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  int _currentIndex = 0;
  bool _isLoading = false;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _navigateToCustomerSupport() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a delay to show the loading indicator
    await Future.delayed(Duration(milliseconds: 500));

    try {
      await Navigator.pushNamed(context, '/customer_support');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil
    ScreenUtil.init(context, designSize: Size(375, 812)); // Use your design's dimensions

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B6F17),
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
        title: Text(
          'My Community',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18.sp, // Responsive font size
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/cart_zero'),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w), // Responsive padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people,
                  size: 100.w, // Responsive icon size
                  color: Color(0xFF0B6F17),
                ),
                SizedBox(height: 20.h), // Responsive height
                Text(
                  'Coming Soon',
                  style: TextStyle(
                    fontSize: 24.sp, // Responsive font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.h), // Responsive height
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h), // Responsive padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r), // Responsive border radius
                    ),
                  ),
                  onPressed: _isLoading ? null : _navigateToCustomerSupport,
                  child: _isLoading
                      ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0B6F17)),
                      strokeWidth: 2.w, // Responsive stroke width
                    ),
                  )
                      : Text(
                    'Customer Support',
                    style: TextStyle(
                      color: Color(0xFF0B6F17),
                      fontSize: 16.sp, // Responsive font size
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}







// import "package:price_app/features/utils/exports.dart";
//
// class CommunityPage extends StatefulWidget {
//   const CommunityPage({super.key});
//
//   @override
//   _CommunityPageState createState() => _CommunityPageState();
// }
//
// class _CommunityPageState extends State<CommunityPage> {
//   int _currentIndex = 0;
//
//
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0B6F17),
//         elevation: 200,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//           onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
//         ),
//         title: const Text('My Community',style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.shopping_cart,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               Navigator.pushNamed(context, '/cart_zero');
//               // Navigate to cart page
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.people,
//               size: 100,
//               color: Color(0xFF0B6F17),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Coming Soon',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               child: const Text('Customer Support',
//                 style: TextStyle(
//                   color: Color(0xFF0B6F17),
//                 )
//               ),
//               onPressed: () {
//                 Navigator.pushNamed(context, '/customer_support');
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }