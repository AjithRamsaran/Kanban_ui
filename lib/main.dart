import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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

import 'package:kanban_ui/networking/kanban_apis.dart';
import 'package:kanban_ui/repository/kanban_repository.dart';
import 'package:kanban_ui/utils/color_util.dart';
import 'package:kanban_ui/utils/string_utils.dart';
import 'package:kanban_ui/widgets/custom_dropdown.dart';
import 'package:kanban_ui/widgets/error.dart';
import 'package:kanban_ui/widgets/kanban_board_view.dart';
import 'package:kanban_ui/widgets/nameIcon.dart';
import 'package:kanban_ui/widgets/tag_view.dart';

import 'model/Data.dart';
import 'model/Tags.dart';
import 'model/TaskIds.dart';
import 'model/Users.dart';

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
              KanbanBoardView() //Drag() //SampleDemo()//MyHomePage(title: 'Flutter Demo Home Page'),
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
                                      ChipView(
                                        tags: selectedTagList,
                                        deletableTag: true,
                                        refreshUI: () {},
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
