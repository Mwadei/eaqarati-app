class Validator {
  static final List<String> allowedDomains = [
    'gmail.com',
    'hotmail.com',
    'outlook.com',
    'yahoo.com',
    'icloud.com',
    'windowslive.com',
    'mail.com',
    // You can add more domains if needed
  ];


  static bool validateEmail(String email) {
    if (email.isEmpty) return false;
    if (!email.contains('@')) return false;

    var parts = email.split('@');
    if (parts.length != 2) return false;

    var localPart = parts[0];
    var domainPart = parts[1];

    if (localPart.isEmpty || domainPart.isEmpty) return false;
    if (!domainPart.contains('.')) return false;

    // Extra checks if you want
    if (domainPart.startsWith('.') || domainPart.endsWith('.')) return false;

    // ✅ Check if domain is in allowed list
    if (!allowedDomains.contains(domainPart.toLowerCase())) {
      return false;
    }

    // ✅ Check if it ends with '.com'
    if (!domainPart.toLowerCase().endsWith('.com')) {
      return false;
    }

    return true;
  }

  static bool validatePassword(String password) {
    if (password.length < 8) return false;

    bool hasUppercase = false;
    bool hasLowercase = false;
    bool hasDigit = false;
    bool hasSpecialChar = false;
    const specialChars = r'!@#$&*~%^()-_=+{}[]:;"''<>,.?/\\|';

    for (var char in password.runes) {
      var ch = String.fromCharCode(char);

      if (RegExp(r'[A-Z]').hasMatch(ch)) {
        hasUppercase = true;
      } else if (RegExp(r'[a-z]').hasMatch(ch)) {
        hasLowercase = true;
      } else if (RegExp(r'\d').hasMatch(ch)) {
        hasDigit = true;
      } else if (specialChars.contains(ch)) {
        hasSpecialChar = true;
      }
    }

    return hasUppercase && hasLowercase && hasDigit && hasSpecialChar;
  }

  
}
