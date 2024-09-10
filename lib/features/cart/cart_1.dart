import 'package:flutter/cupertino.dart';
import 'package:price_app/features/utils/exports.dart';

class CartOne extends StatelessWidget {
  const CartOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFDFDF),
      appBar: const CartAppBar(customTitle: 'Cart(3)',),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        margin: const EdgeInsets.only(top: 8, bottom: 1),
        color: Colors.white,
        child: Column(
          children: [
            const Row(children: [
              CustomCheckboxWidget(),
              SizedBox(width: 20,),
              Text('Select All', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,),)

            ],),
            const SizedBox(height: 20,),
            Row(children: [
              const CustomCheckboxWidget(),
              const Image(image: AssetImage('images/bone of your bones.jpg')),
              const Spacer(),
              Column(children: [
                const Text('The journey into your Vision'),
                const SizedBox(height: 10,),
                Row(children: [
                  IconButton(onPressed: (){}, icon: const Icon(Icons.remove_circle_outline)),
                  const SizedBox(width: 10,),
                  const Text('1'),
                  const SizedBox(width: 10,),
                  IconButton(onPressed: (){}, icon: const Icon(Icons.add_circle_rounded)),
                ],)
              ],),
              const Spacer(),
              Column(children: [
                const Text('N250'),
                const SizedBox(height: 10,),
                IconButton(onPressed: (){}, icon: const Icon(CupertinoIcons.delete))
              ],)
            ],),
            const Spacer(),
            CustomCartButtonTwoA(child: 'Checkout (2)', onPressed: (){})
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1, onTap: (int ) {  },),
    );
  }
}
