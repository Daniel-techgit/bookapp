import 'package:price_app/features/utils/exports.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: Colors.white,
      elevation: 8.0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF0B6F17),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Community',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Library',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.support_agent),  // New item for Customer Support
          label: 'Support',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'logout',
        ),
      ],
    );
  }
}