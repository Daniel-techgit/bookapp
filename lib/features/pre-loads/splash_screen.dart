import "package:price_app/features/utils/exports.dart";

class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  initState() {
    super.initState();
    _navigateToInitialRoute();
  }

  _navigateToInitialRoute() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushNamed(context, '/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.bottomCenter,
        height: MediaQuery.of(context).size.height*0.95,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'images/livingSeed logo.jpg'),
          ),
        ),
        child: Image.asset('images/livingSeed text.jpg'),
      ),
    );
  }
}
