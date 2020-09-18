import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kira_auth/utils/colors.dart';

/// TextField button
class TextFieldButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;

  TextFieldButton({@required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 48,
        width: 48,
        child: FlatButton(
          padding: EdgeInsets.all(14.0),
          onPressed: () {
            onPressed();
          },
          child: Icon(icon, size: 20),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(200.0)),
        ));
  }
}

/// A widget for our custom textfields
class AppTextField extends StatefulWidget {
  final TextAlign textAlign;
  final FocusNode focusNode;
  final TextEditingController controller;
  final Color cursorColor;
  final Brightness keyboardAppearance;
  final List<TextInputFormatter> inputFormatters;
  final TextInputAction textInputAction;
  final int maxLines;
  final bool autocorrect;
  final String hintText;
  final TextFieldButton prefixButton;
  final TextFieldButton suffixButton;
  final bool fadePrefixOnCondition;
  final bool prefixShowFirstCondition;
  final bool fadeSuffixOnCondition;
  final bool suffixShowFirstCondition;
  final EdgeInsetsGeometry padding;
  final Widget overrideTextFieldWidget;
  final int buttonFadeDurationMs;
  final TextInputType keyboardType;
  final Function onSubmitted;
  final Function onChanged;
  final Function onHalfClicked;
  final Function onMaxClicked;
  final double topMargin;
  final double leftMargin;
  final double rightMargin;
  final TextStyle style;
  final bool obscureText;
  final bool autofocus;
  final bool enabled;
  final bool readOnly;
  final bool showMax;

  AppTextField(
      {this.focusNode,
      this.controller,
      this.cursorColor,
      this.inputFormatters,
      this.textInputAction,
      this.hintText,
      this.prefixButton,
      this.suffixButton,
      this.fadePrefixOnCondition,
      this.prefixShowFirstCondition,
      this.fadeSuffixOnCondition,
      this.suffixShowFirstCondition,
      this.overrideTextFieldWidget,
      this.keyboardType,
      this.onSubmitted,
      this.onChanged,
      this.onHalfClicked,
      this.onMaxClicked,
      this.style,
      this.enabled = true,
      this.leftMargin,
      this.rightMargin,
      this.obscureText = false,
      this.textAlign = TextAlign.center,
      this.keyboardAppearance = Brightness.dark,
      this.autocorrect = true,
      this.maxLines = 1,
      this.padding = EdgeInsets.zero,
      this.buttonFadeDurationMs = 100,
      this.topMargin = 0,
      this.readOnly = false,
      this.autofocus = false,
      this.showMax = false});

  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      // width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
          // alignment: AlignmentDirectional.center,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: TextField(
                    // User defined fields
                    textAlign: widget.textAlign,
                    keyboardAppearance: widget.keyboardAppearance,
                    autocorrect: widget.autocorrect,
                    maxLines: widget.maxLines,
                    enabled: widget.enabled,
                    readOnly: widget.readOnly,
                    focusNode: widget.focusNode,
                    controller: widget.controller,
                    cursorColor: widget.cursorColor,
                    inputFormatters: widget.inputFormatters,
                    textInputAction: widget.textInputAction,
                    keyboardType: widget.keyboardType,
                    obscureText: widget.obscureText,
                    autofocus: widget.autofocus,
                    onSubmitted: widget.onSubmitted != null
                        ? widget.onSubmitted
                        : (text) {
                            if (widget.textInputAction ==
                                TextInputAction.done) {
                              FocusScope.of(context).unfocus();
                            }
                          },
                    onChanged: widget.onChanged,
                    // Style
                    style: widget.style,
                    // Input decoration
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      // Hint
                      hintText: widget.hintText == null ? "" : widget.hintText,
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w100,
                        fontFamily: 'NunitoSans',
                      ),
                      // First button
                    ))),
            if (widget.showMax == true)
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      hoverColor: Colors.red,
                      splashColor: Colors.green,
                      highlightColor: KiraColors.kYellowColor,
                      onTap: () {
                        widget.onHalfClicked();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 3.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'HALF',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: KiraColors.kPrimaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      hoverColor: Colors.red,
                      splashColor: Colors.green,
                      highlightColor: KiraColors.kYellowColor,
                      onTap: () {
                        widget.onMaxClicked();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 3.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'MAX',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: KiraColors.kPrimaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ])
          ]),
      // Buttons
    );
  }
}
