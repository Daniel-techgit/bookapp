import "package:price_app/features/utils/exports.dart";

InputDecoration buildInputDecoration(String hintText, IconData icon) {
  return InputDecoration(
    hintText: hintText,
    prefixIcon: Icon(icon),
    border: const OutlineInputBorder(
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: const Color(0xFFEFEAEA),

  );
}