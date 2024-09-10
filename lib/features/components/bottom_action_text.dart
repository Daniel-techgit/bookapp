import "package:price_app/features/utils/exports.dart";

class BottomActionText extends StatelessWidget {

  final String question;
  final String action;
  final VoidCallback onTap;

  const BottomActionText({super.key, required this.question, required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(question),
        SizedBox(width: 5.w),
        GestureDetector(
          onTap: onTap,
          child: Text(action,
              style: KLinkTextstyle
          ),
        )
      ],
    );
  }
}