// Big thanks for "psking" on StackOverflow for thie bases of this class
// https://stackoverflow.com/questions/59770757/not-possible-to-extend-textfield-in-flutter/59773962#59773962
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DescriptionEditorController extends TextEditingController {
  final List<DescriptionEditorKeyword> mapping;
  final Pattern pattern;

  DescriptionEditorController(this.mapping, {required super.text})
      : pattern = RegExp(
            mapping.map((keywordObj) => keywordObj.pattern).join('|'),
            caseSensitive: true,
            multiLine: false,
            unicode: true);

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    List<InlineSpan> children = [];
    // splitMapJoin is a bit tricky here but i found it very handy for populating children list
    text.splitMapJoin(
      pattern,
      onMatch: (Match match) {
        TextStyle curStyle = const TextStyle();
        DescriptionEditorKeyword? curRule;
        TextSpan output = TextSpan();
        TapGestureRecognizer tapGestureRecognizer = TapGestureRecognizer();

        curRule = mapping
            .where((element) => element.prefix == match[0]!.substring(0, 1))
            .firstOrNull;
        curRule ??= mapping
            .where((element) =>
                element.keyCharacter != "" &&
                match[0]!.contains(element.keyCharacter))
            .firstOrNull;

        if (curRule != null) {
          curStyle = curRule.textStyle;
          if (curRule.onTap != null) {
            tapGestureRecognizer.onTap = () => curRule!.onTap!();
          }
          if (curRule.onLongTap != null) {
            tapGestureRecognizer.onTapDown = (tapDownDetails) {
              curRule!.onLongTap!();
            };
          }
        }

        output = TextSpan(
            text: match[0],
            style: style!.merge(curStyle),
            recognizer: tapGestureRecognizer);
        children.add(output);
        return "${match[0]}";
      },
      onNonMatch: (String text) {
        children.add(TextSpan(text: text, style: style));
        return "*";
      },
    );
    return TextSpan(style: style, children: children);
  }
}

class DescriptionEditorKeyword {
  final String prefix;
  final String keyCharacter;
  final String pattern;
  final TextStyle textStyle;
  Function? onTap;
  Function? onLongTap;

  DescriptionEditorKeyword(
      {required this.prefix,
      required this.pattern,
      required this.textStyle,
      this.keyCharacter = "",
      this.onTap,
      this.onLongTap});
}
