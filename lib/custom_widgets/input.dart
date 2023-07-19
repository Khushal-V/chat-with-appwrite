import 'package:flutter/material.dart';
import 'package:my_chat/custom_widgets/title_text_view.dart';
import 'package:my_chat/utils/extensions.dart';

class Input extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? title;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final InputBorder? inputBorder;
  final int maxLine;
  final bool enabled;
  final Iterable<String>? autofillHints;
  final TextInputType? keyboardType;
  const Input(
      {super.key,
      required this.controller,
      this.hintText,
      this.title,
      this.obscureText = false,
      this.suffixIcon,
      this.prefixIcon,
      this.maxLine = 1,
      this.inputBorder,
      this.enabled = true,
      this.keyboardType,
      this.autofillHints = const <String>[]});

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          TitleTextView(
            widget.title,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          2.hSizedBox,
        ],
        TextField(
          controller: widget.controller,
          maxLines: widget.maxLine,
          enabled: widget.enabled,
          autofillHints: widget.autofillHints,
          minLines: 1,
          obscureText: obscureText,
          cursorColor: Theme.of(context).primaryColor,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
            hintText: widget.hintText,
            border: widget.inputBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
            enabledBorder: widget.inputBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
            disabledBorder: widget.inputBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
            focusedBorder: widget.inputBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
            suffixIcon: (widget.obscureText)
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    child: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Theme.of(context).primaryColor),
                  )
                : widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
          ),
        ),
      ],
    );
  }
}
