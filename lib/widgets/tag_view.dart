import 'package:flutter/material.dart';
import 'package:kanban_ui/utils/color_util.dart';

import '../model/Tags.dart';
import '../model/Users.dart';

typedef DeleteTag<T> = void Function(T index);

class ChipView<T> extends StatefulWidget {
  ChipView(
      {required this.tags,
      this.minTagViewHeight = 0,
      this.deletableTag = true,
      required this.onDeleteTag,
      required this.refreshUI})
      : assert(
            tags != null,
            'Tags can\'t be empty\n'
            'Provide the list of tags');

  Set<T> tags;

  bool deletableTag;

  double minTagViewHeight;

  DeleteTag<int> onDeleteTag;

  Function refreshUI;

  @override
  _ChipViewState createState() => _ChipViewState();
}

class _ChipViewState extends State<ChipView> {
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

  Widget createTag<T>(int index, T tagTitle) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedTagIndex = index;
        });
      },
      child: Chip(
        padding: EdgeInsets.zero,
        backgroundColor: tagTitle is Tag
            ? ColorUtil.btnColorMap[(tagTitle as Tag).color]
            : Colors.grey.shade500,
        label: Stack(
          children: <Widget>[
            // Stroked text as border.
            if (tagTitle is Tag)
              Text(
                tagTitle is Tag
                    ? tagTitle.name ?? ""
                    : tagTitle is User
                        ? tagTitle.name ?? ""
                        : "",
                style: TextStyle(
                  fontSize: 14,
                  /*color:
                          Colors.white, */
                  //ColorUtil.btnColorMap[tagTitle.color],
                  fontWeight: FontWeight.w500,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 1
                    ..color = Colors.black26,
                ),
              ),
            Text(
              tagTitle is Tag
                  ? tagTitle.name ?? ""
                  : tagTitle is User
                      ? tagTitle.name ?? ""
                      : "",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white, //ColorUtil.btnColorMap[tagTitle.color],
                  fontWeight: FontWeight.w500),
            ),
            // Solid text as fill.
          ],
        ),
        deleteIcon: Icon(Icons.cancel, color: Colors.white),
        onDeleted: widget.deletableTag
            ? () {
                deleteTag(index);
              }
            : null,
      ),
    );
  }

  void deleteTag(int index) {
    setState(() {
      widget.refreshUI?.call();
      widget.tags.remove(widget.tags.elementAt(index));
    });
  }

//}
}
