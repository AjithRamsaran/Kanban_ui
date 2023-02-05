import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'main.dart';

class Drag extends StatefulWidget {
  @override
  _DragState createState() => _DragState();
}
class _DragState extends State<Drag> with WidgetsBindingObserver {
  List listA = ["1", "2", "3"];
  List listB = ["4", "5", "6"];

  List<List> list = [];
  List<Color> colors = [];

  List<bool> flag = [false, false, false, false];
  List<Object?> dataL = ["", "", "", ""];
  int selectedIndex = -1;
  final ScrollController scrollController = ScrollController();

  List<ScrollController> listScroll = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController()
  ];

  int click = 13;
  bool isDragging = false;

  double totalSize = 500;
  double header_height = 0;

  void _updateData() {
    final renderBox =
    contentKey.currentContext?.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    setState(() {
      header_height = renderBox.size.height;
    });
  }

  @override
  void initState() {
    super.initState();
    list.add(listA);
    list.add(listB);
    list.add(["7", "8", "9"]);
    list.add(["10", "11", "12"]);
    colors.add(Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(1.0));
    colors.add(Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(1.0));
    colors.add(Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(1.0));
    colors.add(Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(1.0));
    /*WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _updateData();
    });*/
  }

  /*@override
  void didChangeMetrics() {
    _updateData();
  }
*/
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    totalSize = MediaQuery.of(context).size.width * 0.75;
    return Scaffold(
      backgroundColor: Colors.white70, //Color(0xFFDBDBDB),
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/background_image.png',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              child: Container(
                //height: MediaQuery.of(context).size.height,
                child: Listener(
                  onPointerMove: (PointerMoveEvent event) {
                    if (!isDragging) {
                      return;
                    }
                    RenderBox render = listViewKey.currentContext
                        ?.findRenderObject() as RenderBox;
                    Offset position = render.localToGlobal(Offset.zero);
                    double startX = position.dx; // start position of the widget
                    double endX = startX +
                        render.size.width; // end position of the widget

                    double detectedRange = (endX - startX) / 5;
                    const moveDistance = 20;

                    if (event.position.dx < startX + detectedRange) {
                      // code to scroll up
                      var to = scrollController.offset - moveDistance;
                      to = (to < 0) ? 0 : to;
                      scrollController.jumpTo(to);
                    }
                    if (event.position.dx > endX - detectedRange) {
                      // code to scroll down
                      scrollController
                          .jumpTo(scrollController.offset + moveDistance);
                    }
                  },
                  child: ListView.builder(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    key: listViewKey,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Wrap(
                        children: [
                          Container(
                            width: totalSize,
                            //MediaQuery.of(context).size.width * 0.75,
                            //color: Colors.pink,
                            margin: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            decoration: BoxDecoration(
                                color: Color(0xFFDBDBDB), //Colors.white,
                                border: Border.all(
                                    width: 1, color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(10)),
                            alignment: Alignment.topCenter,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
/*                                Column(
                                  //key: contentKey,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 16),
                                        child: Center(
                                          child: Text("Title",
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold)),
                                        )),
                                    Container(
                                      padding: EdgeInsets.only(right: 20),
                                      child: GestureDetector(
                                        onTap: () {
                                          click++;
                                          setState(() {
                                            list[index].add("$click");
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              child: Text(
                                                'Add task',
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 24),
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            Icon(
                                              Icons.add_box_outlined,
                                              color: Colors.green,
                                              size: 30,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),*/
                                Container(
                                  /*height: MediaQuery.of(context).size.height -
                                      header_height -
                                      64,*/
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Scrollbar(
                                    controller: listScroll[index],
                                    thumbVisibility: true,
                                    thickness: 10,
                                    child: ListView.builder(
                                      //primary: false,
                                      controller: listScroll[index],
                                      physics: BouncingScrollPhysics(),

//BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context,
                                          int childIndex) {
                                        return childIndex <
                                            list[index].length + 1 &&
                                            childIndex > 0
                                            ? DragTarget(
                                          builder: (context,
                                              candidateData,
                                              rejectedData) {
                                            return Draggable<String>(
                                              data: list[index]
                                              [childIndex - 1],
                                              onDragStarted: () =>
                                              isDragging = true,
                                              onDragCompleted: () =>
                                              isDragging = false,
                                              onDragEnd: (details) =>
                                              isDragging = false,
                                              feedback: Card(
                                                child: Container(
                                                  color:
                                                  Colors.amberAccent,
                                                  width: 400 - 64,
                                                  padding:
                                                  const EdgeInsets
                                                      .all(8.0),
                                                  child: Text(
                                                    list[index]
                                                    [childIndex - 1],
                                                    style: TextStyle(
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                              childWhenDragging: Column(
                                                children: [
                                                  Card(
                                                    child: Container(
                                                      width: 300,
                                                      color: Colors.grey,
                                                      padding:
                                                      const EdgeInsets
                                                          .all(8.0),
                                                      child: Text(
                                                        list[index][
                                                        childIndex -
                                                            1],
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  Card(
                                                    margin:
                                                    EdgeInsets.only(
                                                        left: 8,
                                                        right: 24,
                                                        bottom: 8,
                                                        top: 8),
                                                    color: Colors.white,
                                                    child: Container(
                                                      width: totalSize,
                                                      padding:
                                                      const EdgeInsets
                                                          .all(8.0),
                                                      child: Text(
                                                        list[index][
                                                        childIndex -
                                                            1],
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ),
                                                  /*if (flag[index] &&
                                                            childIndex ==
                                                                selectedIndex)
                                                        SizedBox(
                                                          height: 12,
                                                        ),*/
                                                  if (flag[index] &&
                                                      childIndex ==
                                                          selectedIndex)
                                                    Card(
                                                      color: Colors
                                                          .lightBlue[200],
                                                      child: Container(
                                                        width: 300,
                                                        //double.infinity,
                                                        padding:
                                                        const EdgeInsets
                                                            .all(8.0),
                                                        child: Text(
                                                          dataL[index] !=
                                                              null
                                                              ? dataL[index]
                                                              .toString()
                                                              : "",
                                                          style: TextStyle(
                                                              fontSize:
                                                              20),
                                                        ),
                                                      ),
                                                    )
                                                ],
                                              ),
                                            );
                                          },
                                          onAccept: (data) {
                                            setState(() {
                                              if (list[index]
                                                  .contains(data)) {
                                                list[index].remove(data);
                                                list[index].insert(
                                                    childIndex, data);
                                              } else {
                                                list[index].insert(
                                                    childIndex, data);
                                                for (int i = 0;
                                                i < list.length;
                                                i++) {
                                                  if (i != index &&
                                                      list[i].indexOf(
                                                          data) >
                                                          -1) {
                                                    list[i].remove(data);
                                                    break;
                                                  }
                                                }
                                              }
                                            });
                                            setState(() {
                                              flag[index] = false;
                                              selectedIndex = -1;
                                            });
                                          },
                                          onLeave: (data) {
                                            setState(() {
                                              flag[index] = false;
                                            });
                                          },
                                          onWillAccept: (data) {
                                            setState(() {
                                              flag[index] = true;
                                              dataL[index] = data;
                                              selectedIndex = childIndex;
                                            });
                                            return true;
                                          },
                                        )
                                            : /*flag[index] && childIndex >= list[index].length
                                                ? Card(
                                                    color: Colors.lightBlue[200],
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context).size.width -
                                                              32, //double.infinity,
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        dataL[index] != null
                                                            ? dataL[index].toString()
                                                            : "",
                                                        style: TextStyle(fontSize: 20),
                                                      ),
                                                    ),
                                                  )
                                                :*/
                                        DragTarget(
                                          builder: (context,
                                              candidateData,
                                              rejectedData) {
                                            return Column(
                                              children: [
                                                Container(
                                                  height: 20,
                                                ),
                                                if (flag[index] &&
                                                    childIndex ==
                                                        selectedIndex)
                                                  Card(
                                                    color: Colors
                                                        .lightBlue[200],
                                                    child: Container(
                                                      width:
                                                      300, //double.infinity,
                                                      padding:
                                                      const EdgeInsets
                                                          .all(8.0),
                                                      child: Text(
                                                        dataL[index] !=
                                                            null
                                                            ? dataL[index]
                                                            .toString()
                                                            : "",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            );
                                          },
                                          onAccept: (data) {
                                            setState(() {
                                              if (list[index]
                                                  .contains(data)) {
                                                list[index].remove(data);
                                                list[index].insert(
                                                    childIndex, data);
                                              } else {
                                                list[index].insert(
                                                    childIndex, data);
                                                for (int i = 0;
                                                i < list.length;
                                                i++) {
                                                  if (i != index &&
                                                      list[i].indexOf(
                                                          data) >
                                                          -1) {
                                                    list[i].remove(data);
                                                    break;
                                                  }
                                                }
                                              }
                                            });
                                            setState(() {
                                              flag[index] = false;
                                              selectedIndex = -1;
                                            });
                                          },
                                          onLeave: (data) {
                                            setState(() {
                                              flag[index] = false;
                                            });
                                          },
                                          onWillAccept: (data) {
                                            setState(() {
                                              flag[index] = true;
                                              dataL[index] = data;
                                              selectedIndex = childIndex;
                                            });
                                            return true;
                                          },
                                        );
                                      },
                                      /* separatorBuilder: (context, index) =>
                                          Container(height: 20),*/
/*                              separatorBuilder: (context, childIndex) {
                                              return DragTarget<String>(
                                                builder: (context, candidates, rejects) {
                                                  return AnimatedSwitcher(
                                                    duration: Duration(milliseconds: 1),
                                                    child: candidates.length > 0
                                                        ? _buildDropPreview(
                                                            context, candidates[0])
                                                        : Container(
                                                            width: 5,
                                                            height: 5,
                                                          ),
                                                  );
                                                },
                                                onWillAccept: (value) {
                                                  setState(() {
                                                    flag[index] = false;
                                                  });
                                                  return true;
                                                },
                                                //!listA.contains(value),
                                                onAccept: (data) {
                                                  //NEW
                                                  setState(() {
                                                    if (list[index].contains(data)) {
                                                      list[index].remove(data);
                                                      list[index].insert(childIndex -1, data);
                                                    } else {
                                                      list[index].insert(childIndex, data);
                                                      for (int i = 0; i < list.length; i++) {
                                                        if (i != index &&
                                                            list[i].indexOf(data) > -1) {
                                                          list[i].remove(data);
                                                          break;
                                                        }
                                                      }
                                                    }
                                                  });
                                                },
                                              );
                                            },*/
                                      itemCount: list[index].length + 1,
                                    ),
                                  ),
                                ),
                              ],
                            ) /*DragTarget(
                                builder: (context, candidateData, rejectedData) {
                                  return
                                },
                                onWillAccept: (data) => true,
                                onAccept: (data) {
                                  if (list[index].contains(data)) {
                                    list[index].remove(data);
                                    list[index].add(data);
                                  } else {
                                    list[index].add(data);
                                    for (int i = 0; i < list.length; i++) {
                                      if (i != index && list[i].indexOf(data) > -1) {
                                        list[i].remove(data);
                                        break;
                                      }
                                    }

                                    setState(() {});


                                  }

                                })*/
                            ,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//  builds the widgets for List B items
  Widget _buildListBItems(BuildContext context, int index) {
    return index < listB.length + 1 && index > 0
        ? Draggable<String>(
//      the value of this draggable is set using data
      data: listB[index - 1],
//      the widget to show under the users finger being dragged
      feedback: Card(
        child: Container(
          color: Colors.amberAccent,
          width: MediaQuery.of(context).size.width - 64,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            listB[index - 1],
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
//      what to display in the child's position when being dragged
      childWhenDragging: Container(
        color: Colors.grey,
        width: 40,
        height: 40,
      ),
//      widget in idle state
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            listB[index - 1],
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    )
        : Container();
  }

//  builds the widgets for List A items
  Widget _buildListAItems(BuildContext context, int index) {
    return index < listA.length + 1 && index > 0
        ? Draggable<String>(
      data: listA[index - 1],
      feedback: Card(
        child: Container(
          color: Colors.amberAccent,
          width: MediaQuery.of(context).size.width - 64,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            listA[index - 1],
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      childWhenDragging: Container(
        //color: Colors.grey,
        //width: 40,
        // height: 40,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            listA[index - 1],
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    )
        : Container();
  }

//  will return a widget used as an indicator for the drop position
  Widget _buildDropPreview(BuildContext context, String? value) {
    return Card(
      color: Colors.lightBlue[200],
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          value != null ? value : "--",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

//  builds DragTargets used as separators between list items/widgets for list A
  Widget _buildDragTargetsA(BuildContext context, int index) {
    return DragTarget<String>(
//      builder responsible to build a widget based on whether there is an item being dropped or not
      builder: (context, candidates, rejects) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 1),
          child: candidates.length > 0
              ? _buildDropPreview(context, candidates[0])
              : Container(
            width: 5,
            height: 5,
          ),
        );
      },
//      condition on to accept the item or not
      onWillAccept: (value) => true, //!listA.contains(value),
//      what to do when an item is accepted
      onAccept: (value) {
        setState(() {
          if (listB.contains(value)) {
            listA.insert(index - 1 + 1, value);
            listB.remove(value);
          } else {
            listA.remove(value);
            listA.insert(index - 1, value);
          }
        });
      },
    );
  }

//  builds drag targets for list B
  Widget _buildDragTargetsB(BuildContext context, int index) {
    return DragTarget<String>(
      builder: (context, candidates, rejects) {
        return candidates.length > 0
            ? _buildDropPreview(context, candidates[0])
            : Container(width: 10, height: 10);
      },
      onWillAccept: (value) => true, //!listB.contains(value),
      onAccept: (value) {
        if (listA.contains(value)) {
          setState(() {
            listB.insert(index - 1 + 1, value);
            listA.remove(value);
          });
        } else {
          listB.remove(value);
          listB.insert(index - 1, value);
        }
      },
    );
  }
}

class Testing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: /*Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 123,
                itemBuilder: (BuildContext context, int index) {
                  return SingleChildScrollView(
                    child: Container(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Parent'),
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                              itemCount: index ==1 ? 2 : 100,
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Text('Child');
                              }),
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    )*/
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.all(16),
                      itemCount: 10,
                      itemBuilder: (context, index) => SingleChildScrollView(
                          child: Container(
                              width: 200,
                              color: Colors.blue,
                              child: Column(
                                children: [
                                  Text('Parent'),
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: index == 1 ? 3 : 30,
                                    itemBuilder: (context, index) => Container(
                                        child: ListTile(
                                          title: Text("Hlo"),
                                          subtitle: Text("Hi"),
                                        )),
                                  ),
                                ],
                              ))),
                    ),
                  ),
                ],
              ),
            )));
  }
}

