import 'dart:developer';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:kanban_ui/bloc/board/board_bloc.dart';
import 'package:kanban_ui/model/task.dart';
import 'package:kanban_ui/model/task_status.dart';
import 'package:kanban_ui/networking/kanban_apis.dart';
import 'package:kanban_ui/repository/kanban_repository.dart';
import 'package:kanban_ui/utils/color_util.dart';
import 'package:kanban_ui/utils/string_utils.dart';
import 'package:kanban_ui/widgets/confirm_intent_tag_view.dart';
import 'package:kanban_ui/widgets/custom_dropdown.dart';
import 'package:kanban_ui/widgets/nameIcon.dart';
import 'package:kanban_ui/widgets/tag_view.dart';

import 'model/Data.dart';
import 'model/Tags.dart';
import 'model/TaskIds.dart';
import 'model/Users.dart';
import 'model/board.dart';
import 'model/tag.dart';

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
  List<Board> list = [];
  List<Color> colors = [];
  bool _isAddboardEnd = false;

  List<bool> flag = [false, false, false, false];
  List<Task>? dataL = [
    Task(
        id: 1,
        users: [],
        description: "",
        createdAt: "",
        timeTracker: [
          TaskStatus(
            id: 1,
            status: "",
            createdAt: "",
            endAt: "",
          )
        ]),
    Task(
        id: 2,
        users: [],
        description: "",
        createdAt: "",
        timeTracker: [TaskStatus(id: 1, status: "", createdAt: "", endAt: "")]),
    Task(
        id: 3,
        users: [],
        description: "",
        createdAt: "",
        timeTracker: [TaskStatus(id: 1, status: "", createdAt: "", endAt: "")]),
  ];
  int selectedIndex = -1;
  final ScrollController scrollController = ScrollController();

  TextEditingController editingControllerForDescription =
      TextEditingController();
  TextEditingController editingControllerForAddBoard = TextEditingController();

  List<TextEditingController> editingController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  List<bool> focusTask = [false, false, false, false, false];
  bool focusNew = false;

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
                      if (state.operationStatus == OperationStatus.success ||
                          state.operationStatus == OperationStatus.loading) {
                        list = state.boards ?? [];
                        /*  list.add(Board(id: 0, title: "", tasks: []));*/
                        editingController = [];
                        editingController = List.generate(
                            (state.boards?.length ?? 0) /*+ 1*/,
                            (index) => TextEditingController());
                        focusTask = List.generate(
                            (state.boards?.length ?? 0) /* + 1*/,
                            (index) => false);
                        listScroll = List.generate(
                            (state.boards?.length ?? 0) /*+ 1*/,
                            (index) => ScrollController());
                        flag = List.generate(
                            (state.boards?.length ?? 0) /*+ 1*/,
                            (index) => false);
                        dataL = List.generate(
                            (state.boards?.length ?? 0) /*+ 1*/,
                            (index) => Task(
                                id: 1000 + index,
                                description: editingController[index].text,
                                users: [],
                                createdAt: DateTime.now().toString(),
                                timeTracker: [
                                  TaskStatus(
                                      status: state.boards?[index].name ?? "",
                                      id: state.boards?[index].id ??
                                          1000 + index,
                                      createdAt: DateTime.now().toString())
                                ]));
                        focusNew = false;
                        editingControllerForDescription.text = '';
                      } else {
                        list = [];
                        editingController = [];
                        focusTask = [];
                        listScroll = [];
                        flag = [];
                        dataL = [];
                        _isAddboardEnd = false;
                        focusNew = false;
                        editingControllerForDescription.text = '';
                      }

                      if (state.isAddNewOrUpdateTask == ActionStatus.hide) {
                        selectedItems = [];
                        selectedUser = [];
                        _isAddboardEnd = false;
                        editingControllerForDescription.text = '';
                        editingControllerForAddBoard.text = '';
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          Navigator.pop(context);
                          if (FocusScope.of(context).isFirstFocus) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          }
                        });
                      }
                    },
                    child: BlocBuilder<BoardBloc, BoardState>(
                      builder: (context, state) {
                        switch (state.operationStatus) {
                          case OperationStatus.initial:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          case OperationStatus.failure:
                            return Error(
                              onRetryPressed: () {
                                context.read<BoardBloc>().add(BoardStarted());
                              },
                              buttonText: "Retry",
                              errorMessage: "Something went wrong",
                              key: Key("1"),
                            );
                          case OperationStatus.success:
                          case OperationStatus.loading:
                            return Stack(
                              children: [
                                ListView.builder(
                                  controller: scrollController,
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  key: listViewKey,
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.symmetric(vertical: 32),
                                  itemCount: (state.boards?.length ?? 0) + 1,
                                  itemBuilder: (context, index) {
                                    return (index > list.length - 1 /*-2*/)
                                        ? Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
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
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16,
                                                      right: 24,
                                                      top: 16,
                                                      bottom: 16),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      FocusScope(
                                                        onFocusChange: (value) {
                                                          setState(() {
                                                            focusNew = value;
                                                          });
                                                        },
                                                        child: TextField(
                                                          controller:
                                                              editingControllerForDescription,
                                                          onSubmitted: (value) {
                                                            if (editingControllerForDescription
                                                                .text
                                                                .isNotEmpty) {
                                                              focusNew = false;
                                                              context
                                                                  .read<
                                                                      BoardBloc>()
                                                                  .add(AddBoardEvent(
                                                                      editingControllerForDescription
                                                                          .text,
                                                                      "",
                                                                      _isAddboardEnd));
                                                              editingControllerForDescription
                                                                  .text = '';

/*
  setState(() {
                                                                state.boards?.add(Board(
                                                                    title:
                                                                        editingControllerNew
                                                                            .text,
                                                                    tasks: [],
                                                                    id: 123));
                                                                dataL?.add(Task(
                                                                    id: 100 + index,
                                                                    description:
                                                                        editingControllerNew
                                                                            .text,
                                                                    users: [],
                                                                    createdAt: DateTime
                                                                            .now()
                                                                        .toString(),
                                                                    status: TaskStatus(
                                                                        status:
                                                                            editingControllerNew.text ??
                                                                                "",
                                                                        id: 100 +
                                                                            index,
                                                                        createdAt: DateTime
                                                                                .now()
                                                                            .toString())));
                                                                listScroll.add(
                                                                    ScrollController());
                                                                focusTask
                                                                    .add(false);
                                                                editingController.add(
                                                                    TextEditingController());
                                                                flag.add(false);
                                                                focusNew = false;
                                                                editingControllerNew
                                                                    .text = '';
                                                              });*/
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
                                                                "Add Board",
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
                                                          ),
                                                        ),
                                                      ),
                                                      if (focusNew)
                                                        SizedBox(
                                                          height: 16,
                                                        ),
                                                      if (focusNew)
                                                        Column(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  _isAddboardEnd =
                                                                      !_isAddboardEnd;
                                                                });
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  _isAddboardEnd
                                                                      ? const Icon(
                                                                          Icons
                                                                              .check_box_outlined)
                                                                      : const Icon(
                                                                          Icons
                                                                              .check_box_outline_blank),
                                                                  Text(
                                                                    "done status board"
                                                                        .toString(),
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 16,
                                                            ),
                                                            FilledButton(
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all(
                                                                            Colors.green)),
                                                                onPressed: () {
                                                                  if (editingControllerForDescription
                                                                      .text
                                                                      .isNotEmpty) {
                                                                    context
                                                                        .read<
                                                                            BoardBloc>()
                                                                        .add(AddBoardEvent(
                                                                            editingControllerForDescription.text,
                                                                            "",
                                                                            _isAddboardEnd));
/*                                                            setState(() {
                                                                      state.boards?.add(Board(
                                                                          title:
                                                                              editingControllerNew
                                                                                  .text,
                                                                          tasks: [],
                                                                          id: 123));
                                                                      dataL?.add(Task(
                                                                          id: 100 +
                                                                              index,
                                                                          description:
                                                                              editingControllerNew
                                                                                  .text,
                                                                          users: [],
                                                                          createdAt: DateTime
                                                                                  .now()
                                                                              .toString(),
                                                                          status: TaskStatus(
                                                                              status:
                                                                                  editingControllerNew.text ??
                                                                                      "",
                                                                              id: 100 +
                                                                                  index,
                                                                              createdAt:
                                                                                  DateTime.now()
                                                                                      .toString())));
                                                                      listScroll.add(
                                                                          ScrollController());
                                                                      focusTask
                                                                          .add(false);
                                                                      editingController.add(
                                                                          TextEditingController());
                                                                      flag.add(false);
                                                                    });*/
                                                                  }
                                                                  setState(() {
                                                                    focusNew =
                                                                        false;
                                                                    editingControllerForDescription
                                                                        .text = '';
                                                                  });
                                                                },
                                                                child: Text(
                                                                  "Add Board",
                                                                  style:
                                                                      TextStyle(),
                                                                )),
                                                          ],
                                                        )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : buildBoards(index, context, state);
                                  },
                                ),
                                if (state.operationStatus ==
                                    OperationStatus.loading)
                                  Opacity(
                                    opacity: 0.5,
                                    child: Scaffold(),
                                  ),
                                if (state.operationStatus ==
                                    OperationStatus.loading)
                                  Center(
                                    child: CircularProgressIndicator(),
                                  ),
                              ],
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
        Positioned(
            bottom: 10,
            right: 10,
            child: BlocConsumer<BoardBloc, BoardState>(
              listenWhen: (previous, current) {
                if (previous.generalLoaderAtBottom != ActionStatus.normal &&
                    current.message.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${current.message}")));
                  return true;
                }
                return false;
              },
              listener: (context, state) {},
              builder: (context, state) {
                if (state.generalLoaderAtBottom == ActionStatus.loading)
                  return CircularProgressIndicator(
                    color: Colors.green,
                  );
                return FilledButton(
                  onPressed: () {
                    context.read<BoardBloc>().add(ExportTaskEvent());
                  },
                  child: Text(
                    "Export Csv",
                  ),
                );
              },
            ))
      ],
    )));
  }

  List<Tag> selectedItems = [];
  List<User> selectedUser = [];

  RawScrollbar buildBoards(int index, BuildContext context, BoardState state) {
    return RawScrollbar(
      controller: listScroll[index],
      thumbVisibility: true,
      thickness: 10,
      padding: EdgeInsets.all(20),
      thumbColor: Colors.greenAccent,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
            primary: false,
            controller: listScroll[index],
            physics: BouncingScrollPhysics(),
            child: GestureDetector(
              onTap: () {
                if (FocusScope.of(context).isFirstFocus) {
                  FocusScope.of(context).requestFocus(new FocusNode());
                }
              },
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Color(0xFFE2E4E9) /*Colors.white,*/),
                  width: MediaQuery.of(context).size.width > 750
                      ? MediaQuery.of(context).size.width / 5
                      : MediaQuery.of(context).size.width > 500
                          ? MediaQuery.of(context).size.width / 2
                          : MediaQuery.of(context).size.width * 0.75,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Column(
                        //key: contentKey,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: Center(
                                child: Text(state.boards?[index].name ?? "",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              )),
                        ],
                      ),
                      ListView.builder(
                        primary: false,
                        //controller: listScroll[index],
                        physics: BouncingScrollPhysics(),

//BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int childIndex) {
                          return childIndex <
                                      (list[index].taskIds?.length ?? 0) + 1 &&
                                  childIndex > 0
                              ? DragTarget(
                                  builder:
                                      (context, candidateData, rejectedData) {
                                    return Draggable<Task>(
                                      data:
                                          list[index].taskIds?[childIndex - 1],
                                      onDragStarted: () => isDragging = true,
                                      onDragCompleted: () => isDragging = false,
                                      onDragEnd: (details) =>
                                          isDragging = false,
                                      feedback: Card(
                                        child: Container(
                                          color: Colors.amberAccent,
                                          width: 400 - 64,
                                          padding: const EdgeInsets.all(8.0),
                                          child: buildDraggableWidget(
                                              index, childIndex),
                                        ),
                                      ),
                                      childWhenDragging: Column(
                                        children: [
                                          Card(
                                            child: Container(
                                              width: 300,
                                              color: Colors.grey,
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: buildDraggableWidget(
                                                  index, childIndex),
                                            ),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (FocusScope.of(context)
                                                  .isFirstFocus) {
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        new FocusNode());
                                              }
                                              editingControllerForDescription
                                                  .text = list[index]
                                                      .taskIds?[childIndex - 1]
                                                      ?.description ??
                                                  "";
                                              editingController[index]
                                                  .text = list[index]
                                                      .taskIds?[childIndex - 1]
                                                      ?.name ??
                                                  "";
                                              selectedUser = list[index]
                                                      .taskIds?[childIndex - 1]
                                                      ?.users ??
                                                  [];
                                              selectedItems = list[index]
                                                      .taskIds?[childIndex - 1]
                                                      ?.tags ??
                                                  [];
                                              buildShowDialogForEdit(context,
                                                      index, childIndex - 1)
                                                  .then((value) {
                                                editingControllerForDescription
                                                    .text = "";
                                                editingController[index].text =
                                                    "";
                                                selectedUser = [];
                                                selectedItems = [];
                                              });
                                            },
                                            child: Card(
                                              margin: EdgeInsets.only(
                                                  left: 8,
                                                  right: 24,
                                                  bottom: 8,
                                                  top: 8),
                                              color: Colors.white,
                                              child: Container(
                                                width: totalSize,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: buildDraggableWidget(
                                                    index, childIndex),
                                              ),
                                            ),
                                          ),
                                          if (flag[index] &&
                                              childIndex == selectedIndex)
                                            Card(
                                              color: Colors.lightBlue[200],
                                              child: Container(
                                                width: 300,
                                                //double.infinity,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SingleChildScrollView(
                                                      child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Wrap(
                                                          alignment:
                                                              WrapAlignment
                                                                  .start,
                                                          spacing: 4,
                                                          direction:
                                                              Axis.horizontal,
                                                          children: [
                                                            ...?dataL
                                                                ?.elementAt(
                                                                    index)
                                                                .tags
                                                                ?.map((e) =>
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius: BorderRadius.circular(
                                                                              4.0),
                                                                          border:
                                                                              Border.all(color: ColorUtil.btnColorMap[e.color] ?? Colors.grey)),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              4),
                                                                      margin: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              2,
                                                                          horizontal:
                                                                              8),
                                                                      child:
                                                                          Text(
                                                                        '${e.name}',
                                                                        style: TextStyle(
                                                                            color:
                                                                                ColorUtil.btnColorMap[e.color]), //Colors.black),//
                                                                      ),
                                                                    ))
                                                                .toList()
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        dataL
                                                                ?.elementAt(
                                                                    index)
                                                                .name ??
                                                            "",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                    );
                                  },
                                  onAccept: (data) {
                                    int newBoardIndex =
                                        list[index].id?.toInt() ?? -1;
                                    int oldBoardIndex = newBoardIndex;
                                    setState(() {
                                      if (list[index].taskIds?.contains(data) ??
                                          false) {
                                        list[index].taskIds?.remove(data);
                                        list[index]
                                            .taskIds
                                            ?.insert(childIndex, data as Task);
                                      } else {
                                        list[index]
                                            .taskIds
                                            ?.insert(childIndex, data as Task);
                                        for (int i = 0; i < list.length; i++) {
                                          if (i != index &&
                                              (list[i].taskIds?.indexOf(
                                                          data as Task?) ??
                                                      0) >
                                                  -1) {
                                            oldBoardIndex =
                                                list[i].id?.toInt() ?? -1;
                                            list[i].taskIds?.remove(data);
                                            break;
                                          }
                                        }
                                      }
                                    });
                                    setState(() {
                                      flag[index] = false;
                                      selectedIndex = -1;
                                    });
                                    context.read<BoardBloc>().add(MoveTaskEvent(
                                        moveToBoardId: newBoardIndex,
                                        taskId: (data as Task).id?.toInt() ?? 0,
                                        boardId: oldBoardIndex));
                                  },
                                  onLeave: (data) {
                                    setState(() {
                                      flag[index] = false;
                                    });
                                  },
                                  onWillAccept: (data) {
                                    setState(() {
                                      flag[index] = true;
                                      // dataL[index] =
                                      //     data;
                                      dataL?.insert(index, data as Task);
                                      selectedIndex = childIndex;
                                    });
                                    return true;
                                  },
                                )
                              : DragTarget(
                                  builder:
                                      (context, candidateData, rejectedData) {
                                    return Column(
                                      children: [
                                        Container(
                                          height: 20,
                                        ),
                                        if (flag[index] &&
                                            childIndex == selectedIndex)
                                          Card(
                                            color: Colors.lightBlue[200],
                                            child: Container(
                                              width: 300,
                                              //double.infinity,
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  //buildDraggableWidgetForDragTarget(index),
                                                  Text(
                                                    dataL
                                                            ?.elementAt(index)
                                                            .description ??
                                                        "",
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                      ],
                                    );
                                  },
                                  onAccept: (data) {
                                    int newBoardIndex =
                                        list[index].id?.toInt() ?? -1;
                                    int oldBoardIndex = newBoardIndex;
                                    setState(() {
                                      if (list[index].taskIds?.contains(data) ??
                                          false) {
                                        list[index].taskIds?.remove(data);
                                        list[index]
                                            .taskIds
                                            ?.insert(childIndex, data as Task);
                                      } else {
                                        list[index]
                                            .taskIds
                                            ?.insert(childIndex, data as Task);
                                        for (int i = 0; i < list.length; i++) {
                                          if (i != index &&
                                              (list[i].taskIds?.indexOf(
                                                          data as Task?) ??
                                                      0) >
                                                  -1) {
                                            list[i].taskIds?.remove(data);
                                            break;
                                          }
                                        }
                                      }
                                    });
                                    setState(() {
                                      flag[index] = false;
                                      selectedIndex = -1;
                                    });

                                    context.read<BoardBloc>().add(MoveTaskEvent(
                                        moveToBoardId: newBoardIndex,
                                        taskId: (data as Task).id?.toInt() ?? 0,
                                        boardId: oldBoardIndex));
                                  },
                                  onLeave: (data) {
                                    setState(() {
                                      flag[index] = false;
                                    });
                                  },
                                  onWillAccept: (data) {
                                    setState(() {
                                      flag[index] = true;
                                      /*dataL[index] =
                                                                  data;*/
                                      dataL?.insert(index, data as Task);
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
                        itemCount: (list[index].taskIds?.length ?? 0) + 1,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16, right: 24, top: 16, bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FocusScope(
                              onFocusChange: (value) {
                                setState(() {
                                  focusTask[index] = value;
                                });
                              },
                              child: TextField(
                                controller: editingController[index],
                                onSubmitted: (value) {
                                  if (editingController[index]
                                      .text
                                      .isNotEmpty) {
                                    if (FocusScope.of(context).isFirstFocus) {
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                    }

                                    buildShowDialog(context, index);

/*                                    context.read<BoardBloc>().add(AddTaskEvent(
                                        editingController[index].text,
                                        list[index].id?.toInt() ?? 0));*/
                                    setState(() {
                                      //editingController[index].text = '';
                                      //focusTask[index] = false;

                                      /*list[index].tasks.add(Task(
                                          id: 100 + index,
                                          description:
                                              editingController[index].text,
                                          users: [],
                                          createdAt: DateTime.now().toString(),
                                          status: TaskStatus(
                                              status:
                                                  state.boards?[index].title ??
                                                      "",
                                              id: state.boards?[index].id ??
                                                  100 + index,
                                              createdAt:
                                                  DateTime.now().toString())));*/
                                    });
                                  }
                                  if (FocusScope.of(context).isFirstFocus) {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                  }
                                },
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(fontFamily: 'Poppins'),
                                  contentPadding: EdgeInsets.only(
                                      left: 8, top: 16, bottom: 8),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  labelText: "Add task",
                                  border: new OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Color(0xFF799681)),
                                    borderRadius: BorderRadius.circular(8),
                                    gapPadding: 4.0,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF799681)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    //Color(0xFF256B3B)
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  prefixIcon: Icon(Icons.add, size: 24),
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
                                              Colors.green)),
                                  onPressed: () {
                                    if (editingController[index]
                                        .text
                                        .isNotEmpty) {
                                      buildShowDialog(context, index);
                                      /*list[index].add(
                                                                  editingController[
                                                                          index]
                                                                      .text);*/

/*                                      context.read<BoardBloc>().add(
                                          AddTaskEvent(
                                              editingController[index].text,
                                              list[index].id?.toInt() ?? 0));*/
                                      setState(() {
                                        //editingController[index].text = '';
                                        focusTask[index] = false;
                                      });

                                      /*        list[index].tasks.add(Task(
                                          id: 100 + index,
                                          description:
                                              editingController[index].text,
                                          users: [],
                                          createdAt: DateTime.now().toString(),
                                          status: TaskStatus(
                                              status:
                                                  state.boards?[index].title ??
                                                      "",
                                              id: state.boards?[index].id ??
                                                  100 + index,
                                              createdAt:
                                                  DateTime.now().toString())));*/
                                    }
                                  },
                                  child: Text(
                                    "Add",
                                    style: TextStyle(),
                                  ))
                          ],
                        ),
                      ),
                    ],
                  )),
            )),
      ),
    );
  }

