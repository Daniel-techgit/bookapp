import 'package:price_app/features/utils/exports.dart';

class Registration2 extends StatefulWidget {
  const Registration2({super.key});

  @override
  State<Registration2> createState() => _Registration2State();
}

class _Registration2State extends State<Registration2> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute
        .of(context)!
        .settings
        .arguments as Map<String, dynamic>;
    final firstName = arguments['firstName'] as String;
    final lastName = arguments['lastName'] as String;
    final email = arguments['email'] as String;
    final authProvider = arguments['authProvider'] as AuthServiceProvider;

    // Ensure the AuthServiceProvider has these values
    authProvider.firstNameController.text = firstName;
    authProvider.lastNameController.text = lastName;
    authProvider.emailController.text = email;


    return authProvider != null
        ? Consumer<AuthServiceProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(),

              resizeToAvoidBottomInset: false,

                body: SafeArea(
                  child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20.r),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Enter your phone number and password",
                                style: KHeadingTextStyle),
                            TextFormField(
                              autofocus: false,
                              controller: provider.phoneNumberController,
                              onChanged: (value) {
                                print("Phone number changed to: $value");
                              },
                              validator: provider.validatePhoneNumber,
                              decoration: buildInputDecoration(
                                  "Phone Number(+234)", Icons.phone_android),
                            ),
                            SizedBox(height: 15.h),
                            TextFormField(
                              autofocus: false,
                              controller: provider.passwordController,
                              onChanged: (value) {
                                print("Password changed to: $value");
                              },
                              obscureText: true,
                              validator: provider.validatePassword,
                              decoration: buildInputDecoration(
                                  "Enter Password", Icons.lock),
                            ),
                            SizedBox(height: 10.h),
                            TextFormField(
                              autofocus: false,
                              controller: provider.confirmPasswordController,
                              obscureText: true,
                              validator: provider.validateConfirmPassword,
                              decoration: buildInputDecoration(
                                  "Confirm Password", Icons.lock),
                            ),
                            SizedBox(height: 80.h),
                            MyTextButton(
                              buttonText: 'Register',
                              onPressed: () async {
                                if (_formKey.currentState!.validate() &&
                                    provider.validateSecondScreenFields()) {
                                  setState(() => _isLoading = true);
                                  try {
                                    await authProvider.register(
                                      firstName,
                                      lastName,
                                      email,
                                      provider.passwordController.text,
                                      provider.phoneNumberController.text,
                                    );
                  
                  
                                    if (authProvider.data != null &&
                                        authProvider.data['statusCode'] != 400) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text(
                                            'Registration successful. Please log in.')),
                                      );
                                      // Registration successful, navigate to login page
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Login()),
                                      );
                                      // Show a success message
                                    } else if (authProvider.data != null &&
                                        authProvider.data['statusCode'] == 400) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'User already exists. Please login.')),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(
                                            authProvider.error ??
                                                'Registration failed. Please try again.')),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text(
                                          'Network error. Please check your connection and try again.')),
                                    );
                                  } finally {
                                    setState(() => _isLoading = false);
                                  }
                                }
                              },
                            ),
                            const Spacer(),
                            BottomActionText(
                              question: 'Already have an account?',
                              action: 'Login',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isLoading || authProvider.isLoading)
                      Container(
                        color: Colors.black54,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                                ),
                )
          );
        }
    ) : Scaffold(
      appBar: CustomAppBar,
      body: const Center(
        child: Text('Error: AuthServiceProvider not provided'),
      ),
    );
  }


  @override
  void dispose() {
    Provider.of<AuthServiceProvider>(context, listen: false).dispose();
    super.dispose();
  }
}