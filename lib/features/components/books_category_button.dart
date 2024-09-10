// import 'package:flutter/material.dart';
//
//
// class BooksCategoryButton extends StatelessWidget {
//
//   final String activeCategory;
//   final Function(String) onCategorySelected;
//   BooksCategoryButton({
//     required this.activeCategory,
//     required this.onCategorySelected
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _buildCategoryButton("Study", activeCategory=="Study", "Study"),
//         _buildCategoryButton("Marriage", activeCategory=="Marriage", "Marriage"),
//         _buildCategoryButton("Outreach", activeCategory=="Outreach", "Outreach"),
//         _buildCategoryButton("All", activeCategory=="All", "All"),
//       ],
//     );
//   }
//
//
// Widget _buildCategoryButton(String category, bool isActive, String buttonText) {
//   return TextButton(
//     onPressed: () {
//       onCategorySelected(category);
//     },
//     child: isActive
//         ? Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.blue, // Change color as needed
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: Text(
//         buttonText,
//         style: TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//           color: Colors.white,
//         ),
//       ),
//     )
//         : Text(
//       buttonText,
//       style: TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w500,
//         color: Colors.black,
//       ),
//     ),
//   );
// }
// }