// import 'package:price_app/features/utils/exports.dart';
//
// class MainNavigationScreen extends StatefulWidget {
//   const MainNavigationScreen({Key? key}) : super(key: key);
//
//   @override
//   _MainNavigationScreenState createState() => _MainNavigationScreenState();
// }
//
// class _MainNavigationScreenState extends State<MainNavigationScreen> {
//   int _currentIndex = 0;
//
//   final List<Widget> _pages = [
//     const HomePageScreen(),
//     const CommunityPage(),
//     const LibraryPage(),
//     const Profile(),
//
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _pages,
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
//



import 'package:price_app/features/utils/exports.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  final Widget? initialPage;

  const MainNavigationScreen({Key? key, this.initialIndex = 0, this.initialPage}) : super(key: key);

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pages = [
      const HomePageScreen(),
      const CommunityPage(),
      const LibraryPage(),
      const Profile(),
    ];
    if (widget.initialPage != null) {
      _pages[_currentIndex] = widget.initialPage!;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pages[index] = _getPageForIndex(index);
    });
  }

  Widget _getPageForIndex(int index) {
    switch (index) {
      case 0:
        return const HomePageScreen();
      case 1:
        return const CommunityPage();
      case 2:
        return const LibraryPage();
      case 3:
        return const Profile();
      default:
        return const HomePageScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:price_app/features/utils/exports.dart';
//
// class MainNavigationScreen extends StatefulWidget {
//   final Widget? child;
//   final bool showBottomNav;
//   final int initialIndex;
//
//   const MainNavigationScreen({
//     Key? key,
//     this.child,
//     this.showBottomNav = true,
//     this.initialIndex = 0,
//   }) : super(key: key);
//
//   @override
//   _MainNavigationScreenState createState() => _MainNavigationScreenState();
// }
//
// class _MainNavigationScreenState extends State<MainNavigationScreen> {
//   late int _currentIndex;
//
//   final List<Widget> _pages = [
//     const HomePageScreen(),
//     const CommunityPage(),
//     const LibraryPage(),
//     const Profile(),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.initialIndex;
//   }
//
//   void _onItemTapped(int index) {
//     if (widget.child == null) {
//       setState(() {
//         _currentIndex = index;
//       });
//     } else {
//       // Navigate to the corresponding page
//       switch (index) {
//         case 0:
//           Navigator.pushReplacementNamed(context, '/home');
//           break;
//         case 1:
//           Navigator.pushReplacementNamed(context, '/community');
//           break;
//         case 2:
//           Navigator.pushReplacementNamed(context, '/library');
//           break;
//         case 3:
//           Navigator.pushReplacementNamed(context, '/profile');
//           break;
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: widget.child ?? IndexedStack(
//         index: _currentIndex,
//         children: _pages,
//       ),
//       bottomNavigationBar: widget.showBottomNav ? CustomBottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onItemTapped,
//       ) : null,
//     );
//   }
// }





// import 'package:price_app/features/utils/exports.dart';
//
// class MainNavigationScreen extends StatefulWidget {
//   const MainNavigationScreen({super.key});
//
//   @override
//   _MainNavigationScreenState createState() => _MainNavigationScreenState();
// }
//
// class _MainNavigationScreenState extends State<MainNavigationScreen> {
//   int _currentIndex = 0;
//
//   final List<Widget> _pages = [
//     const HomePageScreen(),
//     const CommunityPage(),
//     const LibraryPage(),
//     const Profile(),
//     const CartPage(),
//     const AIAssistancePage(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _pages,
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }







// import "package:price_app/features/utils/exports.dart";
//
//
// void navigateToScreen(BuildContext context, int index) {
//   switch (index) {
//     case 0:
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const HomePageScreen()),
//       );
//       break;
//     case 1:
//       Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => CommunityPage()
//           )
//       );
//       break;
//     case 2:
//       Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => LibraryPage()
//           )
//       );
//       break;
//     case 3:
//       Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => Profile()
//           )
//       );
//       break;
//   }
// }