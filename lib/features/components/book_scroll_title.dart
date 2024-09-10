import 'package:price_app/features/utils/exports.dart';

class BookScrollTitle extends StatelessWidget {
  final String mainTitle;
  final String subAction;
  const BookScrollTitle({super.key, 
    required this.mainTitle, required this.subAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(mainTitle,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Colors.black
          ),),
        Text(subAction,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            fontStyle: FontStyle.italic,
          ),)
      ],
    );
  }
}
