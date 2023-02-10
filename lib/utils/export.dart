import 'dart:io';

import 'package:csv/csv.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';
import 'dart:convert' show utf8;

// ignore: avoid_web_libraries_in_flutter

import '../model/Data.dart';
import '../model/Tags.dart';
import '../model/TaskIds.dart';
import '../model/Users.dart';

class Export {
  static Future<String> getCsv(
      List<Board> boards, List<User> users, List<Tag> tags) async {
    var baseDir;

    if (Platform.isAndroid) {
      baseDir = (await getExternalStorageDirectory());
    } else if (Platform.isIOS) {
      baseDir = (await getApplicationDocumentsDirectory());
    }
    print("File path: " + (baseDir?.path ?? ""));
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    var dirToBeCreated = "Kanban";
    String finalDir = join(baseDir?.path ?? "", dirToBeCreated);
    var directory = Directory(finalDir);
    print(directory.path);
    if (directory != null) {
      if (!(await directory.exists())) {
        await directory.create();
      }
    }

    String dir = (await getExternalStorageDirectory())?.absolute.path ??
        (await getApplicationDocumentsDirectory()).absolute.path;
    var file = "$dir";
    print(" FILE " + file);
    DateTime dateTime = DateTime.now();
    String fileName = "/KanbanBoard${dateTime.millisecond}.csv";
    File f = File(directory.path + fileName);
// convert rows to String and write as csv file
    List<List<dynamic>> rows = <List<dynamic>>[];

    rows.add(["Tag details"]);
    rows.add(["Id", "Tag Name", "Color"]);
    for (Tag tag in tags) {
      List<dynamic> row = [];
      row.add(tag.id);
      row.add(tag.name);
      row.add(tag.color);
      rows.add(row);
    }

    for (int i = 0; i < 5; i++) {
      rows.add([]);
    }

    rows.add(["User details"]);
    rows.add(["Id", "User Name", "Email", "Country", "Phone"]);
    for (User user in users) {
      List<dynamic> row = [];
      row.add(user.id);
      row.add(user.name);
      row.add(user.email);
      row.add(user.country);
      row.add(user.phone);
      rows.add(row);
    }

    for (int i = 0; i < 5; i++) {
      rows.add([]);
    }
    rows.add(["Boards"]);

    rows.add(["Id", "Board Name", "Description", "Company Id", "Task Ids"]);
    for (Board board in boards) {
      List<dynamic> row = [];
      row.add(board.id);
      row.add(board.name);
      row.add(board.description);
      row.add(board.companyId);
      if (board != null && board.taskIds != null) {
        /*for (Task? task in board.taskIds ?? []) {
          taskIds.add((task?.id ?? 0).toString());
        }*/
        row.add(board.taskIds?.map((e) => e?.id).toList());
      }
      rows.add(row);
    }

    for (int i = 0; i < 5; i++) {
      rows.add([]);
    }

    rows.add(["Task details"]);

    rows.add([
      "Id",
      "Task Name",
      "Description",
      "Board Id",
      "User Ids",
      "Tag Ids",
      "Created At",
      "End At",
      "Total time spent"
    ]);
    for (Board board in boards) {
      if (board != null && board.taskIds != null) {
        for (Task? task in board.taskIds ?? []) {
          List<dynamic> row = [];
          row.add((task?.id ?? 0).toString());
          row.add(task?.name);
          row.add(task?.description);
          row.add(board.id.toString());
          row.add(task?.users?.map((e) => e.id).toList());
          row.add(task?.tags?.map((e) => e.id).toList());
          row.add(task?.createdAt);
          row.add(task?.endTime);
          row.add(task?.totalTimeSpent);
          rows.add(row);
        }
      }
    }

    String csv = const ListToCsvConverter().convert(rows);
    await f.writeAsString(csv);

    try {
      OpenFile.open(directory.path + fileName);
    } catch (e) {
      print("Error : " + e.toString());
    }
    return directory.path + fileName;
  }
}
