import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Function(String)? onChange;
  final IconData? prefixIcon;
  final Color? fillColor;
  final String? Function(String?)? validator;
  final double? borderRadius;
  final Color? borderColor;
  final Color? focusedBorderColor;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.onChange,
    this.validator,
    this.fillColor = const Color.fromARGB(255, 255, 255, 255),
    this.borderRadius = 5.0,
    this.borderColor,
    this.focusedBorderColor,
    this.prefixIcon,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isPasswordVisible;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: TextFormField(
          controller: widget.controller,
          validator: (value) {
            // First run the custom validator if provided
            if (widget.validator != null) {
              final customValidation = widget.validator!(value);
              if (customValidation != null) {
                return customValidation;
              }
            }

            // Then run the default validator
            if (value == null || value.isEmpty) {
              return '${widget.hintText} cannot be empty';
            }
            return null;
          },
          obscureText: _isPasswordVisible,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            filled: true,
            fillColor: widget.fillColor,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18.0,
              horizontal: 16.0,
            ),
            prefixIcon:
                widget.prefixIcon != null
                    ? Icon(
                      widget.prefixIcon,
                      color:
                          _isFocused
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade500,
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(
                color:
                    widget.borderColor ??
                    const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(
                color:
                    widget.focusedBorderColor ?? Theme.of(context).primaryColor,
                width: 1,
              ),
            ),
            suffixIcon:
                widget.obscureText
                    ? IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey.shade500,
                      ),
                      onPressed: _togglePasswordVisibility,
                      splashRadius: 20,
                    )
                    : null,
          ),
          style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
          onChanged: widget.onChange,
        ),
      ),
    );
  }
}
