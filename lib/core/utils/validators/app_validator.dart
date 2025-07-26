class AppValidator {
  AppValidator._();

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    // Check for minimum password length
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
// Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }

// Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }

// Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }
    return null;

  }
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    // Regular expression for phone number validation (assuming a 10-digit US phone number format)
    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (10 digits required).';
    }

    return null;
  }


  static String? validateNumericField(String? value, String fieldName, {double? min, double? max}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }

    // Remove any suffixes (ft, KG, y)
    value = value.replaceAll(RegExp(r'[a-zA-Z]'), '').trim();

    // Check if it's a valid number
    if (!RegExp(r'^[0-9]+\.?[0-9]*$').hasMatch(value)) {
      return '$fieldName must be a valid number.';
    }

    final numValue = double.tryParse(value);
    if (numValue == null) {
      return '$fieldName must be a valid number.';
    }

    if (min != null && numValue < min) {
      return '$fieldName must be at least $min.';
    }

    if (max != null && numValue > max) {
      return '$fieldName must be less than $max.';
    }

    return null;
  }

  static String? validateHeight(String? value) {
    return validateNumericField(value, 'Height', min: 2, max: 9);
  }

  static String? validateWeight(String? value) {
    return validateNumericField(value, 'Weight', min: 20, max: 500);
  }

  static String? validateAge(String? value) {
    return validateNumericField(value, 'Age', min: 13, max: 120);
  }
}
