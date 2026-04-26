class ValidateHelper {
  static bool isValidPhone(String phone) {
    if (phone.isEmpty) return false;
    
    String normalized = normalizePhone(phone);
    
    // Kiểm tra định dạng số điện thoại Việt Nam mới nhất:
    // Bắt đầu bằng 03, 05, 07, 08, 09 và có đúng 10 chữ số
    final regex = RegExp(r'^(03|05|07|08|09)\d{8}$');
    return regex.hasMatch(normalized);
  }

  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    final regex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return regex.hasMatch(email);
  }

  static bool isValidPasswordComplex(String password) {
    if (password.length < 8) return false;
    
    // Check for uppercase, lowercase, digits, and special characters
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    return hasUppercase && hasLowercase && hasDigits && hasSpecialCharacters;
  }

  static bool isValidName(String name) {
    return name.trim().length >= 2;
  }

  static String normalizePhone(String phone) {
    // 1. Xóa tất cả các khoảng trắng, dấu cộng
    String cleanPhone = phone.replaceAll(RegExp(r'[\s+]'), '');
    
    // 2. Nếu bắt đầu bằng 84, chuyển về 0
    if (cleanPhone.startsWith('84')) {
      cleanPhone = '0${cleanPhone.substring(2)}';
    } else if (cleanPhone.length == 9 && RegExp(r'^(3|5|7|8|9)').hasMatch(cleanPhone)) {
      // 3. Nếu người dùng nhập 9 số và bắt đầu bằng đầu số nhà mạng (vd: 812495034)
      cleanPhone = '0$cleanPhone';
    }
    
    return cleanPhone;
  }
}
