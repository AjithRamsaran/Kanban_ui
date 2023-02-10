import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:kanban_ui/model/organisation_response.dart';

import '../model/Tags.dart';
import '../model/TaskIds.dart';
import '../model/Users.dart';
import '../model/task.dart';
import 'package:http/http.dart' as http;

import 'CustomException.dart';

class KanbanApi {
  KanbanApi() {
    _getterBaseUrl =
        "https://7z55w2gwfh.execute-api.ap-south-1.amazonaws.com/v1/getter";
    _setterBaseUrl =
        "https://bkpsg10crd.execute-api.ap-south-1.amazonaws.com/v1/setter";
  }

  var _getterBaseUrl;
  var _setterBaseUrl;

  Future<dynamic> apiPostGetter(String body1) async {
    var responseJson;
    try {
      print(_getterBaseUrl);
      print(body1);
      final response = await http.post(
        Uri.parse(_getterBaseUrl),
        body: body1,
      );
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> apiPostSetter(String body1) async {
    var responseJson;
    try {
      print(_setterBaseUrl);
      log(body1);

      final response = await http.post(Uri.parse(_setterBaseUrl), body: body1);
      responseJson = _response(response);
    } on SocketException {
      //setFlag(false);
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    //print(response.statusCode);
    switch (response.statusCode) {
      case 200:
      case 201:
      case 504:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      //throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 500:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  Future<dynamic> getOrganization() async {
    var body = {"category": "organisation", "type": "getAllOrganisations"};
    final response = await this.apiPostGetter(jsonEncode(body));
    return response;
  }

  Future<dynamic> getBoards(num organisationId) async {
    var body = {
      "category": "board",
      "type": "getAllBoardsByOrganisationId",
      "organisationId": organisationId
    };
    final response = await this.apiPostGetter(jsonEncode(body));
    return response;
  }

  Future<dynamic> getAllTags() async {
    var body = {"category": "tag", "type": "getAllTags"};
    final response = await this.apiPostGetter(jsonEncode(body));
    return response;
  }

  Future<dynamic> getAllUsers() async {
    var body = {"category": "user", "type": "getAllUsers"};
    final response = await this.apiPostGetter(jsonEncode(body));
    return response;
  }

  Future<dynamic> createNewBoard(
      num organisationId, String description, String name, bool isEnd) async {
    var body = {
      "category": "board",
      "type": "createNewBoard",
      "name": name,
      "description": description,
      "companyId": organisationId,
      "isEnd": isEnd ? 1 : 0
    };
    final response = await this.apiPostSetter(jsonEncode(body));
    return response;
  }

  Future<dynamic> createNewTag() async {
    var body = {
      "category": "tag",
      "type": "createNewTag",
      "name": "Bug",
      "color": "Red"
    };
    final response = await this.apiPostSetter(jsonEncode(body));
    return response;
  }

  Future<dynamic> createNewOrganisation(String name) async {
    var body = {
      "category": "organisation",
      "type": "createNewOrganisation",
      "name": name,
      "description": "Organisation description",
      "details": "[]"
    };
    final response = await this.apiPostSetter(jsonEncode(body));
    return response;
  }

  Future<dynamic> createNewUser(String name, String title, String email,
      String phone, String country) async {
    var body = {
      "category": "user",
      "type": "createNewUser",
      "name": name,
      "title": title,
      "email": email,
      "phone": phone,
      "country": country
    };
    final response = await this.apiPostSetter(jsonEncode(body));
    return response;
  }

  Future<dynamic> createNewTask(String name, String description, List<Tag> tags,
      List<User> users, int boardId) async {
    var body = {
      "category": "task",
      "type": "createNewTask",
      "name": name,
      "description": description,
      "created_at": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
      "boardId": boardId,
      "tags": tags,
      "users": users
    };
    final response = await this.apiPostSetter(jsonEncode(body));
    return response;
  }

  Future<dynamic> updateTask(int taskId, String name, String description,
      List<Tag> tags, List<User> users, int boardId) async {
    var body = {
      "category": "task",
      "type": "updateTaskById",
      "id": taskId,
      "name": name,
      "description": description,
      "tags": tags,
      "users": users
    };
    final response = await this.apiPostSetter(jsonEncode(body));
    return response;
  }

  Future<dynamic> changeTaskByBoardId(
      String taskId, String boardId, String moveToBoardId) async {
    var body = {
      "category": "task",
      "type": "changeTaskByBoardId",
      "id": taskId,
      "boardId": boardId,
      "moveToBoardId": moveToBoardId
    };
    final response = await this.apiPostSetter(jsonEncode(body));
    return response;
  }

  Future<void> saveTasks(Task task) async {}

  Future<void> deleteTask(String id) async {}
}
