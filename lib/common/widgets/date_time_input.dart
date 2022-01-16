import 'package:flutter/material.dart';

class DateTimeInput extends StatelessWidget {
  const DateTimeInput({
    Key? key,
    required this.label,
    required this.initialValue,
    required this.iconData,
    this.onPressed,
    this.onSubmitted,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  final String label;
  final String initialValue;
  final IconData iconData;
  final Function()? onPressed;
  final Function(String)? onSubmitted;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      readOnly: true,
      onTap: onPressed,
      onSubmitted: onSubmitted,
      style: const TextStyle(
        fontSize: 20,
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
        prefixIcon: IconButton(
          icon: Icon(iconData),
          color: const Color.fromRGBO(90, 23, 238, 1),
          onPressed: onPressed,
        ),
        hintText: 'dd/MM/yyyy',
      ),
    );
  }
}
