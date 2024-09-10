import "package:price_app/features/utils/exports.dart";

class MyTextButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const MyTextButton({super.key, required this.buttonText, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.all(16.0),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color(0xFF0D5415),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide.none,
              ),
            ),
          ),
          onPressed:
          onPressed,

          child: Expanded(
            child: Text(buttonText,
              style: const TextStyle(
                color: Colors.white,
              ),),
          )),
    );
  }
}