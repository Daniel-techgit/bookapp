import 'package:price_app/features/utils/exports.dart';

class AuthServiceProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  dynamic _data;
  dynamic get data => _data;

  String? _error;
  String? get error => _error;

  final _secureStorage = const FlutterSecureStorage();



  // Fields for login

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //field for registration

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();


  //validation methods for login

  String? validateFirstName(String? value){
    if (value == null || value.isEmpty){
      return "Please enter your first name";
    }
    return null;
  }

  String? validateLastName(String? value){
    if (value == null || value.isEmpty){
      return "Please enter your first name";
    }
    return null;
  }

  String? validateEmail(String? value){
    if (value == null || value.isEmpty){
      return "Please enter your first name";
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty ) {
      return 'Please enter your phone number';
    }
    if (value.length < 10 || value.length > 15) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  bool validateSecondScreenFields() {
    bool isValid = true;
    if (validatePhoneNumber(phoneNumberController.text) != null) isValid = false;
    if (validatePassword(passwordController.text) != null) isValid = false;
    if (validateConfirmPassword(confirmPasswordController.text) != null) isValid = false;
    return isValid;
  }


  Future<void> register(String firstName, String lastName, String email, String password, String phoneNumber) async {
    _isLoading = true;
    notifyListeners();

    final response = await _authService.registerUser(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );
    _isLoading = false;

    if (response['status'] == 'success') {
      _data = response['data'];
      _error = null;
    } else {
      _error = response['message'];
      _data = {'statusCode': response['statusCode']};
    }

    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    _data = null;
    notifyListeners();

    final response = await _authService.login(email: email, password: password);
    print('Login response: $response');
    _isLoading = false;

    if (response['status'] == 'success') {
      _data = response['data'];
      final token = _data['data']['token'];
      final userId = _data['data']['userId'];
      print('Token: $token'); // Debug print
      print('UserId: $userId');
      await _secureStorage.write(key: 'token', value: token);
      await _secureStorage.write(key: 'userId', value: userId);
      // Verify immediately after writing
      final storedToken = await _secureStorage.read(key: 'token');
      final storedUserId = await _secureStorage.read(key: 'userId');
      print('Stored Token: $storedToken'); // Debug print
      print('Stored UserId: $storedUserId');
    } else {
      _error = response['message'];
      _data = null;
    }

    notifyListeners();
  }


  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}