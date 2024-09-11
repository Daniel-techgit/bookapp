import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:price_app/features/utils/exports.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerSupportPage extends StatefulWidget {
  const CustomerSupportPage({Key? key}) : super(key: key);

  @override
  _CustomerSupportPageState createState() => _CustomerSupportPageState();
}

class _CustomerSupportPageState extends State<CustomerSupportPage> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isLoading = false;
  bool _emailAppOpened = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _emailAppOpened) {
      _resetForm();
    }
  }

  void _resetForm() {
    setState(() {
      _subjectController.clear();
      _bodyController.clear();
      _emailAppOpened = false;
    });
    _formKey.currentState?.reset();
  }

  Future<void> sendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final String emailBody = "${_bodyController.text}\n\nSent from PriceApp";
    final String emailUrl = 'mailto:adefioyed.nysc2019@gmail.com.com?subject=${Uri.encodeComponent(_subjectController.text)}&body=${Uri.encodeComponent(emailBody)}';

    try {
      if (await canLaunch(emailUrl)) {
        await launch(emailUrl);
        setState(() => _emailAppOpened = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email app opened. Your message will be sent when you hit send in your email app.')),
        );
        _resetForm();
      } else {
        throw 'Could not launch email app';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open email app. Please try again later.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812));

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Customer Support',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp),
          ),
        ),
        backgroundColor: Color(0xFF0B6F17),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/cart_zero'),
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (user != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: Text(
                          'Logged in as: ${user.email}',
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    TextFormField(
                      controller: _subjectController,
                      decoration: InputDecoration(
                        labelText: 'Subject',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a subject';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        TextFormField(
                          controller: _bodyController,
                          decoration: InputDecoration(
                            labelText: 'Message',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 10,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a message';
                            }
                            return null;
                          },
                        ),
                        Positioned(
                          right: 8.w,
                          bottom: 8.h,
                          child: _isLoading
                              ? SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.w,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0B6F17)),
                            ),
                          )
                              : IconButton(
                            icon: Icon(Icons.send, color: Color(0xFF0B6F17)),
                            onPressed: sendEmail,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:price_app/features/utils/exports.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class CustomerSupportPage extends StatefulWidget {
//   const CustomerSupportPage({Key? key}) : super(key: key);
//
//   @override
//   _CustomerSupportPageState createState() => _CustomerSupportPageState();
// }
//
// class _CustomerSupportPageState extends State<CustomerSupportPage> with WidgetsBindingObserver {
//   final _formKey = GlobalKey<FormState>();
//   final _subjectController = TextEditingController();
//   final _bodyController = TextEditingController();
//   bool _isLoading = false;
//   bool _emailAppOpened = false;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _subjectController.dispose();
//     _bodyController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed && _emailAppOpened) {
//       _resetForm();
//     }
//   }
//
//   void _resetForm() {
//     setState(() {
//       _subjectController.clear();
//       _bodyController.clear();
//       _emailAppOpened = false;
//     });
//     _formKey.currentState?.reset();
//   }
//
//   Future<void> sendEmail() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isLoading = true);
//
//     final String emailBody = "${_bodyController.text}\n\nSent from PriceApp";
//     final String emailUrl = 'mailto:adefioyed.nysc2019@gmail.com.com?subject=${Uri.encodeComponent(_subjectController.text)}&body=${Uri.encodeComponent(emailBody)}';
//
//     try {
//       if (await canLaunch(emailUrl)) {
//         await launch(emailUrl);
//         setState(() => _emailAppOpened = true);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Email app opened. Your message will be sent when you hit send in your email app.')),
//         );
//         // Clear the form immediately after opening the email app
//         _resetForm();
//       } else {
//         throw 'Could not launch email app';
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to open email app. Please try again later.')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//           child: Text(
//             'Customer Support',
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//         ),
//         backgroundColor: Color(0xFF0B6F17),
//         automaticallyImplyLeading: false, // This removes the back arrow
//       ),
//       body: Consumer<UserProvider>(
//         builder: (context, userProvider, child) {
//           final user = userProvider.user;
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   if (user != null)
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 16.0),
//                       child: Text(
//                         'Logged in as: ${user.email}',
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   TextFormField(
//                     controller: _subjectController,
//                     decoration: InputDecoration(
//                       labelText: 'Subject',
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter a subject';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 16),
//                   TextFormField(
//                     controller: _bodyController,
//                     decoration: InputDecoration(
//                       labelText: 'Message',
//                       border: OutlineInputBorder(),
//                     ),
//                     maxLines: 10,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter a message';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: _isLoading ? null : sendEmail,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF0B6F17),
//                       foregroundColor: Colors.white,
//                     ),
//                     child: _isLoading
//                         ? CircularProgressIndicator(color: Colors.white)
//                         : Text('Send'),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }








// import "package:price_app/features/utils/exports.dart";
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
//
//
//
// class AIAssistancePage extends StatefulWidget {
//   const AIAssistancePage({super.key});
//
//   @override
//   _AIAssistancePageState createState() => _AIAssistancePageState();
// }
//
// class _AIAssistancePageState extends State<AIAssistancePage> {
//   final TextEditingController _questionController = TextEditingController();
//   String _answer = '';
//   bool _isLoading = false;
//
//   Future<void> _askQuestion() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     // Here you would typically call your AI API
//     // For this example, we'll use a placeholder API
//     try {
//       final response = await http.post(
//         Uri.parse('https://api.openai.com/v1/engines/davinci-codex/completions'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer',
//         },
//         body: jsonEncode({
//           'prompt': _questionController.text,
//           'max_tokens': 100,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           _answer = data['choices'][0]['text'];
//           _isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load answer');
//       }
//     } catch (e) {
//       setState(() {
//         _answer = 'Error: $e';
//         _isLoading = false;
//       });
//     }
//   }
//
//   int _currentIndex = 0;
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SeedApp Assist'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _questionController,
//               decoration: const InputDecoration(
//                 hintText: 'Ask a question...',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _isLoading ? null : _askQuestion,
//               child: const Text('Ask'),
//             ),
//             const SizedBox(height: 16),
//             _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : Text(
//               _answer,
//               style: const TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//      //-----
//     );
//   }
// }

