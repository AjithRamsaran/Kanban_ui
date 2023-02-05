import 'dart:developer';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_ui/bloc/board/board_bloc.dart';
import 'package:kanban_ui/model/task.dart';
import 'package:kanban_ui/model/task_status.dart';
import 'package:kanban_ui/networking/kanban_apis.dart';
import 'package:kanban_ui/repository/kanban_repository.dart';

import 'model/board.dart';

void main() {
  Bloc.observer = SimpleAppBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BoardBloc(
              kanbanRepository: KanbanRepository(kanbanApi: KanbanApi()))
            ..add(BoardStarted()),
        )
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home:
              Testing2() //Drag() //SampleDemo()//MyHomePage(title: 'Flutter Demo Home Page'),
          ),
    );
  }
}

final listViewKey = GlobalKey(debugLabel: "2");

final contentKey = GlobalKey(debugLabel: "hi");

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

class Testing2 extends StatefulWidget {
  @override
  _Testing2State createState() => _Testing2State();
}

class _Testing2State extends State<Testing2> {
  List listA = [
    "1",
    "2",
    "3",
    "34",
    "35",
    "45",
    "34",
    "35",
    "45",
    "34",
    "35",
    "45",
    "34",
    "35",
    "45",
    "34",
    "35",
    "45" "34",
    "35",
    "45",
    "34",
    "35",
    "45",
    "34",
    "35",
    "45",
    "34",
    "35",
    "45",
    "34",
    "35",
    "45" "34",
    "35",
    "45" "34",
    "35",
    "45"
  ];
  List listB = ["4", "5", "6"];

  List<Board> list = [];
  List<Color> colors = [];

  List<bool> flag = [false, false, false, false];
  List<Task>? dataL = [
    Task(id: 1,users: [], taskText: "",createdAt: "",status: TaskStatus(id: 1,status: "",createdAt: "",endAt: "",)),
    Task(id: 2,users: [], taskText: "",createdAt: "",status: TaskStatus(id: 1,status: "",createdAt: "",endAt: "")),
    Task(id: 3,users: [], taskText: "",createdAt: "",status: TaskStatus(id: 1,status: "",createdAt: "",endAt: "")),
  ];
  int selectedIndex = -1;
  final ScrollController scrollController = ScrollController();

  List<TextEditingController> editingController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  List<bool> focusTask = [false, false, false, false, false];

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

