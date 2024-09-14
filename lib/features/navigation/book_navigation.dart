// import 'package:price_app/features/utils/exports.dart';
//
// class MainNavigationScreen extends StatefulWidget {
//   final int initialIndex;
//   final Widget? initialPage;
//
//   const MainNavigationScreen({Key? key, this.initialIndex = 0, this.initialPage}) : super(key: key);
//
//   @override
//   _MainNavigationScreenState createState() => _MainNavigationScreenState();
// }
//
// class _MainNavigationScreenState extends State<MainNavigationScreen> {
//   late int _currentIndex;
//   late List<Widget> _pages;
//
//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.initialIndex;
//     _pages = [
//       const HomePageScreen(),
//       const CommunityPage(),
//       const LibraryPage(),
//       const Profile(),
//     ];
//     if (widget.initialPage != null) {
//       _pages[_currentIndex] = widget.initialPage!;
//     }
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//       _pages[index] = _getPageForIndex(index);
//     });
//   }
//
//   Widget _getPageForIndex(int index) {
//     switch (index) {
//       case 0:
//         return const HomePageScreen();
//       case 1:
//         return const CommunityPage();
//       case 2:
//         return const LibraryPage();
//       case 3:
//         return const Profile();
//       default:
//         return const HomePageScreen();
//     }
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
      const CustomerSupportPage(), // Add the new page
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
        return const CustomerSupportPage(); // Add the new page
      case 4:
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