import 'package:price_app/features/utils/exports.dart';

class PaymentRadioButton extends StatefulWidget {
  const PaymentRadioButton({super.key});

  @override
  _PaymentRadioButtonState createState() => _PaymentRadioButtonState();
}

class _PaymentRadioButtonState extends State<PaymentRadioButton> {
  String _selectedOption = 'Option 1'; // Default selected option

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RadioListTile<String>(
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Image.asset(
              'images/Cart Images/paypal.png', // Path to your Visa logo image
              width: 200,
              height: 70,
            ),
          ),
          value: 'paypal',
          groupValue: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CardPayImageRow(),
              title: Text('Card Payment',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0XFF0A011A),
              ),),
            ),
          value: 'card payment',
          groupValue: _selectedOption,
          onChanged: (value) {
            setState(() {
              _selectedOption = value!;
            });
          },
        ),
      ],
    );
  }
}
