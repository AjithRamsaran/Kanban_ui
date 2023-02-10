import 'package:flutter/material.dart';

import '../model/Tags.dart';
import '../model/tag.dart';

typedef DeleteTag<T> = void Function(T index);

typedef TagTitle<String> = Widget Function(String tag);

class ConfirmIntentTagView extends StatefulWidget {
  ConfirmIntentTagView(
      {required this.tags,
      this.minTagViewHeight = 0,
      this.maxTagViewHeight = 150,
      this.tagBackgroundColor = Colors.black12,
      this.selectedTagBackgroundColor = Colors.lightBlue,
      this.deletableTag = true,
      required this.onDeleteTag,
      required this.tagTitle,
      this.isFirstSeverity = false,
      required this.refreshUI})
      : assert(
            tags != null,
            'Tags can\'t be empty\n'
            'Provide the list of tags');

  Set<Tag> tags;

  Color tagBackgroundColor;

  Color selectedTagBackgroundColor;

  bool deletableTag, isFirstSeverity;

  double maxTagViewHeight;

  double minTagViewHeight;

  DeleteTag<int> onDeleteTag;

  TagTitle<String> tagTitle;

  Function refreshUI;

  @override
  _ConfirmIntentTagViewState createState() => _ConfirmIntentTagViewState();
}

class _ConfirmIntentTagViewState extends State<ConfirmIntentTagView> {
  int selectedTagIndex = -1;

  @override
  Widget build(BuildContext context) {
    return getTagView();
  }

  Widget getTagView() {
    return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: widget.minTagViewHeight,
          //maxHeight: widget.maxTagViewHeight,
        ),
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.centerLeft,
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: (widget.deletableTag ? 3.0 : 10.0),
              direction: Axis.horizontal,
              children: buildTags(),
            ),
          ),
        ));
  }

  List<Widget> buildTags() {
    List<Widget> tags = <Widget>[];

    for (int i = 0; i < widget.tags.length; i++) {
      tags.add(createTag(i, widget.tags.elementAt(i)));
    }

    return tags;
  }

  Widget createTag(int index, Tag tagTitle) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedTagIndex = index;
        });
      },
      child: Chip(
        padding: EdgeInsets.zero,
        backgroundColor: widget.isFirstSeverity && index == 0
            ? Colors.white
            : widget.tagBackgroundColor,
        //Colors.grey.shade400,
        //
        //labelStyle: TextStyle(fontSize: 18, color: Colors.black54),
        shape: widget.isFirstSeverity && index == 0
            ? StadiumBorder(side: BorderSide(color: Colors.red))
            : null,
        label: widget.tagTitle == null
            ? Text(
                tagTitle.name ?? "",
                style: TextStyle(
                    fontSize: 12,
                    color: widget.isFirstSeverity && index == 0
                        ? Colors.red
                        : Colors.black87,
                    fontWeight: FontWeight.w500),
              )
            : widget.tagTitle(tagTitle.name ?? ""),

        deleteIcon: Icon(Icons.cancel),

        onDeleted: widget.deletableTag
            ? () {
                deleteTag(index);
              }
            : null,
      ),
    );
  }

  void deleteTag(int index) {
/*
    if(widget.onDeleteTag != null)

      widget.onDeleteTag(index);

    else {*/

    setState(() {
      widget.refreshUI?.call();
      widget.tags.remove(widget.tags.elementAt(index));
    });
  }

//}
}
