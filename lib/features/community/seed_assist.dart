// import 'package:price_app/features/utils/exports.dart';
//
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
//   bool _isExpanded = false;
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
//   void _resetForm() {
//     setState(() {
//       _subjectController.clear();
//       _bodyController.clear();
//     });
//     _formKey.currentState?.reset();
//   }
//
//   Future<void> sendEmail() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isLoading = true);
//
//     final Email email = Email(
//       body: "${_bodyController.text}\n\nSent from PriceApp",
//       subject: _subjectController.text,
//       recipients: ['adefioyed.nysc2019@gmail.com'],
//       isHTML: false,
//     );
//
//     try {
//       print("Attempting to send email...");
//       await FlutterEmailSender.send(email);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Email sent successfully')),
//       );
//       _resetForm();
//     } catch (error) {
//       print("Error sending email: $error");
//       print("Error type: ${error.runtimeType}");
//       if (error is PlatformException) {
//         print("PlatformException details: ${error.message}, ${error.code}, ${error.details}");
//       }
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to send email. $error')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> launchWhatsApp() async {
//     const whatsappUrl = "https://wa.me/+2349021408330"; // Replace with your WhatsApp number
//     if (await canLaunch(whatsappUrl)) {
//       await launch(whatsappUrl);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not launch WhatsApp')),
//       );
//     }
//   }
//
//   Future<void> launchTelegram() async {
//     const telegramUrl = "https://t.me/danieladefisoye"; // Replace with your Telegram username
//     if (await canLaunch(telegramUrl)) {
//       await launch(telegramUrl);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not launch Telegram')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context, designSize: Size(375, 812));
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//           child: Text(
//             'Customer Support',
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp),
//           ),
//         ),
//         backgroundColor: Color(0xFF0B6F17),
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.shopping_cart, color: Colors.white),
//             onPressed: () => Navigator.pushNamed(context, '/cart_zero'),
//           ),
//         ],
//       ),
//       body: Consumer<UserProvider>(
//         builder: (context, userProvider, child) {
//           final user = userProvider.user;
//           return SafeArea(
//             child: GestureDetector(
//               onTap: () => FocusScope.of(context).unfocus(),
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: EdgeInsets.only(
//                     left: 16.w,
//                     right: 16.w,
//                     top: 16.h,
//                     bottom: 16.h + MediaQuery.of(context).viewInsets.bottom,
//                   ),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         if (user != null)
//                           Padding(
//                             padding: EdgeInsets.only(bottom: 16.h),
//                             child: Text(
//                               'Logged in as: ${user.email}',
//                               style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         TextFormField(
//                           controller: _subjectController,
//                           decoration: InputDecoration(
//                             labelText: 'Subject',
//                             border: OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter a subject';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 16.h),
//                         TextFormField(
//                           controller: _bodyController,
//                           decoration: InputDecoration(
//                             labelText: 'Message',
//                             border: OutlineInputBorder(),
//                           ),
//                           maxLines: null,
//                           minLines: 5,
//                           keyboardType: TextInputType.multiline,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter a message';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 16.h),
//                         ElevatedButton(
//                           child: Text('Send Email', style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),),
//                           onPressed: _isLoading ? null : sendEmail,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xFF0B6F17),
//                             padding: EdgeInsets.symmetric(vertical: 12.h),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           if (_isExpanded) ...[
//             FloatingActionButton(
//               heroTag: 'whatsapp',
//               onPressed: launchWhatsApp,
//               child: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white,),
//               backgroundColor: Colors.green,
//             ),
//             SizedBox(height: 10.h),
//             FloatingActionButton(
//               heroTag: 'telegram',
//               onPressed: launchTelegram,
//               child: FaIcon(FontAwesomeIcons.telegram, color: Colors.white),
//               backgroundColor: Colors.blue,
//             ),
//             SizedBox(height: 10.h),
//           ],
//           FloatingActionButton(
//             heroTag: 'expand',
//             onPressed: () {
//               setState(() {
//                 _isExpanded = !_isExpanded;
//               });
//             },
//             child: Icon(_isExpanded ? Icons.close : Icons.message, color: Colors.white),
//             backgroundColor: Color(0xFF0B6F17),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:price_app/features/utils/exports.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
  bool _isExpanded = false;

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


  Future<void> sendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final Email email = Email(
      body: "${_bodyController.text}\n\nSent from PriceApp",
      subject: _subjectController.text,
      recipients: ['adefioyed.nysc2019@gmail.com'],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email sent succefully')),
        );
    } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open email client. Please try again later.')),
        );

    } finally {
        setState(() => _isLoading = false);
        _subjectController.clear();
        _bodyController.clear();
    }
  }


  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<void> launchWhatsApp() async {
    const whatsappUrl = "https://wa.me/+2349021408330"; // Replace with your WhatsApp number
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  }

  Future<void> launchTelegram() async {
    const telegramUrl = "https://t.me/danieladefisoye"; // Replace with your Telegram username
    if (await canLaunch(telegramUrl)) {
      await launch(telegramUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch Telegram')),
      );
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
          return SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    top: 16.h,
                    bottom: 16.h + MediaQuery.of(context).viewInsets.bottom,
                  ),
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
                        TextFormField(
                          controller: _bodyController,
                          decoration: InputDecoration(
                            labelText: 'Message',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: null,
                          minLines: 5,
                          keyboardType: TextInputType.multiline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a message';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          child: Text('Send Email', style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),),
                          onPressed: _isLoading ? null : sendEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0B6F17),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_isExpanded) ...[
            FloatingActionButton(
              heroTag: 'whatsapp',
              onPressed: launchWhatsApp,
              child: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white,),
              backgroundColor: Colors.green,
            ),
            SizedBox(height: 10.h),
            FloatingActionButton(
              heroTag: 'telegram',
              onPressed: launchTelegram,
              child: FaIcon(FontAwesomeIcons.telegram, color: Colors.white),
              backgroundColor: Colors.blue,
            ),
            SizedBox(height: 10.h),
          ],
          FloatingActionButton(
            heroTag: 'expand',
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Icon(_isExpanded ? Icons.close : Icons.message, color: Colors.white),
            backgroundColor: Color(0xFF0B6F17),
          ),
        ],
      ),
    );
  }
}