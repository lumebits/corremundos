import 'package:corremundos/common/constants.dart';
import 'package:flutter/material.dart';

class DateTimeInput extends StatelessWidget {
  const DateTimeInput({
    Key? key,
    required this.label,
    required this.initialValue,
    required this.iconData,
    this.onPressed,
    this.onSubmitted,
  }) : super(key: key);

  final String label;
  final String initialValue;
  final IconData iconData;
  final Function()? onPressed;
  final Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      readOnly: true,
      onTap: onPressed,
      onSubmitted: onSubmitted,
      style: Constants.textFieldStyle,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        labelStyle: Constants.textFieldLabelStyle,
        labelText: label,
        prefix: const Padding(
          padding: EdgeInsets.only(top: 2.5, right: 2.5),
        ),
        prefixIcon: IconButton(
          icon: Icon(iconData),
          color: Constants.corremundosColor,
          onPressed: onPressed,
        ),
        hintText: 'dd/MM/yyyy',
      ),
    );
  }
}
