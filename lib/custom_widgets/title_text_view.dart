import 'package:flutter/material.dart';

class TitleTextView extends StatelessWidget {
  final String? text;
  final TextAlign? textAlign;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final bool? softWrap;
  final int? maxLines;
  final bool isStrikeText;
  final TextOverflow? overflow;
  final double? lineHeight;
  final bool? isUnderline;

  const TitleTextView(this.text,
      {Key? key,
      this.textAlign = TextAlign.left,
      this.fontWeight,
      this.fontSize,
      this.maxLines,
      this.isStrikeText = false,
      this.overflow,
      this.lineHeight,
      this.isUnderline,
      this.color,
      this.softWrap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '-',
      textAlign: textAlign,
      overflow: (overflow == null) ? TextOverflow.clip : overflow,
      softWrap: softWrap,
      maxLines: maxLines,
      textScaleFactor: 1.0,
      style: TextStyle(
          height: lineHeight ?? 1.2,
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          decoration: (isUnderline != null && isUnderline!)
              ? TextDecoration.underline
              : (isStrikeText)
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
    );
  }
}
