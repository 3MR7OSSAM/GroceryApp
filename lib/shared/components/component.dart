import 'package:flutter/material.dart';

import '../style/colors.dart';

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false,
    );

Widget defaultButton({
  double width = double.infinity,
  Color backgound = defColor,
  bool isUpperCase = true,
  double raduis = 0.0,
  double height = 40.0,
  required String text,
  required Function() function,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(raduis), color: backgound),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

Widget defauldTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  ValueChanged<String>? onSubmit,
  ValueChanged<String>? onChange,
  GestureTapCallback? onTap,
  bool isPassword = false,
  required FormFieldValidator<String>? validator,
  required String label,
  required IconData prefix,
  IconData? suffix,
  VoidCallback? suffixPressed,
  bool isClickable = true,
  int? lines,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      maxLines: lines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                ))
            : null,
        border: const OutlineInputBorder(),
      ),
    );

Widget defaultSizedBox() => const SizedBox(
      height: 30,
    );

 showDialogAlert(
{String? title,String? fOption , Function? fOptionFun, String? sOption, Function? sOptionFun}) {
  return AlertDialog(
    title: Text(title!),
    actions: [
      TextButton(
          onPressed:(){
           fOptionFun;
           } ,
          child: Text(fOption!)),
      TextButton(
          onPressed: () {
            sOptionFun;
          },
          child: Text(sOption!)),
    ],
  );
}
