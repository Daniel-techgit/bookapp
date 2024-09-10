import "package:price_app/features/utils/exports.dart";

class CustomCartButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const CustomCartButton({super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.red,
        ),
        alignment: Alignment.center,
        width: double.infinity,
        height: 30,
        child: Expanded(
          child: Text(buttonText,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}