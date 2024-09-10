import 'package:price_app/features/utils/exports.dart';
import 'package:uuid/uuid.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}



class _PaymentScreenState extends State<PaymentScreen> {
  final String publicKey = "FLWPUBK_TEST-7ef89f5811db55af46029254844d17b4-X";
  final String encryptionKey = "FLWSECK_TEST2e98ed4c4052";
  final _secureStorage = const FlutterSecureStorage();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserAndCart();
    });
  }

  Future<void> _loadUserAndCart() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    String? userId = await _secureStorage.read(key: 'userId');
    await userProvider.fetchUserProfile(userId!);
    await cartProvider.fetchCartData();
  }

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  void _handlePayment(BuildContext context, double amount, User user,
      List<dynamic> cartBooks) async {
    final customer = Customer(
      name: "${user.firstName} ${user.lastName}",
      phoneNumber: user.phoneNumber,
      email: user.email,
    );

    final Flutterwave flutterwave = Flutterwave(
        context: context,
        publicKey: publicKey,
        currency: "NGN",
        txRef: const Uuid().v4(),
        amount: amount.toString(),
        customer: customer,
        paymentOptions: "card, ussd",
        customization: Customization(title: "Book Payment"),
        isTestMode: true,
        redirectUrl: 'https://your-redirect-url.com');

    try {
      final ChargeResponse response = await flutterwave.charge();
      if (response.success == true) {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(child: CircularProgressIndicator());
          },
        );

        // Clear the cart
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        await cartProvider.clearCart();

        // Navigate to LibraryPage
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LibraryPage()),
        );

        // Add books to library in the background
        _addBooksToLibraryInBackground(cartBooks);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "Payment Successful. Your books are being added to your library.")),
        );
      } else {
        _showMessage("Payment Failed: ${response.status}", isError: true);
      }
    } catch (error) {
      _showMessage("An error occurred: ${error.toString()}", isError: true);
    }
  }

  void _addBooksToLibraryInBackground(List<dynamic> cartBooks) {
    // Use a microtask to run this code after the current build cycle
    Future.microtask(() async {
      final bookProvider = Provider.of<BookProvider>(context, listen: false);
      for (var cartItem in cartBooks) {
        try {
          await bookProvider.addBookToLibrary(cartItem['bookId']['_id']);
        } catch (e) {
          print(
              "Failed to add book ${cartItem['bookId']['title']} to library: $e");
          // Consider implementing a retry mechanism or notifying the user if this fails
        }
      }
    });
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return Consumer<CartProvider>(
          builder: (context, cartProvider, _) {
            final user = userProvider.user;
            final cartBooks = cartProvider.cartBooks;

            if (user == null || cartBooks.isEmpty) {
              return Scaffold(
                appBar: AppBar(title: const Text("Payment")),
                body: const Center(child: CircularProgressIndicator(
                  color: Color(0xFF0B6F17),
                )),
              );
            }

            return Scaffold(
              appBar: AppBar(
                  backgroundColor: const Color(0xFF0B6F17),
                  elevation: 200,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,),
                    onPressed: () => Navigator.of(context).pushReplacementNamed('/cart_zero'), // Replace with your home route
                  ),
                  title: const Text(
                    "Payment",
                    style:TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payment Details:',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 10),
                    Text('Name: ${user.firstName} ${user.lastName}'),
                    Text('Email: ${user.email}'),
                    Text('Phone: ${user.phoneNumber}'),
                    const SizedBox(height: 20),
                    Text('Cart Items:',
                        style: Theme.of(context).textTheme.titleMedium),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartBooks.length,
                        itemBuilder: (context, index) {
                          final book = cartBooks[index]['bookId'];
                          return ListTile(
                            title: Text(book['title']),
                            subtitle: Text('Price: ₦${book['price']}'),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                        'Total Amount: ₦${cartProvider.calculateTotal().toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 20),
                    MyElevatedButton(
                      buttonText: 'Make Payment',
                      onPressed: () {
                        _handlePayment(
                          context,
                          cartProvider.calculateTotal(),
                          user,
                          cartBooks,
                        );
                      },
                    ),
                    // ElevatedButton(
                    //   child: const Text('Make Payment'),
                    //   onPressed: () {
                    //     _handlePayment(
                    //       context,
                    //       cartProvider.calculateTotal(),
                    //       user,
                    //       cartBooks,
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
              bottomNavigationBar: CustomBottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: _onItemTapped,
              ),
            );
          },
        );
      },
    );
  }
}

// class PaymentScreen extends StatefulWidget {
//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<CartProvider>(
//       builder: (context, cartProvider, child) {
//         return Scaffold(
//           backgroundColor: const Color(0xFFDFDFDF),
//           appBar: const CartAppBar(customTitle: "Confirm your order"),
//           body: Container(
//             color: Colors.white,
//             width: double.infinity,
//             padding: EdgeInsets.all(30.w),
//             margin: EdgeInsets.only(top: 5.h),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'How would you like to pay?',
//                   style: TextStyle(
//                     fontSize: 15.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 Text(
//                   ' Choose the most suitable payment method \n for you.',
//                   style: TextStyle(
//                     fontSize: 15.sp,
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 PaymentRadioButton(),
//                 Spacer(),
//                 Container(
//                   alignment: Alignment.center,
//                   child: Text(
//                     'By continuing, you agree to our privacy policy and terms of use.',
//                     style: TextStyle(
//                       fontSize: 10.sp,
//                       fontStyle: FontStyle.italic,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 CustomCartButtonTwoA(
//                   child: 'Make Payment (N${cartProvider.calculateTotal().toStringAsFixed(2)})',
//                   onPressed: () {
//                     // Implement payment logic here
//                   },
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
