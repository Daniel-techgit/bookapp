import "dart:convert";
import 'package:http/http.dart'as http;

import "package:price_app/features/utils/exports.dart";

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> sendOTP(String email) async {
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://bookappbackend-csjm.onrender.com/api/forgetPassword'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Verification(email: email)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP: ${jsonDecode(response.body)['error']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar,
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               Text(
                'Forget Password?',
                style: KHeadingTextStyle,
              ),
               Text(
                "Don't worry it occurs. "
                "Please enter the email address used with your account",
                style: KSubHeadingTextStyle,
              ),
               const SizedBox(height: 15),
              TextFormField(
                autofocus: false,
                controller: _emailController,
                validator:validateEmail,
                decoration: buildInputDecoration("Enter Email", Icons.email),
              ),
               const SizedBox(height: 80),
              MyElevatedButton(
                onPressed: (){
                  sendOTP(_emailController.text.trim());
                },
                buttonText: 'Send Code',
              ),
              const Spacer(),
              BottomActionText(
                question: 'Remember Password?',
                action: 'Login',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