/*
  Column buildDraggableWidgetForDragTarget(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          child: Container(
            alignment: Alignment.centerLeft,
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 4,
              direction: Axis.horizontal,
              children: [
                ...?dataL?[index]
                    ?.tags
                    ?.map((e) => Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                          color: ColorUtil.btnColorMap[e.color] ??
                              Colors.grey)),
                  padding: EdgeInsets.all(4),
                  margin:
                  EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  child: Text(
                    '${e.name}',
                    style: TextStyle(
                        color: ColorUtil
                            .btnColorMap[e.color]), //Colors.black),//
                  ),
                ))
                    .toList()
              ],
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            list[index].taskIds?[childIndex - 1]?.name ?? "",
            style: TextStyle(fontSize: 20),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            alignment: Alignment.centerRight,
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 4,
              direction: Axis.horizontal,
              children: [
                ...?list[index]
                    .taskIds?[childIndex - 1]
                    ?.users
                    ?.map((e) => NameIcon(
                  firstName: e.name ?? "-",
                  backgroundColor: Colors.white,
                  textColor: Colors.orange,
                ))
                    .toList()
              ],
            ),
          ),
        ),
        if ((list[index].isEnd ?? false) &&
            ((list[index].taskIds?[childIndex - 1]?.endTime?.isNotEmpty ??
                false) &&
                (list[index]
                    .taskIds?[childIndex - 1]
                    ?.endTime
                    ?.contains('[a-zA-Z]') ??
                    true) &&
                (list[index].taskIds?[childIndex - 1]?.createdAt?.isNotEmpty ??
                    false)))
          Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new RichText(
                    text: new TextSpan(
                      style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        new TextSpan(text: 'Total time: '),
                        new TextSpan(
                            text: (list[index].taskIds?[childIndex - 1]?.endTime !=
                                null &&
                                list[index]
                                    .taskIds?[childIndex - 1]
                                ?.createdAt !=
                                null)
                                ? DateFormat("yyyy-MM-dd HH:mm:ss")
                                .parse(list[index]
                                .taskIds?[childIndex - 1]
                                ?.endTime ??
                                "")
                                .difference(
                                DateFormat("yyyy-MM-dd HH:mm:ss").parse(
                                    list[index]
                                        .taskIds?[childIndex - 1]
                                        ?.createdAt ??
                                        ""))
                                .inMinutes
                                .toString() +
                                " minutes"
                                : "",
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new RichText(
                    text: new TextSpan(
                      style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        new TextSpan(text: 'End date: '),
                        new TextSpan(
                            text:
                            DateFormat("MMM dd, hh:mm a").format(DateTime.now()),
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ))

            ],
          ),],
    );
  }
*/

  Column buildDraggableWidget(int index, int childIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          child: Container(
            alignment: Alignment.centerLeft,
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 4,
              direction: Axis.horizontal,
              children: [
                ...?list[index]
                    .taskIds?[childIndex - 1]
                    ?.tags
                    ?.map((e) => Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                  color: ColorUtil.btnColorMap[e.color] ??
                                      Colors.grey)),
                          padding: EdgeInsets.all(4),
                          margin:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                          child: Text(
                            '${e.name}',
                            style: TextStyle(
                                color: ColorUtil
                                    .btnColorMap[e.color]), //Colors.black),//
                          ),
                        ))
                    .toList()
              ],
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            list[index].taskIds?[childIndex - 1]?.name ?? "",
            style: TextStyle(fontSize: 20),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            alignment: Alignment.centerRight,
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 4,
              direction: Axis.horizontal,
              children: [
                ...?list[index]
                    .taskIds?[childIndex - 1]
                    ?.users
                    ?.map((e) => NameIcon(
                          firstName: e.name ?? "-",
                          backgroundColor: Colors.white,
                          textColor: Colors.orange,
                        ))
                    .toList()
              ],
            ),
          ),
        ),
        if ((list[index].isEnd ?? false) &&
            ((list[index].taskIds?[childIndex - 1]?.endTime?.isNotEmpty ??
                    false) &&
                !(list[index]
                        .taskIds?[childIndex - 1]
                        ?.endTime
                        ?.contains('[a-zA-Z]') ??
                    true) &&
                (list[index].taskIds?[childIndex - 1]?.createdAt?.isNotEmpty ??
                    false)))
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new RichText(
                    text: new TextSpan(
                      style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        new TextSpan(text: 'Total time: '),
                        new TextSpan(
                            text: (list[index]
                                            .taskIds?[childIndex - 1]
                                            ?.endTime !=
                                        null &&
                                    list[index]
                                            .taskIds?[childIndex - 1]
                                            ?.createdAt !=
                                        null)
                                ? StringUtils.timeDifference(
                                    DateFormat("yyyy-MM-dd HH:mm:ss").parse(
                                        list[index]
                                                .taskIds?[childIndex - 1]
                                                ?.createdAt ??
                                            ""),
                                    DateFormat("yyyy-MM-dd HH:mm:ss").parse(
                                        list[index]
                                                .taskIds?[childIndex - 1]
                                                ?.endTime ??
                                            ""))
                                : "",
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new RichText(
                    text: new TextSpan(
                      style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        new TextSpan(text: 'End date: '),
                        new TextSpan(
                            text: DateFormat("MMM dd, hh:mm a")
                                .format(DateTime.now()),
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ))
            ],
          ),
      ],
    );
  }

  Future<dynamic> buildShowDialogForEdit(
      BuildContext context, int index, int childIndex) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return BlocBuilder<BoardBloc, BoardState>(
              //listener: (context, state) {},
              builder: (context, state) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Wrap(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2 > 800
                              ? MediaQuery.of(context).size.width / 2
                              : 800,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
                                controller: editingController[index],
                                onSubmitted: (value) {
                                  if (editingController[index]
                                      .text
                                      .isNotEmpty) {
                                    //  focusNew = false;
                                  }
                                  if (FocusScope.of(context).isFirstFocus) {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                  }
                                },
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(fontFamily: 'Poppins'),
                                  contentPadding: EdgeInsets.only(
                                      left: 8, top: 16, bottom: 8),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  labelText: editingController[index].text,
                                  border: new OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Color(0xFF799681)),
                                    borderRadius: BorderRadius.circular(8),
                                    gapPadding: 4.0,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF799681)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    //Color(0xFF256B3B)
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  prefixIcon: Icon(Icons.add, size: 24),
                                ),
                              ),
                              /* SizedBox(
                                                            height: 16,
                                                          ),*/
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Description:",
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                    ),
                                  )),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  /*gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFBFD4C5),
                                      Color(0xFFF2F6F3),
                                    ],
                                  ),*/
                                ),
                                child: TextField(
                                  cursorColor: Colors.green,
                                  maxLines: null,
                                  minLines: 3,
                                  keyboardType: TextInputType.text,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  textInputAction: TextInputAction.done,
                                  controller: editingControllerForDescription,
                                  decoration: new InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 32,
                                        top: 16,
                                        right: 32,
                                        bottom: 16),
                                    border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Color(0xFF799681)),
                                      borderRadius: BorderRadius.circular(8),
                                      gapPadding: 4.0,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF799681)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                      //Color(0xFF256B3B)
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Color(0xFF799681)),
                                    borderRadius: BorderRadius.circular(8)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    isExpanded: true,
                                    hint: Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Text(
                                        ' Select Tags',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                    ),
                                    items: state.tags?.map((item) {
                                      return DropdownMenuItem<Tag>(
                                        value: item,
                                        //disable default onTap to avoid closing menu when selecting an item
                                        enabled: false,
                                        child: StatefulBuilder(
                                          builder: (context, menuSetState) {
                                            final _isSelected =
                                                selectedItems.contains(item);
                                            return InkWell(
                                              onTap: () {
                                                _isSelected
                                                    ? selectedItems.remove(item)
                                                    : selectedItems.add(item);
                                                //This rebuilds the StatefulWidget to update the button's text
                                                setState(() {});
                                                //This rebuilds the dropdownMenu Widget to update the check mark
                                                menuSetState(() {});
                                              },
                                              child: Container(
                                                height: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Row(
                                                  children: [
                                                    _isSelected
                                                        ? const Icon(Icons
                                                            .check_box_outlined)
                                                        : const Icon(Icons
                                                            .check_box_outline_blank),
                                                    Text(
                                                      item.name.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }).toList(),
                                    //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                                    /*value: selectedItems
                                                                        .isEmpty
                                                                    ? null
                                                                    : selectedItems
                                                                        .last,
                                                                */
                                    onChanged: (value) {},
                                    buttonHeight: 40,
                                    buttonWidth: double.infinity,
                                    itemHeight: 40,
                                    itemPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              if (selectedItems.length > 0)
                                ChipView(
                                    tags: selectedItems.toSet(),
                                    onDeleteTag: (_) {},
                                    refreshUI: () {
                                      setState(() {});
                                    }),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Color(0xFF799681)),
                                    borderRadius: BorderRadius.circular(8)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    isExpanded: true,
                                    hint: Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          ' Select User',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ),
                                    ),

                                    items: state.users?.map((item) {
                                      return DropdownMenuItem<User>(
                                        value: item,
                                        //disable default onTap to avoid closing menu when selecting an item
                                        enabled: false,
                                        child: StatefulBuilder(
                                          builder: (context, menuSetState) {
                                            final _isSelected =
                                                selectedUser.contains(item);
                                            return InkWell(
                                              onTap: () {
                                                _isSelected
                                                    ? selectedUser.remove(item)
                                                    : selectedUser.add(item);
                                                //This rebuilds the StatefulWidget to update the button's text
                                                setState(() {});
                                                //This rebuilds the dropdownMenu Widget to update the check mark
                                                menuSetState(() {});
                                              },
                                              child: Container(
                                                height: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Row(
                                                  children: [
                                                    _isSelected
                                                        ? const Icon(Icons
                                                            .check_box_outlined)
                                                        : const Icon(Icons
                                                            .check_box_outline_blank),
                                                    Text(
                                                      item.name.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }).toList(),
                                    //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                                    onChanged: (value) {},
                                    buttonHeight: 40,
                                    buttonWidth: double.infinity,
                                    itemHeight: 40,
                                    itemPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              if (selectedUser.length > 0)
                                ChipView(
                                    tags: selectedUser.toSet(),
                                    onDeleteTag: (_) {},
                                    refreshUI: () {
                                      setState(() {});
                                    }),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 13,
                              ),

                              if (state.isAddNewOrUpdateTask ==
                                  ActionStatus.normal) //!isLoading
                                Column(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Container()),
                                    SizedBox(
                                      height: 12.0,
                                    ),
                                    FilledButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.green),
                                        ),
                                        onPressed: () {
                                          context.read<BoardBloc>().add(
                                              UpdateTaskEvent(
                                                  taskId: list[index]
                                                          .taskIds?[childIndex]
                                                          ?.id
                                                          ?.toInt() ??
                                                      -1,
                                                  title:
                                                      editingController[index]
                                                          .text,
                                                  description:
                                                      editingControllerForDescription
                                                          .text,
                                                  boardId:
                                                      list[index].id?.toInt() ??
                                                          0,
                                                  users: selectedUser,
                                                  tags: selectedItems));
                                        },
                                        child: Text(
                                          "Update",
                                          style: TextStyle(fontSize: 20),
                                        )),
                                  ],
                                ),
                              if (state.isAddNewOrUpdateTask ==
                                  ActionStatus.loading) //!isLoading
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              //
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<dynamic> buildShowDialog(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return BlocBuilder<BoardBloc, BoardState>(
              //listener: (context, state) {},
              builder: (context, state) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Wrap(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2 > 800
                              ? MediaQuery.of(context).size.width / 2
                              : 800,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
                                controller: editingController[index],
                                onSubmitted: (value) {
                                  if (editingController[index]
                                      .text
                                      .isNotEmpty) {
                                    //  focusNew = false;
                                  }
                                  if (FocusScope.of(context).isFirstFocus) {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                  }
                                },
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(fontFamily: 'Poppins'),
                                  contentPadding: EdgeInsets.only(
                                      left: 8, top: 16, bottom: 8),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  labelText: editingController[index].text,
                                  border: new OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Color(0xFF799681)),
                                    borderRadius: BorderRadius.circular(8),
                                    gapPadding: 4.0,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF799681)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                    //Color(0xFF256B3B)
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  prefixIcon: Icon(Icons.add, size: 24),
                                ),
                              ),
                              /* SizedBox(
                                                            height: 16,
                                                          ),*/
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Description:",
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                    ),
                                  )),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  /*gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFBFD4C5),
                                      Color(0xFFF2F6F3),
                                    ],
                                  ),*/
                                ),
                                child: TextField(
                                  cursorColor: Colors.green,
                                  maxLines: null,
                                  minLines: 3,
                                  keyboardType: TextInputType.text,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  textInputAction: TextInputAction.done,
                                  controller: editingControllerForDescription,
                                  decoration: new InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 32,
                                        top: 16,
                                        right: 32,
                                        bottom: 16),
                                    border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Color(0xFF799681)),
                                      borderRadius: BorderRadius.circular(8),
                                      gapPadding: 4.0,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF799681)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                      //Color(0xFF256B3B)
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Color(0xFF799681)),
                                    borderRadius: BorderRadius.circular(8)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    isExpanded: true,
                                    hint: Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Text(
                                        ' Select Tags',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                    ),
                                    items: state.tags?.map((item) {
                                      return DropdownMenuItem<Tag>(
                                        value: item,
                                        //disable default onTap to avoid closing menu when selecting an item
                                        enabled: false,
                                        child: StatefulBuilder(
                                          builder: (context, menuSetState) {
                                            final _isSelected =
                                                selectedItems.contains(item);
                                            return InkWell(
                                              onTap: () {
                                                _isSelected
                                                    ? selectedItems.remove(item)
                                                    : selectedItems.add(item);
                                                //This rebuilds the StatefulWidget to update the button's text
                                                setState(() {});
                                                //This rebuilds the dropdownMenu Widget to update the check mark
                                                menuSetState(() {});
                                              },
                                              child: Container(
                                                height: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Row(
                                                  children: [
                                                    _isSelected
                                                        ? const Icon(Icons
                                                            .check_box_outlined)
                                                        : const Icon(Icons
                                                            .check_box_outline_blank),
                                                    Text(
                                                      item.name.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }).toList(),
                                    //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                                    /*value: selectedItems
                                                                        .isEmpty
                                                                    ? null
                                                                    : selectedItems
                                                                        .last,
                                                                */
                                    onChanged: (value) {},
                                    buttonHeight: 40,
                                    buttonWidth: double.infinity,
                                    itemHeight: 40,
                                    itemPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              if (selectedItems.length > 0)
                                ChipView(
                                    tags: selectedItems.toSet(),
                                    onDeleteTag: (_) {},
                                    refreshUI: () {
                                      setState(() {});
                                    }),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Color(0xFF799681)),
                                    borderRadius: BorderRadius.circular(8)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    isExpanded: true,
                                    hint: Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          ' Select User',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ),
                                    ),

                                    items: state.users?.map((item) {
                                      return DropdownMenuItem<User>(
                                        value: item,
                                        //disable default onTap to avoid closing menu when selecting an item
                                        enabled: false,
                                        child: StatefulBuilder(
                                          builder: (context, menuSetState) {
                                            final _isSelected =
                                                selectedUser.contains(item);
                                            return InkWell(
                                              onTap: () {
                                                _isSelected
                                                    ? selectedUser.remove(item)
                                                    : selectedUser.add(item);
                                                //This rebuilds the StatefulWidget to update the button's text
                                                setState(() {});
                                                //This rebuilds the dropdownMenu Widget to update the check mark
                                                menuSetState(() {});
                                              },
                                              child: Container(
                                                height: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Row(
                                                  children: [
                                                    _isSelected
                                                        ? const Icon(Icons
                                                            .check_box_outlined)
                                                        : const Icon(Icons
                                                            .check_box_outline_blank),
                                                    Text(
                                                      item.name.toString(),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }).toList(),
                                    //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                                    onChanged: (value) {},
                                    buttonHeight: 40,
                                    buttonWidth: double.infinity,
                                    itemHeight: 40,
                                    itemPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              if (selectedUser.length > 0)
                                ChipView(
                                    tags: selectedUser.toSet(),
                                    onDeleteTag: (_) {},
                                    refreshUI: () {
                                      setState(() {});
                                    }),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 13,
                              ),

                              if (state.isAddNewOrUpdateTask ==
                                  ActionStatus.normal) //!isLoading
                                Column(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Container()),
                                    SizedBox(
                                      height: 12.0,
                                    ),
                                    FilledButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.green),
                                        ),
                                        onPressed: () {
                                          context.read<BoardBloc>().add(
                                              AddTaskEvent(
                                                  title:
                                                      editingController[index]
                                                          .text,
                                                  description:
                                                      editingControllerForDescription
                                                          .text,
                                                  boardId:
                                                      list[index].id?.toInt() ??
                                                          0,
                                                  users: selectedUser,
                                                  tags: selectedItems));
                                        },
                                        child: Text(
                                          "Submit",
                                          style: TextStyle(fontSize: 20),
                                        )),
                                  ],
                                ),
                              if (state.isAddNewOrUpdateTask ==
                                  ActionStatus.loading) //!isLoading
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              //
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
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

class CustomDialogBox extends StatefulWidget {
  Function acceptRejectTransaction;
  bool isLoading;
  Task task;

  CustomDialogBox(
      {required this.acceptRejectTransaction,
      required this.isLoading,
      required this.task});

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  bool isLoading = false;
  bool isBackEnabled = true;
  final suggestionBoxController = SuggestionsBoxController();
  final TextEditingController tagTextEditing = TextEditingController();

  List<dynamic> storesList = <Tag>[];
  Set<Tag> selectedTagList = <Tag>{};

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => isBackEnabled,
      child: Card(
        elevation: 1000,
        color: Colors.transparent,
        child: StatefulBuilder(
          builder: (context, setstate) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Wrap(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 2,
                          vertical: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.task.name}",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 13,
                          ),
                          !isLoading
                              ? Column(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child:
                                            Container() /*getSubmitButton('Accept', () {
                                    setstate(() {
                                      isLoading = true;
                                      isBackEnabled = false;
                                    });
                                    widget.acceptRejectTransaction(
                                      widget.task,
                                      "1",
                                      isLoading,
                                      setstate,
                                    );
                                  })*/
                                        ),
                                    CustomDropDown(
                                      onChanged: (_) {},
                                      suggestionsBoxController:
                                          suggestionBoxController,
                                      textEditingController: tagTextEditing,
                                      label: 'Tag*',
                                      hideKeyboard: true,
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          tileColor:
                                              storesList.indexOf(suggestion) %
                                                          2 ==
                                                      0
                                                  ? Color(0xF8F9FA)
                                                  : Colors.white,
                                          title: Text(
                                            (suggestion as Tag).name ?? "",
                                          ),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        /*this._storeTextEditing.text =
                                    (suggestion as Store).name;
                                selectedStore =
                                    (suggestion as Store).id.toString();*/
                                        setState(() {
                                          selectedTagList
                                              .add((suggestion as Tag));
                                        });
                                      },
                                      suggestionCallback: (pattern) {
                                        return storesList;
                                      },
                                      enabled: true,
                                    ),
                                    SizedBox(
                                      height: 16.0,
                                    ),
                                    if (selectedTagList.length > 0)
                                      ConfirmIntentTagView(
                                        tags: selectedTagList,
                                        deletableTag: true,
                                        refreshUI: () {},
                                        onDeleteTag: (_) {},
                                        tagTitle: (String tag) {
                                          return Container();
                                        },
                                      ),
                                    SizedBox(
                                      height: 12.0,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setstate(() {
                                          isLoading = true;
                                          isBackEnabled = false;
                                        });
                                        widget.acceptRejectTransaction(
                                            widget.task,
                                            "-1",
                                            isLoading,
                                            setstate);
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.7,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          border: Border.all(
                                              color: Colors.transparent),
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Color(0xFFEB312F),
                                              Color(0xFFED4F2D),
                                              Color(0xFFEE612C),
                                              Color(0xFFEF6B2B),
                                              Color(0xFFEF762B),
                                              Color(0xFFEF822A),
                                              Color(0xFFF0852B),
                                            ],
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(2.0),
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Reject',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Color(0xFFEC3130)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: Colors.green,
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Text(
                                          'Processing! Please wait.',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'poppins'),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Error extends StatelessWidget {
  final String errorMessage;

  final Function()? onRetryPressed;
  String buttonText;

  Error(
      {required Key key,
      required this.errorMessage,
      required this.onRetryPressed,
      required this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: 'Sorry',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins'),
            ),
            TextSpan(
              text: ' !',
              style: TextStyle(
                color: Color(0xFFFBA500),
                fontSize: 28,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ])),
          if (errorMessage.contains("No Products"))
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: 'No Products',
                style: TextStyle(
                    color: Color(0xFFFBA500),
                    fontSize: 24,
                    fontFamily: 'Poppins'),
              ),
              TextSpan(
                text: ' are added to this store',
                style: TextStyle(
                    color: Colors.black, fontSize: 24, fontFamily: 'Poppins'),
              ),
            ])),
          if (!errorMessage.contains("No Products"))
            Text(
              errorMessage,
              style: TextStyle(
                  color: Colors.black, //Color(0xFFFBA500),
                  fontSize: 24,
                  fontFamily: 'Poppins'),
            ),
          SizedBox(height: 20),
          Image.asset('assets/no_products.png',
              width: (MediaQuery.of(context).size.width -
                      4 -
                      (MediaQuery.of(context).padding.left +
                          MediaQuery.of(context).padding.right)) *
                  0.7),
          SizedBox(height: 20),
          if (onRetryPressed != null)
            ElevatedButton(
              //color: Colors.white,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.green;
                }
                return Colors.white;
              })),
              child: Text(buttonText != null ? buttonText : 'Retry',
                  style: TextStyle(color: Colors.black)),
              onPressed: onRetryPressed,
            ),
        ],
      ),
    );
  }
}
