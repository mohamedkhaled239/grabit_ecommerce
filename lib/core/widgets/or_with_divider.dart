import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrWithDivider extends StatelessWidget {
  final String text;

  const OrWithDivider({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: Color(0xff6A707C),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
      ],
    );
  }
}
