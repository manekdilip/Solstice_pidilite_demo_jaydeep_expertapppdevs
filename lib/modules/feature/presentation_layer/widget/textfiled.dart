import 'package:flutter/material.dart';

import '../../../../utils/strings.dart';

final formKey = GlobalKey<FormState>();

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String value) onChanged;
  TextFieldWidget({Key? key,required this.controller,required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Form(
        key: formKey,
        child: TextFormField(
          textAlignVertical: TextAlignVertical.bottom,
          controller: controller,
          onChanged: (value) {
            onChanged(value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return pleaseEnterTermsAndConditions;
            }
            return null;
          },
          maxLines: 10,
          minLines: 2,
          decoration: const InputDecoration(
            isDense: true,
            labelText: enterTermsAndCondition,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffB58392)),
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
          ),
        ),
      ),
    );
  }
}
