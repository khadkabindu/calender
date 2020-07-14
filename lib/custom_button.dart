import 'package:flutter/material.dart';
const PrimaryColorTextHintLight = Color(0xdddedddc);
class CustomButton extends StatelessWidget {
  const CustomButton({
    Key key,
    this.color,
    this.child,
    this.textColor: Colors.white,
    this.onPressed,
    this.disabled: false,
    this.disabledColor: PrimaryColorTextHintLight,
    this.label: '',
    this.fontSize: 14,
    this.padding: const EdgeInsets.symmetric(horizontal: 80),
  }) : super(key: key);

  final VoidCallback onPressed;
  final Color color;
  final Color disabledColor;
  final Color textColor;
  final String label;
  final bool disabled;
  final EdgeInsets padding;
  final double fontSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      onPressed: disabled ? null : onPressed,
      child: child ?? Text(
        label,
        style: new TextStyle(color: textColor, fontSize: fontSize),
      ),
      padding: padding,
      color: color,
      disabledColor: disabledColor,
    );
  }
}