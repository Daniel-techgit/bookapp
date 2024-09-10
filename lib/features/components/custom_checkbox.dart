import 'package:price_app/features/utils/exports.dart';

class CustomCheckboxWidget extends StatefulWidget {
  const CustomCheckboxWidget({super.key});

  @override
  _CustomCheckboxWidgetState createState() => _CustomCheckboxWidgetState();
}

class _CustomCheckboxWidgetState extends State<CustomCheckboxWidget> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: _isChecked,
      onChanged: (newValue) {
        setState(() {
          _isChecked = newValue!;
        });
      },
    );
  }
}