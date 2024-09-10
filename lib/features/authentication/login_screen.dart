import "package:price_app/features/utils/exports.dart";

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _secureStorage = const FlutterSecureStorage();
  bool _isLoading = false;

  Future<void> printStoredToken() async {
    final token = await _secureStorage.read(key: 'token');
    final userId = await _secureStorage.read(key: 'userId');
    print('Stored token: $token');
    print('Stored ID: $userId');
  }

  Future<void> _performLogin(BuildContext context, AuthServiceProvider provider) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await provider.login(provider.emailController.text, provider.passwordController.text);

        if (provider.error == null) {
          await printStoredToken();
          Navigator.pushNamed(context, '/home');
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Login Failed'),
              content: Text(provider.error ?? 'Something went wrong. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthServiceProvider(),
      child: WillPopScope(
        onWillPop: () async {
          // Close the app when back button is pressed
          SystemNavigator.pop();
          return false;
        },
        child: Scaffold(
          //appBar: CustomAppBar,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Consumer<AuthServiceProvider>(
              builder: (context, provider, _) {
                return Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: () async {
                        provider.emailController.clear();
                        provider.passwordController.clear();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(20.0.r),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Welcome back.',
                                style: KHeadingTextStyle,
                              ),
                              Text(
                                'Glad to see you Again!',
                                style: KHeadingTextStyle,
                              ),
                              SizedBox(height: 15.h),
                              TextFormField(
                                autofocus: false,
                                controller: provider.emailController,
                                validator: provider.validateEmail,
                                decoration: buildInputDecoration("Enter Email", Icons.email),
                              ),
                              SizedBox(height: 10.h),
                              TextFormField(
                                autofocus: false,
                                obscureText: true,
                                controller: provider.passwordController,
                                validator: provider.validatePassword,
                                decoration: buildInputDecoration("Enter Password", Icons.lock),
                              ),
                              const ForgotPassword(),
                              SizedBox(height: 80.h),
                              MyElevatedButton(
                                buttonText: 'Login',
                                onPressed: _isLoading ? () {} : () => _performLogin(context, provider),
                              ),
                              const Spacer(),
                              BottomActionText(
                                question: "Don't have an account",
                                action: 'Register Here',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const Registration1()),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_isLoading)
                      Container(
                        color: Colors.black54,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF0B6F17),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}