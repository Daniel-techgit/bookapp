import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:price_app/features/utils/exports.dart';

class CustomerSupportPage extends StatefulWidget {
  const CustomerSupportPage({Key? key}) : super(key: key);

  @override
  _CustomerSupportPageState createState() => _CustomerSupportPageState();
}

class _CustomerSupportPageState extends State<CustomerSupportPage> {
  final TextEditingController _questionController = TextEditingController();
  String _answer = '';
  bool _isLoading = false;

  Future<void> _askQuestion() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/engines/davinci-codex/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_API_KEY_HERE', // Replace with your actual API key
        },
        body: jsonEncode({
          'prompt': _questionController.text,
          'max_tokens': 100,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _answer = data['choices'][0]['text'];
        });
      } else {
        throw Exception('Failed to load answer');
      }
    } catch (e) {
      setState(() {
        _answer = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendEmail() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'adefisoyed@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Customer Support Inquiry',
        'body': _questionController.text,
      }),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch email client')),
      );
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Support'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _questionController,
                  decoration: const InputDecoration(
                    hintText: 'Type your question or complaint...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _askQuestion,
                        child: const Text('Ask AI'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _sendEmail,
                        child: const Text('Send to Support'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Text(
                  _answer,
                  style: const TextStyle(fontSize: 16),
                ),
                if (user != null) ...[
                  const SizedBox(height: 16),
                  Text('Logged in as: ${user.email}'),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}










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

