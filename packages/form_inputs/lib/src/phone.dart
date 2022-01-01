import 'package:formz/formz.dart';

enum PhoneValidationError { invalid }

class Phone extends FormzInput<String, PhoneValidationError> {
  const Phone.pure([String value = '']) : super.pure(value);

  const Phone.dirty([String value = '']) : super.dirty(value);

  static final _phoneRegExp = RegExp(
      r'^(([+][(]?[0-9]{1,3}[)]?)|([(]?[0-9]{4}[)]?))\s*[)]?[-\s\.]?[(]?[0-9]{1,3}[)]?([-\s\.]?[0-9]{3})([-\s\.]?[0-9]{3,4})',);

  @override
  PhoneValidationError? validator(String? value) {
    return _phoneRegExp.hasMatch(value ?? '')
        ? null
        : PhoneValidationError.invalid;
  }
}
