import 'dart:math';

class PasswordGenerator {
  static const String lowercaseChars = 'abcdefghijklmnopqrstuvwxyz';
  static const String uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String numberChars = '0123456789';
  static const String symbolChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

  static String generate({
    int length = 16,
    bool includeLowercase = true,
    bool includeUppercase = true,
    bool includeNumbers = true,
    bool includeSymbols = true,
  }) {
    if (length < 4) length = 4;
    String allowed = '';
    final Random random = Random.secure();
    final List<String> requiredChars = [];

    if (includeLowercase) {
      allowed += lowercaseChars;
      requiredChars.add(lowercaseChars[random.nextInt(lowercaseChars.length)]);
    }
    if (includeUppercase) {
      allowed += uppercaseChars;
      requiredChars.add(uppercaseChars[random.nextInt(uppercaseChars.length)]);
    }
    if (includeNumbers) {
      allowed += numberChars;
      requiredChars.add(numberChars[random.nextInt(numberChars.length)]);
    }
    if (includeSymbols) {
      allowed += symbolChars;
      requiredChars.add(symbolChars[random.nextInt(symbolChars.length)]);
    }

    if (allowed.isEmpty) {
      allowed = lowercaseChars + numberChars;
    }

    List<String> password = List.from(requiredChars);

    while (password.length < length) {
      password.add(allowed[random.nextInt(allowed.length)]);
    }

    password.shuffle(random);
    return password.join('');
  }
}
