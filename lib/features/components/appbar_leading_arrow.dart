import "package:flutter/cupertino.dart";
import "package:price_app/features/utils/exports.dart";

class AppBarLeadingArrow extends StatelessWidget {
  const AppBarLeadingArrow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 20.0),
        child: Image.asset('images/back.png'),
      ),);
  }
}
