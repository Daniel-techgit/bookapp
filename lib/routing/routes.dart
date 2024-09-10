import 'package:price_app/features/utils/exports.dart';

Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const Splash(), // Default route
  '/welcome': (context) => const WelcomeScreen(),
  '/registration1': (context) => const Registration1(),
  '/registration2': (context) => const Registration2(),
  '/home': (context) => const MainNavigationScreen(initialIndex: 0),
  '/community': (context) => const MainNavigationScreen(initialIndex: 1),
  '/library': (context) => const MainNavigationScreen(initialIndex: 2),
  '/profile': (context) => const MainNavigationScreen(initialIndex: 3),
  '/login': (context) => const Login(),
  '/user_profile': (context) => const MainNavigationScreen(initialIndex: 3),
  '/cart_zero': (context) => MainNavigationScreen(initialIndex: 0, initialPage: CartPage()),
  '/pay_successful': (context) => const PaySuccessful(),
  '/cart_one': (context) => MainNavigationScreen(initialIndex: 0, initialPage: CartOne()),
  '/confirm_order': (context) => MainNavigationScreen(initialIndex: 0, initialPage: ConfirmOrder()),
  '/payment_screen': (context) => MainNavigationScreen(initialIndex: 0, initialPage: PaymentScreen()),
  '/book_details': (context) => MainNavigationScreen(initialIndex: 0, initialPage: BookDetailsScreen(bookId: ModalRoute.of(context)!.settings.arguments as String),),
  '/book_display': (context) => MainNavigationScreen(initialIndex: 0, initialPage: BooksDisplay()),
  '/customer_support': (context) => MainNavigationScreen(initialIndex: 1, initialPage: CustomerSupportPage()),
  '/reader': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return MainNavigationScreen(
      initialIndex: 2, // Assuming library is index 2
      initialPage: PDFViewerPage(
        bookTitle: args['bookTitle'],
        pdfUrl: args['pdfUrl'],
      ),
    );
  },
};




// import 'package:price_app/features/utils/exports.dart';
//
//
// Map<String,  WidgetBuilder> appRoutes={
//   '/': (context) => const Splash(), // Default route
//   '/welcome': (context) => const WelcomeScreen(),
//   '/registration1': (context) => const Registration1(),
//   '/registration2': (context) => const Registration2(),
//   '/home': (context) => const MainNavigationScreen(),
//   '/community': (context) => const MainNavigationScreen(),
//   '/library': (context) => const MainNavigationScreen(),
//   '/profile': (context) => const MainNavigationScreen(),
//   '/login': (context) => const Login(),
//   '/user_profile': (context) => const Profile(),
//   '/cart_zero': (context) =>const CartPage(),
//   '/pay_successful': (context) => const PaySuccessful(),
//   '/cart_one': (context) => const CartOne(),
//   '/confirm_order': (context) => const ConfirmOrder(),
//   '/payment_screen': (context) => const PaymentScreen()
//
// };