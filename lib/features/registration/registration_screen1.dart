import 'package:price_app/features/utils/exports.dart';


class Registration1 extends StatefulWidget {
  const Registration1({super.key});

  @override
  State<Registration1> createState() => _Registration1State();
}

class _Registration1State extends State<Registration1> {
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthServiceProvider(),
      child: Consumer<AuthServiceProvider>(
        builder: (context, authProvider, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,

            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20.r),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Hello! Register to get Started', style: KHeadingTextStyle),
                      SizedBox(height: 15.h),
                      TextFormField(
                        autofocus: false,
                        controller: authProvider.firstNameController,
                        validator: authProvider.validateFirstName,
                        decoration: buildInputDecoration("Enter First Name", Icons.person),
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        autofocus: false,
                        controller: authProvider.lastNameController,
                        validator: authProvider.validateLastName,
                        decoration: buildInputDecoration("Enter Last Name", Icons.person),
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        autofocus: false,
                        controller: authProvider.emailController,
                        validator: authProvider.validateEmail,
                        decoration: buildInputDecoration("Enter Email", Icons.email),
                      ),
                      SizedBox(height: 80.h),
                      MyTextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushNamed(
                              context,
                              '/registration2',
                              arguments: {
                                'firstName': authProvider.firstNameController.text,
                                'lastName': authProvider.lastNameController.text,
                                'email': authProvider.emailController.text,
                                'authProvider': authProvider,
                              },
                            );
                          }
                        },
                        buttonText: 'Continue',
                      ),
                      const Spacer(),
                      BottomActionText(
                        question: 'Already have an account?',
                        action: 'Login',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Login()),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    Provider.of<AuthServiceProvider>(context, listen: false).dispose();
    super.dispose();
  }

}