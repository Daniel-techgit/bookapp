String? validateEmail(String? value) {
  // Null check
  if (value == null || value.isEmpty) {
    return 'Please enter an email address';
  }

  // Regular expression pattern for email validation
  String pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$";
  RegExp regex = RegExp(pattern);

  if (!regex.hasMatch(value)) {
    return 'Please enter a valid email address';
  }

  // If the email is valid, return null
  return null;
}

String? registrationPassword(String? value) {
  // Check if the password is empty
  if (value == null || value.isEmpty) {
    return 'Please enter a password';
  }

  // Check if the password has at least 8 characters
  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  }

  // Check if the password contains at least one uppercase letter
  bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
  if (!hasUppercase) {
    return 'Password must contain at least one uppercase letter';
  }

  // Check if the password contains at least one lowercase letter
  bool hasLowercase = value.contains(RegExp(r'[a-z]'));
  if (!hasLowercase) {
    return 'Password must contain at least one lowercase letter';
  }

  // Check if the password contains at least one number
  bool hasNumber = value.contains(RegExp(r'[0-9]'));
  if (!hasNumber) {
    return 'Password must contain at least one number';
  }

  // If all requirements are met, return null
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a password';
  }
  // Add additional password validation rules if needed
  return null;
}


// String? confirmPassword(String? value){
//   if (value==null || value.isEmpty){
//     return 'Please enter a password';
//   }
//   if (value != _passwordController.text) {
//     return 'Passwords do not match';
//   }
//   return null;
// }


