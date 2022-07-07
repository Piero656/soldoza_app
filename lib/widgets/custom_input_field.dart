import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final IconData? icon;
  final IconData? suffixicon;
  final TextInputType? keyboardType;
  final bool obscureText;

  final String formProperty;
  final Map<String, dynamic> formValues;

  const CustomInputField({
    Key? key,
    this.hintText,
    this.labelText,
    this.helperText,
    this.icon,
    this.suffixicon,
    this.keyboardType,
    this.obscureText = false,
    required this.formProperty,
    required this.formValues,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      initialValue: "",
      textCapitalization: TextCapitalization.words,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: (value) {
        formValues[formProperty] = value;
      },
      validator: (value) {
        if (value == null) return 'Este Campo Es Requerido';
        return value.length < 3 ? 'Minino de 3' : null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: Colors.green
        //   )
        // ),
        hintText: hintText,
        labelText: labelText,
        helperText: helperText,
        // counterText: '3 caracteres',
        icon: icon == null ? null : Icon(icon),
        suffixIcon: suffixicon == null ? null : Icon(suffixicon),
        // prefixIcon: Icon(Icons.group_outlined),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(10),
        //     topRight: Radius.circular(10),
        //     )
        // )
      ),
    );
  }
}
