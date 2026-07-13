abstract final class Validators {
  static String? requiredField(
      String? value, {
        String fieldName = 'This field',
      }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  static String? fullName(String? value) {
    final requiredError = requiredField(
      value,
      fieldName: 'Full name',
    );

    if (requiredError != null) return requiredError;

    if (value!.trim().length < 3) {
      return 'Full name must contain at least 3 characters';
    }

    return null;
  }

  static String? email(String? value) {
    final requiredError = requiredField(
      value,
      fieldName: 'Email',
    );

    if (requiredError != null) return requiredError;

    final emailRegex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );

    if (!emailRegex.hasMatch(value!.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? phone(String? value) {
    final requiredError = requiredField(
      value,
      fieldName: 'Phone number',
    );

    if (requiredError != null) return requiredError;

    final normalizedPhone = value!.replaceAll(
      RegExp(r'[\s\-()]'),
      '',
    );

    final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');

    if (!phoneRegex.hasMatch(normalizedPhone)) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  static String? password(String? value) {
    final requiredError = requiredField(
      value,
      fieldName: 'Password',
    );

    if (requiredError != null) return requiredError;

    if (value!.length < 8) {
      return 'Password must contain at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain an uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain a lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain a number';
    }

    return null;
  }

  static String? confirmPassword(
      String? value,
      String password,
      ) {
    final requiredError = requiredField(
      value,
      fieldName: 'Confirm password',
    );

    if (requiredError != null) return requiredError;

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }
}