  @override
  void initState() {
    super.initState();
    /*list.add(listA);
    list.add(listB);
    list.add(["7", "8", "9"]);
    list.add(["10", "11", "12"]);
    */
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        Image.asset(
          'assets/background_image.png',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        GestureDetector(
          onTap: () {
            if (FocusScope.of(context).isFirstFocus) {
              FocusScope.of(context).requestFocus(new FocusNode());
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
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
                  child: BlocListener<BoardBloc, BoardState>(
                    listener: (context, state) {
                      if (state.operationStatus == OperationStatus.success) {
                        list = state.boards ?? [];
                        editingController = [];
                        editingController = List.generate(
                            state.boards?.length ?? 0,
                            (index) => TextEditingController());
                        focusTask = List.generate(
                            state.boards?.length ?? 0, (index) => false);
                        listScroll = List.generate(state.boards?.length ?? 0,
                            (index) => ScrollController());
                        flag = List.generate(
                            state.boards?.length ?? 0, (index) => false);
                        //dataL = state.boards;
                      } else {
                        list = [];
                        editingController = [];
                        focusTask = [];
                        listScroll = [];
                        flag = [];
                        dataL = [];
                      }
                    },
                    child: BlocBuilder<BoardBloc, BoardState>(
                      builder: (context, state) {
                        switch (state.operationStatus) {
                          case OperationStatus.loading:
                          case OperationStatus.initial:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          case OperationStatus.failure:
                            return Center(
                              child:
                                  Text("Error", style: TextStyle(fontSize: 24)),
                            );
                          case OperationStatus.success:
                            return ListView.builder(
                              controller: scrollController,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              key: listViewKey,
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(vertical: 32),
                              itemCount: state.boards?.length,
                              itemBuilder: (context, index) => RawScrollbar(
                                controller: listScroll[index],
                                thumbVisibility: true,
                                thickness: 10,
                                padding: EdgeInsets.all(20),
                                thumbColor: Colors.greenAccent,
                                child: ScrollConfiguration(
                                  behavior: ScrollConfiguration.of(context)
                                      .copyWith(scrollbars: false),
                                  child: SingleChildScrollView(
                                      primary: false,
                                      controller: listScroll[index],
                                      physics: BouncingScrollPhysics(),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (FocusScope.of(context)
                                              .isFirstFocus) {
                                            FocusScope.of(context)
                                                .requestFocus(new FocusNode());
                                          }
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: Color(
                                                    0xFFE2E4E9) /*Colors.white,*/),
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    750
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    5
                                                : MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        500
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.75,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Column(
                                              children: [
                                                Column(
                                                  //key: contentKey,
                                                  children: [
                                                    Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16,
                                                                vertical: 16),
                                                        child: Center(
                                                          child: Text(
                                                              state
                                                                      .boards?[
                                                                          index]
                                                                      .title ??
                                                                  "",
                                                              style: TextStyle(
                                                                  fontSize: 24,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        )),
/*
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
*/
                                                  ],
                                                ),
                                                if (list[index].tasks.length >
                                                    10)
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 16,
                                                        right: 24,
                                                        top: 16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        FocusScope(
                                                          onFocusChange:
                                                              (value) {
                                                            setState(() {
                                                              focusTask[index] =
                                                                  value;
                                                            });
                                                          },
                                                          child: TextField(
                                                            controller:
                                                                editingController[
                                                                    index],
                                                            onSubmitted:
                                                                (value) {
                                                              if (editingController[
                                                                      index]
                                                                  .text
                                                                  .isNotEmpty) {
                                                                setState(() {
                                                                  list[index].tasks.add(Task(
                                                                      id: 100 +
                                                                          index,
                                                                      taskText:
                                                                          editingController[index]
                                                                              .text,
                                                                      users: [],
                                                                      createdAt:
                                                                          DateTime.now()
                                                                              .toString(),
                                                                      status: TaskStatus(
                                                                          status: state.boards?[index].title ??
                                                                              "",
                                                                          id: state.boards?[index].id ??
                                                                              100 +
                                                                                  index,
                                                                          createdAt:
                                                                              DateTime.now().toString())));
                                                                  editingController[
                                                                          index]
                                                                      .text = '';
                                                                });
                                                              }
                                                              if (FocusScope.of(
                                                                      context)
                                                                  .isFirstFocus) {
                                                                FocusScope.of(
                                                                        context)
                                                                    .requestFocus(
                                                                        new FocusNode());
                                                              }
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              labelStyle: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins'),
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      left: 8,
                                                                      top: 16,
                                                                      bottom:
                                                                          8),
                                                              filled: true,
                                                              fillColor: Colors
                                                                  .transparent,
                                                              labelText:
                                                                  "Add task",
                                                              border:
                                                                  new OutlineInputBorder(
                                                                borderSide: new BorderSide(
                                                                    color: Color(
                                                                        0xFF799681)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                gapPadding: 4.0,
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xFF799681)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .blue),
                                                                //Color(0xFF256B3B)
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              /*suffixIcon: widget.suffixIcon == null ? null : widget.suffixIcon,
                                                          prefixIcon: widget.prefixIcon == null ? null : widget.prefixIcon,
                                                          prefixText: widget.prefixText*/
                                                            ),
                                                          ),
                                                        ),
                                                        if (focusTask[index])
                                                          SizedBox(
                                                            height: 16,
                                                          ),
                                                        if (focusTask[index])
                                                          FilledButton(
                                                              style: ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all(
                                                                          Colors
                                                                              .green)),
                                                              onPressed: () {
                                                                if (editingController[
                                                                        index]
                                                                    .text
                                                                    .isNotEmpty) {
                                                                  /*list[index].add(
                                                                      editingController[
                                                                              index]
                                                                          .text);*/
                                                                  list[index].tasks.add(Task(
                                                                      id: 100 +
                                                                          index,
                                                                      taskText:
                                                                          editingController[index]
                                                                              .text,
                                                                      users: [],
                                                                      createdAt:
                                                                          DateTime.now()
                                                                              .toString(),
                                                                      status: TaskStatus(
                                                                          status: state.boards?[index].title ??
                                                                              "",
                                                                          id: state.boards?[index].id ??
                                                                              100 +
                                                                                  index,
                                                                          createdAt:
                                                                              DateTime.now().toString())));

                                                                  editingController[
                                                                          index]
                                                                      .text = '';
                                                                  setState(
                                                                      () {});
                                                                }
                                                              },
                                                              child: Text(
                                                                "Add",
                                                                style:
                                                                    TextStyle(),
                                                              ))
                                                      ],
                                                    ),
                                                  ),
                                                ListView.builder(
                                                  primary: false,
                                                  //controller: listScroll[index],
                                                  physics:
                                                      BouncingScrollPhysics(),

//BouncingScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int childIndex) {
                                                    return childIndex <
                                                                list[index]
                                                                        .tasks
                                                                        .length +
                                                                    1 &&
                                                            childIndex > 0
                                                        ? DragTarget(
                                                            builder: (context,
                                                                candidateData,
                                                                rejectedData) {
                                                              return Draggable<
                                                                  Task>(
                                                                data: list[index]
                                                                        .tasks[
                                                                    childIndex -
                                                                        1],
                                                                onDragStarted: () =>
                                                                    isDragging =
                                                                        true,
                                                                onDragCompleted: () =>
                                                                    isDragging =
                                                                        false,
                                                                onDragEnd:
                                                                    (details) =>
                                                                        isDragging =
                                                                            false,
                                                                feedback: Card(
                                                                  child:
                                                                      Container(
                                                                    color: Colors
                                                                        .amberAccent,
                                                                    width: 400 -
                                                                        64,
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                      list[index]
                                                                          .tasks[childIndex -
                                                                              1]
                                                                          .taskText,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                  ),
                                                                ),
                                                                childWhenDragging:
                                                                    Column(
                                                                  children: [
                                                                    Card(
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            300,
                                                                        color: Colors
                                                                            .grey,
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Text(
                                                                          list[index]
                                                                              .tasks[childIndex - 1]
                                                                              .taskText,
                                                                          style:
                                                                              TextStyle(fontSize: 20),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    Card(
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              8,
                                                                          right:
                                                                              24,
                                                                          bottom:
                                                                              8,
                                                                          top:
                                                                              8),
                                                                      color: Colors
                                                                          .white,
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            totalSize,
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Text(
                                                                          list[index]
                                                                              .tasks[childIndex - 1]
                                                                              .taskText,
                                                                          style:
                                                                              TextStyle(fontSize: 20),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    /*if (flag[index] &&
                                                                                    childIndex ==
                                                                                        selectedIndex)
                                                                                SizedBox(
                                                                                  height: 12,
                                                                                ),*/
                                                                    if (flag[
                                                                            index] &&
                                                                        childIndex ==
                                                                            selectedIndex)
                                                                      Card(
                                                                        color: Colors
                                                                            .lightBlue[200],
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              300,
                                                                          //double.infinity,
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Text(
                                                                            dataL?.elementAt(index).taskText ??
                                                                                "",
                                                                            style:
                                                                                TextStyle(fontSize: 20),
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
                                                                    .tasks
                                                                    .contains(
                                                                        data)) {
                                                                  list[index]
                                                                      .tasks
                                                                      .remove(
                                                                          data);
                                                                  list[index]
                                                                      .tasks
                                                                      .insert(
                                                                          childIndex,
                                                                          data
                                                                              as Task);
                                                                } else {
                                                                  list[index]
                                                                      .tasks
                                                                      .insert(
                                                                          childIndex,
                                                                          data
                                                                              as Task);
                                                                  for (int i =
                                                                          0;
                                                                      i < list.length;
                                                                      i++) {
                                                                    if (i !=
                                                                            index &&
                                                                        list[i].tasks.indexOf(data) >
                                                                            -1) {
                                                                      list[i]
                                                                          .tasks
                                                                          .remove(
                                                                              data);
                                                                      break;
                                                                    }
                                                                  }
                                                                }
                                                              });
                                                              setState(() {
                                                                flag[index] =
                                                                    false;
                                                                selectedIndex =
                                                                    -1;
                                                              });
                                                            },
                                                            onLeave: (data) {
                                                              setState(() {
                                                                flag[index] =
                                                                    false;
                                                              });
                                                            },
                                                            onWillAccept:
                                                                (data) {
                                                              setState(() {
                                                                flag[index] =
                                                                    true;
                                                                // dataL[index] =
                                                                //     data;
                                                                dataL?.insert(
                                                                    index,
                                                                    data
                                                                        as Task);
                                                                selectedIndex =
                                                                    childIndex;
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
                                                                  if (flag[
                                                                          index] &&
                                                                      childIndex ==
                                                                          selectedIndex)
                                                                    Card(
                                                                      color: Colors
                                                                              .lightBlue[
                                                                          200],
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            300,
                                                                        //double.infinity,
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Text(
                                                                          dataL?.elementAt(index).taskText ??
                                                                              "",
                                                                          style:
                                                                              TextStyle(fontSize: 20),
                                                                        ),
                                                                      ),
                                                                    )
                                                                ],
                                                              );
                                                            },
                                                            onAccept: (data) {
                                                              setState(() {
                                                                if (list[index]
                                                                    .tasks
                                                                    .contains(
                                                                        data)) {
                                                                  list[index]
                                                                      .tasks
                                                                      .remove(
                                                                          data);
                                                                  list[index]
                                                                      .tasks
                                                                      .insert(
                                                                          childIndex,
                                                                          data
                                                                              as Task);
                                                                } else {
                                                                  list[index]
                                                                      .tasks
                                                                      .insert(
                                                                          childIndex,
                                                                          data
                                                                              as Task);
                                                                  for (int i =
                                                                          0;
                                                                      i < list.length;
                                                                      i++) {
                                                                    if (i !=
                                                                            index &&
                                                                        list[i].tasks.indexOf(data) >
                                                                            -1) {
                                                                      list[i]
                                                                          .tasks
                                                                          .remove(
                                                                              data);
                                                                      break;
                                                                    }
                                                                  }
                                                                }
                                                              });
                                                              setState(() {
                                                                flag[index] =
                                                                    false;
                                                                selectedIndex =
                                                                    -1;
                                                              });
                                                            },
                                                            onLeave: (data) {
                                                              setState(() {
                                                                flag[index] =
                                                                    false;
                                                              });
                                                            },
                                                            onWillAccept:
                                                                (data) {
                                                              setState(() {
                                                                flag[index] =
                                                                    true;
                                                                /*dataL[index] =
                                                                    data;*/
                                                                dataL?.insert(
                                                                    index,
                                                                    data
                                                                        as Task);
                                                                selectedIndex =
                                                                    childIndex;
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
                                                  itemCount:
                                                      list[index].tasks.length +
                                                          1,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16,
                                                      right: 24,
                                                      top: 16,
                                                      bottom: 16),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      FocusScope(
                                                        onFocusChange: (value) {
                                                          setState(() {
                                                            focusTask[index] =
                                                                value;
                                                          });
                                                        },
                                                        child: TextField(
                                                          controller:
                                                              editingController[
                                                                  index],
                                                          onSubmitted: (value) {
                                                            if (editingController[
                                                                    index]
                                                                .text
                                                                .isNotEmpty) {
                                                              setState(() {
                                                                // list[index].add(
                                                                //     editingController[
                                                                //             index]
                                                                //         .text);
                                                                list[index].tasks.add(Task(
                                                                    id: 100 +
                                                                        index,
                                                                    taskText:
                                                                        editingController[index]
                                                                            .text,
                                                                    users: [],
                                                                    createdAt: DateTime
                                                                            .now()
                                                                        .toString(),
                                                                    status: TaskStatus(
                                                                        status:
                                                                            state.boards?[index].title ??
                                                                                "",
                                                                        id: state.boards?[index].id ??
                                                                            100 +
                                                                                index,
                                                                        createdAt:
                                                                            DateTime.now().toString())));
                                                                editingController[
                                                                        index]
                                                                    .text = '';
                                                              });
                                                            }
                                                            if (FocusScope.of(
                                                                    context)
                                                                .isFirstFocus) {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      new FocusNode());
                                                            }
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            labelStyle: TextStyle(
                                                                fontFamily:
                                                                    'Poppins'),
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    left: 8,
                                                                    top: 16,
                                                                    bottom: 8),
                                                            filled: true,
                                                            fillColor: Colors
                                                                .transparent,
                                                            labelText:
                                                                "Add task",
                                                            border:
                                                                new OutlineInputBorder(
                                                              borderSide:
                                                                  new BorderSide(
                                                                      color: Color(
                                                                          0xFF799681)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              gapPadding: 4.0,
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Color(
                                                                      0xFF799681)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .blue),
                                                              //Color(0xFF256B3B)
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            prefixIcon: Icon(
                                                                Icons.add,
                                                                size: 24),
                                                            /*suffixIcon: widget.suffixIcon == null ? null : widget.suffixIcon,
                                                          prefixIcon: widget.prefixIcon == null ? null : widget.prefixIcon,
                                                          prefixText: widget.prefixText*/
                                                          ),
                                                        ),
                                                      ),
                                                      if (focusTask[index])
                                                        SizedBox(
                                                          height: 16,
                                                        ),
                                                      if (focusTask[index])
                                                        FilledButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all(Colors
                                                                            .green)),
                                                            onPressed: () {
                                                              if (editingController[
                                                                      index]
                                                                  .text
                                                                  .isNotEmpty) {
                                                                /*list[index].add(
                                                                    editingController[
                                                                            index]
                                                                        .text);*/
                                                                list[index].tasks.add(Task(
                                                                    id: 100 +
                                                                        index,
                                                                    taskText:
                                                                        editingController[index]
                                                                            .text,
                                                                    users: [],
                                                                    createdAt: DateTime
                                                                            .now()
                                                                        .toString(),
                                                                    status: TaskStatus(
                                                                        status:
                                                                            state.boards?[index].title ??
                                                                                "",
                                                                        id: state.boards?[index].id ??
                                                                            100 +
                                                                                index,
                                                                        createdAt:
                                                                            DateTime.now().toString())));
                                                                editingController[
                                                                        index]
                                                                    .text = '';
                                                                setState(() {});
                                                              }
                                                              setState(() {
                                                                focusTask[
                                                                        index] =
                                                                    false;
                                                              });
                                                            },
                                                            child: Text(
                                                              "Add",
                                                              style:
                                                                  TextStyle(),
                                                            ))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                      )),
                                ),
                              ),
                            );
                          default:
                            return Container();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    )));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

class SimpleAppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('${bloc.runtimeType} - Transition: $event');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('${bloc.runtimeType} - Transition: $error');

    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log('${bloc.runtimeType} - Transition: $transition');
  }
}
