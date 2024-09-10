import 'package:price_app/features/utils/exports.dart';

class ConfirmOrder extends StatefulWidget {
  const ConfirmOrder({super.key});

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFDFDF),
      appBar: const CartAppBar(customTitle: 'Confirm your order'),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          color: Colors.white,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: const Text('Please see the details of your order below.\n Upon successful payment, the books will\n be added to your library.',
          textAlign: TextAlign.center,) ,
        ),
        Expanded(
          flex: (MediaQuery.of(context).size.width *200).toInt(),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            color: Colors.white,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 3, top: 1),
            child: const Column(children: [
              Row(children: [
                Image(image: AssetImage('images/bone of your bones.jpg')),
                SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text('The journey into your Vision'),
                  SizedBox(height: 20,),
                  Text('1 x'),
                  ],),
                Spacer(),
                Text('N250'),
              ],),
              Spacer(),
              Row(children: [
                Text('Total'),
                Spacer(),
                Text('N500')
              ],)
            ],),
          ),
        ),
        // Container(
        //   color: Colors.white,
        //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //     Text('How would you like to pay?'),
        //     SizedBox(height: 20,),
        //     Text('Choose the most suitable payment \nmethod for you.'),
        //     Row(children: [
        //
        //     ],)
        //   ],),
        // )
        const Spacer(),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            color: Colors.white,
            alignment: Alignment.bottomCenter,
            child: CustomCartButtonTwoA(child: 'Continue (500)', onPressed: (){}))
      ],),
    );
  }
}
