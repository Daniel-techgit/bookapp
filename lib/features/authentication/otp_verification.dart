import 'dart:convert';
import "package:price_app/features/utils/exports.dart";
import 'package:http/http.dart'as http;

class Verification extends StatefulWidget {
  final String email;
  const Verification({super.key, required this.email});
  @override
  _VerificationState createState() => _VerificationState();
}
class _VerificationState extends State<Verification> {
  final List<TextEditingController> _otpControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _isLoading = false;


  Future<void> verifyOTP(String email, String otp) async {
    setState(() => _isLoading = true);
    try {
      final url = Uri.parse('https://bookappbackend-csjm.onrender.com/api/verifyOTP');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewPassword(email: widget.email)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to verify OTP: ${jsonDecode(response.body)['error']}')),
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
              'OTP Verification',
              style: KHeadingTextStyle,
            ),
            Text(
              'Enter the 4-digit verification code we just sent to ${widget.email}',
              style: KSubHeadingTextStyle,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOTPField(0),
                _buildOTPField(1),
                _buildOTPField(2),
                _buildOTPField(3),
              ],
            ),
            const SizedBox(height: 80),
            MyElevatedButton(
              onPressed: () {
                final otp = _otpControllers.map((controller) => controller.text).join();
                verifyOTP(widget.email, otp);
                print(otp);
              },
              buttonText: 'Verify',
            ),
            const Spacer(),
            BottomActionText(
              question: "Did not receive code?",
              action: 'Resend',
              onTap: () {
// Resend OTP here
                sendOTP(widget.email);
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildOTPField(int index) {
    return SizedBox(
      width: 50,
      child: TextFormField(
        controller: _otpControllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 3) {
              FocusScope.of(context).nextFocus();
            } else {
              FocusScope.of(context).unfocus();
            }
          } else {
            if (index > 0) {
              FocusScope.of(context).previousFocus();
            }
          }
        },
      ),
    );
  }
}


