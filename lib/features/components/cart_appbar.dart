import 'package:price_app/features/utils/exports.dart';


class CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String customTitle;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  const CartAppBar({super.key,  required this.customTitle,});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 20.0),
          child: Image.asset('images/back.png'),
        ),),
      title: Text(customTitle),
      centerTitle: true,
    );
  }
}

