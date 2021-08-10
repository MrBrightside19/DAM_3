import 'package:flutter/material.dart';

class TextNotasField extends StatelessWidget {
  final TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () => controller.selection = TextSelection(
          baseOffset: 0, extentOffset: controller.value.text.length),
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: 3,
      decoration: InputDecoration(hintText: 'Ingrese Nota'),
    );
  }
}

class TextPondField extends StatelessWidget {
  final TextEditingController controller = new TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Ingrese ponderación';
        }
        return null;
      },
      onTap: () => controller.selection = TextSelection(
          baseOffset: 0, extentOffset: controller.value.text.length),
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: 3,
      decoration: InputDecoration(hintText: 'Ingrese Ponderación'),
    );
  }
}
