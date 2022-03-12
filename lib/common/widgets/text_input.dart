import 'package:corremundos/common/constants.dart';
import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    Key? key,
    required this.label,
    required this.initialValue,
    required this.iconData,
    this.onChanged,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  final String label;
  final String initialValue;
  final IconData iconData;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: TextEditingController(text: initialValue),
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: Constants.textFieldFontSize,
        color: Color.fromRGBO(90, 23, 238, 1),
      ),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelStyle: const TextStyle(
          color: Colors.grey,
        ),
        labelText: label,
        prefix: const Padding(
          padding: EdgeInsets.only(top: 2.5, right: 2.5),
        ),
        prefixIcon: Icon(
          iconData,
          color: Constants.corremundosColor,
        ),
        errorStyle: const TextStyle(
          color: Constants.corremundosColor,
          height: 0.1,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '    Please enter some text';
        }
        return null;
      },
    );
  }
}
