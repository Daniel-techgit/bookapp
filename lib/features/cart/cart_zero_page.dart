import 'package:price_app/features/utils/exports.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int _currentIndex = 0;
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).fetchCartData();
    });
  }

  void _handleCategorySelection(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _navigateToBooksDisplay(category);
  }

  void _navigateToBooksDisplay(String category) {
    Navigator.pushNamed(context, '/book_display');
  }




  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/home');
        return false;
      },
      child: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Column(
            children: [
              AppBar(
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
                ),
                title: Text(
                  'My Cart (${cartProvider.cartBooks.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: const Color(0xFF0B6F17),
                elevation: 200,
              ),
              Expanded(
                child: cartProvider.isLoading
                    ? const Center(child: CircularProgressIndicator(
                  color: Color(0xFF0B6F17),
                ))
                    : RefreshIndicator(
                  onRefresh: cartProvider.fetchCartData,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: cartProvider.cartBooks.isEmpty
                                ? _buildEmptyCart()
                                : _buildCartList(cartProvider),
                          ),
                        ],
                      ),
                      if (cartProvider.cartBooks.isNotEmpty)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: _buildCheckoutButton(cartProvider),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/Cart Images/zero cart.png',
              width: 0.6.sw,
              height: 0.3.sh,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20.h),
            Text(
              'Nothing in your Cart?',
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'That\'s ok, take your time to browse\n through our resources until you find\n what you\'re looking for.',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D5415),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  minimumSize: Size(double.infinity, 50.h),
                ),
                child: Text('Continue Browsing',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
                onPressed: () {
                  _handleCategorySelection('all');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartList(CartProvider cartProvider) {
    return ListView.builder(
      itemCount: cartProvider.cartBooks.length,
      itemBuilder: (context, index) {
        final cartItem = cartProvider.cartBooks[index];
        final book = cartItem['bookId'];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Row(
              children: [
                SizedBox(
                  width: 80.w,
                  child: AspectRatio(
                    aspectRatio: 2/3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        book['imageUrl'] ?? '',
                        width: 80.w,
                        height: 100.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book['title'] ?? '',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        book['author'] ?? '',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      Text(
                        book['price'] ?? '\$0.00',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    if (book['_id'] != null) {
                      bool confirm = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Remove from Cart"),
                            content: const Text("Are you sure you want to remove this book from your cart?"),
                            actions: [
                              TextButton(
                                child: const Text("Cancel",
                                  style: TextStyle(
                                      color: Color(0xFF0B6F17)
                                  ),),
                                onPressed: () => Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: const Text("Remove",
                                style: TextStyle(
                                  color: Color(0xFF0B6F17)
                                ),
                                ),
                                onPressed: () => Navigator.of(context).pop(true),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm) {
                        try {
                          // Show loading indicator
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return const Center(child: CircularProgressIndicator(
                                color: Color(0xFF0B6F17),
                              ));
                            },
                          );

                          await cartProvider.removeFromCart(book['_id']);

                          // Hide loading indicator
                          Navigator.of(context).pop();

                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Book removed from cart')),
                          );
                        } catch (error) {
                          // Hide loading indicator
                          Navigator.of(context).pop();

                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to remove book from cart')),
                          );
                        }
                      }
                    } else {
                      print('Cannot remove book: Invalid ID');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cannot remove book: Invalid ID')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckoutButton(CartProvider cartProvider) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0B6F17),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          minimumSize: Size(double.infinity, 50.h),
        ),
        child: Text(
          'Checkout (₦${cartProvider.calculateTotal().toStringAsFixed(2)})',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PaymentScreen(),
            ),
          );
        },
      ),
    );
  }
}