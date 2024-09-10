import 'package:price_app/features/utils/exports.dart';

class CardPayImageRow extends StatelessWidget {
  const CardPayImageRow({super.key, });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'images/Cart Images/MasterCard_Logo.png', // Path to your Mastercard logo image
          width: 70,
          height: 50,
        ),
        const SizedBox(width: 10), // Adjust spacing between images
        Image.asset(
          'images/Cart Images/Old_Visa_Logo.png', // Path to your Visa logo image
          width: 70,
          height: 50,
        ),
      ],
    );
  }
}