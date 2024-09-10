import "package:price_app/features/utils/exports.dart";

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Close the app when back button is pressed
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5, // Half of the screen height
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/welcome Screen.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3), // Adjust the spacing as needed
                Image.asset(
                  'images/logo-text.png',
                  height: 100.h,
                ),
                SizedBox(height: 40.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: MyElevatedButton(
                      buttonText: 'Login',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: MyElevatedButton(
                      buttonText: 'Register',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Registration1()),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyElevatedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const MyElevatedButton({super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          //padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          backgroundColor: const Color(0xFF0B6F17),
          foregroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}






// import "package:price_app/features/utils/exports.dart";
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height * 0.5, // Half of the screen height
//             width: double.infinity,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('images/welcome Screen.png'),
//                 fit: BoxFit.cover,
//                 alignment: Alignment.topCenter,
//               ),
//             ),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               SizedBox(height: MediaQuery.of(context).size.height * 0.3), // Adjust the spacing as needed
//               Image.asset(
//                 'images/logo-text.png',
//                 height: 100.h,
//               ),
//               SizedBox(height: 40.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: MyTextButton(
//                     buttonText: 'Login',
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => Login()),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: MyTextButton(
//                     buttonText: 'Register',
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => Registration1()),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               SizedBox(height: 40.h),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }



// import "package:price_app/features/utils/exports.dart";
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height,
//             width: double.infinity,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('images/welcome Screen.png'),
//                 fit: BoxFit.cover,
//                 alignment: Alignment.topCenter,
//               ),
//             ),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Spacer(),
//               Image.asset(
//                 'images/logo-text.png',
//                 height: 100.h,
//               ),
//               SizedBox(height: 40.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       backgroundColor: const Color(0xFF0D5415),
//                       foregroundColor: Colors.white,
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => Login()),
//                       );
//                     },
//                     child: Text(
//                       'Login',
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       backgroundColor: const Color(0xFF0D5415),
//                       foregroundColor: Colors.white,
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => Registration1()),
//                       );
//                     },
//                     child: Text(
//                       'Register',
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Spacer(),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }




// class WelcomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('images/welcome_screen.png'),
//                 fit: BoxFit.cover,
//                 alignment: Alignment.topCenter,
//               ),
//             ),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Spacer(),
//               Image.asset(
//                 'images/logo-text.png',
//                 height: 100.h,
//               ),
//               SizedBox(height: 40.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: MyTextButton(
//                     buttonText: 'Login',
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => Login()),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 30.w),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: MyTextButton(
//                     buttonText: 'Register',
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => Registration1()),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               SizedBox(height: 40.h),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }




















// class WelcomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Scaffold(
//             body: Container(
//             alignment: Alignment.topLeft,
//             width: double.infinity,
//             decoration: BoxDecoration(
//             image: DecorationImage(
//             image: AssetImage('images/welcome Screen.png'),
//               fit: BoxFit.fitWidth,
//               alignment: Alignment.topCenter
//               )
//               ),
//               child:Padding(
//                 padding: const EdgeInsets.only(top: 80.0, right: 30, left: 30, bottom: 15),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height*0.5,
//                     ),
//                     Image(
//                       image: AssetImage('images/logo-text.png'),
//                       height: 100,
//                     ),
//                     SizedBox(
//                       height: 80,
//                     ),
//                     MyTextButton(buttonText: 'Login', onPressed: () { Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => Login()),
//                     ); },),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     MyTextButton(buttonText: 'Register', onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute
//                           (builder: (context) => Registration1()),
//                       );
//                     },),
//                   ],),
//               ),
//           )
//             ),
//     );
//   }
// }

