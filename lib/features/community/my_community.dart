import "package:price_app/features/utils/exports.dart";

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  int _currentIndex = 0;



  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B6F17),
        elevation: 200,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
        title: const Text('My Community',style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/cart_zero');
              // Navigate to cart page
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people,
              size: 100,
              color: Color(0xFF0B6F17),
            ),
            const SizedBox(height: 20),
            const Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Ask for Assistance',
                style: TextStyle(
                  color: Color(0xFF0B6F17),
                )
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/customer_support');
              },
            ),
          ],
        ),
      ),
    );
  }
}