import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:tcc/utils/color_util.dart';

class TextFormFieldUtil {
  Widget build({
    @required String title,
    @required TextEditingController controller,
    @required String error,
    @required bool obscured,
    @required TextInputType inputType,
    String mask,
    int line,
  }) {
    return Container(
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        obscureText: obscured,
        inputFormatters: mask != null ? [MaskTextInputFormatter(mask: mask, filter: { "#": RegExp(r'[0-9]') })] : null,
        minLines: line != null ? line : 1,
        maxLines: line != null ? line + 1 : 1,
        decoration: InputDecoration(
          errorText: error,
          labelText: title,
          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: ColorUtil.colorPrimary)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: ColorUtil.colorPrimary)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: ColorUtil.colorPrimary)),
          focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: ColorUtil.colorPrimary)),
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: TextStyle(
          color: Color(0xff4F4F4F),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}