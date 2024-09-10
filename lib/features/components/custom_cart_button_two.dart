import "package:price_app/features/utils/exports.dart";

class CustomCartButtonTwoA extends StatelessWidget {
  final String child;
  final VoidCallback onPressed;

  const CustomCartButtonTwoA({super.key, required this.child, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xFF0D5415),
          border: Border.all(
            color: const Color(0xFF0D5415),
            width: 1,
          )
        ),
        width: double.infinity,
        child: Expanded(
          child: Text(child,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),),
        ),
      ),
    );
  }
}


class CustomCartButtonTwoB extends StatelessWidget {
  final String child;
  final VoidCallback onPressed;

  const CustomCartButtonTwoB({super.key, required this.child, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            border: Border.all(
              color: const Color(0xFF0D5415),
              width: 1,
            )
        ),
        width: double.infinity,
        child: Expanded(
          child: Text(child,
            style: const TextStyle(
                color: Color(0xFF0D5415),
                fontSize: 15,
                fontWeight: FontWeight.bold
            ),),
        ),
      ),
    );
  }
}