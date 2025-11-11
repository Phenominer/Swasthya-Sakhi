import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? color;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.padding,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            backgroundColor: color ?? theme.primaryColor.withOpacity(0.1),
            side: BorderSide(
              color: color ?? theme.primaryColor,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding,
          )
        : ElevatedButton.styleFrom(
            backgroundColor: color ?? theme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding,
          );

    final buttonChild = DefaultTextStyle.merge(
      style: TextStyle(
        color: isOutlined
            ? (color ?? theme.primaryColor)
            : Colors.white,
        fontWeight: FontWeight.w600,
      ),
      child: child,
    );

    return SizedBox(
      width: width,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: buttonStyle,
              child: buttonChild,
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: buttonStyle,
              child: buttonChild,
            ),
    );
  }
}
