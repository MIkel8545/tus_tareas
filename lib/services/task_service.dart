import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tus_tareas/models/models.dart';
import 'package:http/http.dart' as http;

class TaskService extends ChangeNotifier {
  final String _baseUrl = 'tareasapp-120e6-default-rtdb.firebaseio.com';

  final List<Tasks> tasks = [];
  late Tasks selectedTask;

  bool isLoading = true;

  TaskService() {
    this.loadTasks();
  }

  Future<List<Tasks>> loadTasks() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'tareas.json');
    final resp = await http.get(url);

    final Map<String, dynamic> tasksMap = json.decode(resp.body);
    print(tasksMap);

    tasksMap.forEach((key, value) {
      final tempTask = Tasks.fromMap(value);
      tempTask.id = key;
      this.tasks.add(tempTask);
    });

    this.isLoading = false;
    notifyListeners();

    return this.tasks;

    //print(this.tasks[0].titulo);
  }
}
