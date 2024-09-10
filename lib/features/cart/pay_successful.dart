import 'package:price_app/features/utils/exports.dart';

class PaySuccessful extends StatelessWidget {
  const PaySuccessful({super.key});

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    return Expanded(
      child: Scaffold(
          backgroundColor: const Color(0xFFDFDFDF),
          appBar: AppBar(
            leading: const Icon(Icons.chevron_left, size: 30,),
          ),
          body:Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 5),
                  color: Colors.white,
                  alignment: Alignment.topCenter,
                  width: double.infinity,
                  height: sh*0.65,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Image.asset('images/Cart Images/Checkmark.png',),
                      const Spacer(),
                      const Text('Your order has been successfully processed\n and the book(s) have been added to your\n library. Happy reading!',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      CustomCartButtonTwoA(child: 'My Order Details', onPressed: (){}),
                      const SizedBox(height: 15,),
                      CustomCartButtonTwoB(child: 'Go to library', onPressed: (){}),
                      const Spacer(),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: const Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BookScrollTitle(mainTitle: 'Books you might like', subAction: 'See more...',),
                      SizedBox(height: 20,),
                      horizontal_scroll_view()
                    ],
                  ),
                )
              ],
            ),
          ),
          ),
      );
  }
}

