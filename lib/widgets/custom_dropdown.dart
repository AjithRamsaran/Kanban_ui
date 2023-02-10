import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


class CustomDropDown extends StatefulWidget {
  SuggestionsBoxController suggestionsBoxController;
  TextEditingController textEditingController;
  String label;
  bool hideKeyboard = false;
  Function itemBuilder;
  Function onSuggestionSelected;
  Function suggestionCallback;
  bool enabled;
  Function onChanged;

  CustomDropDown({
    required this.suggestionsBoxController,
    required this.textEditingController,
    required this.label,
    required this.hideKeyboard,
    required this.itemBuilder,
    required this.onSuggestionSelected,
    required this.suggestionCallback,
    this.enabled = true,
    required this.onChanged,
  });

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.green, // dropDownColor,
      ),
      child: TypeAheadFormField(
          autoFlipDirection: true,
          suggestionsBoxController: widget.suggestionsBoxController,
          hideKeyboard: widget.hideKeyboard,
          textFieldConfiguration: TextFieldConfiguration(
            // cursorColor: Colors.red,
            onTap: () {
              setState(() {});
            },
            // ignore: unnecessary_null_comparison
            onChanged: (value) {

            },//TODO widget.onChanged == null ? null : widget.onChanged,
            enabled: widget.enabled,
            focusNode: focusNode,
            controller: widget.textEditingController,
            decoration: InputDecoration(
              labelStyle: TextStyle(
                fontFamily: 'Poppins', /* color: Colors.black*/),
              fillColor: Colors.transparent,
              filled: true,
              suffixIcon: !widget.enabled
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(
                          Colors.green /*dropDownArrowColor*/),
                    ),
                  ),
                ],
              )
                  : focusNode.hasFocus
                  ? Icon(
                Icons.keyboard_arrow_up,
                size: 30,
                color: Colors.green /*dropDownArrowColor*/,
              )
                  : Icon(
                Icons.keyboard_arrow_down,
                size: 30,
                color: Colors.green /*dropDownArrowColor*/,
              ),
              contentPadding: EdgeInsets.only(left: 32, top: 16, bottom: 16),
              border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(20),
                  gapPadding: 4.0),
              labelText: widget.label,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          itemBuilder: (context, itemData) {
            return Container();
          },
          //TODO widget.itemBuilder,
          suggestionsCallback: (pattern) {
            return [];
          },
          //TODO widget.suggestionCallback
          // (pattern) {
          //   return widget.values;
          // }

          transitionBuilder: (context, suggestionsBox, controller) {
    return suggestionsBox;
    },
      onSuggestionSelected: (suggestion) {

      }, //widget.onSuggestionSelected,
    ),);
  }
}
