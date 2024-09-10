import "package:price_app/features/utils/exports.dart";

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _currentIndex = 0;
  final _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    // Fetch user profile when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserProfile();
    });
  }
  Future<void> _fetchUserProfile() async {
    final userId = await _secureStorage.read(key: 'userId');
    if (userId != null) {
      await Provider.of<UserProvider>(context, listen: false).fetchUserProfile(userId);
    } else {
      print('UserId not found in secure storage');
      // Handle the case when userId is not available
      // For example, you might want to navigate to the login screen
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _logout(BuildContext context) async {
    await _secureStorage.deleteAll(); // Clear all stored data
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = userProvider.user!;
          print('User data in widget: ${user.firstName}, ${user.lastName}, ${user.email}');
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 80, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  _buildInfoSection('Name', '${user.firstName} ${user.lastName}'),
                  _buildInfoSection('Email', user.email),
                  _buildInfoSection('Phone', user.phoneNumber),
                ],
              ),
            ),
          );
        },
      ),
      // bottomNavigationBar: CustomBottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTap: _onItemTapped,
      // ),
    );
  }

  Widget _buildInfoSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
          const Divider(height: 20),
        ],
      ),
    );
  }
}