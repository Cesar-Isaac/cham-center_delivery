import '../repositories/auth_repository.dart';

/// يتحقق من أن البريد ورقم الهاتف غير مستخدمين من حساب سابق.
/// يعيد رسالة الخطأ بالعربية، أو null إذا كانا متاحين.
class CheckAccountAvailabilityUseCase {
  CheckAccountAvailabilityUseCase(this.repository);

  final AuthRepository repository;

  String? call({
    required String email,
    required String phone,
  }) {
    final bool emailTaken =
    repository.isEmailTaken(email);
    final bool phoneTaken =
    repository.isPhoneTaken(phone);

    if (emailTaken && phoneTaken) {
      return 'البريد الإلكتروني ورقم الهاتف مستخدمان من قبل.';
    }

    if (emailTaken) {
      return 'البريد الإلكتروني مستخدم من قبل.';
    }

    if (phoneTaken) {
      return 'رقم الهاتف مستخدم من قبل.';
    }

    return null;
  }
}
