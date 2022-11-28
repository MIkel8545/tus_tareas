import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tus_tareas/models/models.dart';
import 'package:http/http.dart' as http;

class TaskService extends ChangeNotifier {
  final String _baseUrl = 'tareasapp-120e6-default-rtdb.firebaseio.com';

  final List<Tasks> tasks = [];
  final List<Tasks> vencidas = [];
  final List<Tasks> pendientes = [];
  final List<Tasks> hoy = [];
  final List<Tasks> completadas = [];
  late Tasks selectedTask;

  bool isLoading = true;
  bool isSaving = false;

  TaskService() {
    this.loadTasks();
    this.loadVencidas();
    this.loadPendientes();
    this.loadHoy();
    loadCompletadas();
  }

  Future<List<Tasks>> loadCompletadas() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'tareas.json');
    final resp = await http.get(url);

    final Map<String, dynamic> tasksMap = json.decode(resp.body);
    print(tasksMap);

    tasksMap.forEach((key, value) {
      final tempTask = Tasks.fromMap(value);
      tempTask.id = key;

      if (tempTask.estado == 'completada') {
        this.completadas.add(tempTask);
      }
    });

    this.isLoading = false;
    notifyListeners();

    return this.tasks;
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
  }

  Future<List<Tasks>> loadVencidas() async {
    DateTime now = DateTime.now().toUtc();
    var d1 = DateTime.utc(now.year, now.month, now.day);
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'tareas.json');
    final resp = await http.get(url);

    final Map<String, dynamic> tasksMap = json.decode(resp.body);
    print(tasksMap);

    tasksMap.forEach((key, value) {
      final tempTask = Tasks.fromMap(value);
      tempTask.id = key;
      DateTime dt2 = DateTime.parse(tempTask.fecha);

      if (tempTask.estado == 'pendiente') {
        if (dt2.compareTo(d1) < 0) {
          this.vencidas.add(tempTask);
        }
      }
    });

    this.isLoading = false;
    notifyListeners();

    return this.vencidas;
  }

  Future<List<Tasks>> loadPendientes() async {
    DateTime now = DateTime.now().toUtc();
    var d1 = DateTime.utc(now.year, now.month, now.day);

    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'tareas.json');
    final resp = await http.get(url);

    final Map<String, dynamic> tasksMap = json.decode(resp.body);
    print(tasksMap);

    tasksMap.forEach((key, value) {
      final tempTask = Tasks.fromMap(value);
      tempTask.id = key;
      DateTime dt2 = DateTime.parse(tempTask.fecha);

      if (tempTask.estado == 'pendiente') {
        if (dt2.compareTo(d1) > 0) {
          this.pendientes.add(tempTask);
        }
      }
    });

    this.isLoading = false;
    notifyListeners();

    return this.pendientes;
  }

  Future<List<Tasks>> loadHoy() async {
    DateTime now = DateTime.now();

    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'tareas.json');
    final resp = await http.get(url);

    final Map<String, dynamic> tasksMap = json.decode(resp.body);
    print(tasksMap);

    tasksMap.forEach((key, value) {
      final tempTask = Tasks.fromMap(value);
      tempTask.id = key;
      DateTime dt2 = DateTime.parse(tempTask.fecha);

      if (tempTask.estado == 'pendiente') {
        if (dt2.day == now.day &&
            dt2.month == now.month &&
            dt2.year == now.year) {
          this.hoy.add(tempTask);
        }
      }
    });

    this.isLoading = false;
    notifyListeners();

    return this.hoy;
  }

  Future onUncompleteTasks(Tasks task) async {
    DateTime now = DateTime.now().toUtc();
    var d1 = DateTime.utc(now.year, now.month, now.day);
    isSaving = true;
    notifyListeners();

    DateTime dt2 = DateTime.parse(task.fecha);

    if (task.estado == 'pendiente') {
      if (dt2.compareTo(d1) < 0) {
        await this.uncompleteVencidaTask(task);
      }

      if (dt2.day == now.day &&
          dt2.month == now.month &&
          dt2.year == now.year) {
        await this.uncompleteHoyTask(task);
      }
      if (dt2.compareTo(d1) > 0) {
        await this.uncompletePendienteTask(task);
      }
    }

    isSaving = false;
    notifyListeners();
  }

  Future onCompleteTasks(Tasks task) async {
    DateTime now = DateTime.now().toUtc();
    var d1 = DateTime.utc(now.year, now.month, now.day);
    isSaving = true;
    notifyListeners();

    DateTime dt2 = DateTime.parse(task.fecha);

    if (task.estado == 'completada') {
      if (dt2.compareTo(d1) < 0) {
        await this.completeVencidaTask(task);
      }

      if (dt2.day == now.day &&
          dt2.month == now.month &&
          dt2.year == now.year) {
        await this.completeHoyTask(task);
      }
      if (dt2.compareTo(d1) > 0) {
        await this.completePendienteTask(task);
      }
    }

    isSaving = false;
    notifyListeners();
  }

  Future onDeleteTask(Tasks task) async {
    DateTime now = DateTime.now().toUtc();
    var d1 = DateTime.utc(now.year, now.month, now.day);
    isSaving = true;
    notifyListeners();

    DateTime dt2 = DateTime.parse(task.fecha);

    if (task.estado == 'pendiente') {
      if (dt2.compareTo(d1) < 0) {
        await this.deleteVencida(task);
      }

      if (dt2.day == now.day &&
          dt2.month == now.month &&
          dt2.year == now.year) {
        await this.deleteHoy(task);
      }
      if (dt2.compareTo(d1) > 0) {
        await this.deletePendiente(task);
      }
    } else {
      await this.deleteCompletada(task);
    }

    isSaving = false;
    notifyListeners();
  }

  Future saveOnCreateTask(Tasks task) async {
    DateTime now = DateTime.now().toUtc();
    var d1 = DateTime.utc(now.year, now.month, now.day);
    isSaving = true;
    notifyListeners();
    if (task.id == null) {
      DateTime dt2 = DateTime.parse(task.fecha);

      if (dt2.compareTo(d1) < 0) {
        await this.createVencida(task);
      }

      if (dt2.day == now.day &&
          dt2.month == now.month &&
          dt2.year == now.year) {
        await this.createHoy(task);
      }
      if (dt2.compareTo(d1) > 0) {
        await this.createPendiente(task);
      }
    } else {
      DateTime dt2 = DateTime.parse(task.fecha);

      if (dt2.compareTo(d1) < 0) {
        await this.updateVencida(task);
      }

      if (dt2.day == now.day &&
          dt2.month == now.month &&
          dt2.year == now.year) {
        await this.updateHoy(task);
      }
      if (dt2.compareTo(d1) > 0) {
        await this.updatePendiente(task);
      }
    }
    isSaving = false;
    notifyListeners();
  }

  Future<String> deleteTask(Tasks task) async {
    final url = Uri.https(_baseUrl, 'tareas/${task.id}.json');
    final resp = await http.delete(url, body: task.toJson());
    final decodedData = resp.body;

    final index = this.tasks.indexWhere((element) => element.id == task.id);
    this.tasks.remove(task);
    return task.id!;
  }

  Future<String> deleteCompletada(Tasks task) async {
    final url = Uri.https(_baseUrl, 'tareas/${task.id}.json');
    final resp = await http.delete(url, body: task.toJson());
    final decodedData = resp.body;
    final index =
        this.completadas.indexWhere((element) => element.id == task.id);

    this.completadas.removeAt(index);

    notifyListeners();

    vencidas.forEach((value) {
      final tempTask = value.titulo;
      print(tempTask);
    });

    return task.id!;
  }

  Future<String> uncompleteVencidaTask(Tasks task) async {
    final url = Uri.https(_baseUrl, 'tareas/${task.id}.json');
    final resp = await http.put(url, body: task.toJson());
    final decodedData = resp.body;
    final index =
        this.completadas.indexWhere((element) => element.id == task.id);

    completadas.forEach((value) {
      final tempTask = value.titulo;
      print(tempTask);
    });
    this.vencidas.add(task);
    this.completadas.removeAt(index);
    return task.id!;
  }

  Future<String> uncompleteHoyTask(Tasks task) async {
    final url = Uri.https(_baseUrl, 'tareas/${task.id}.json');
    final resp = await http.put(url, body: task.toJson());
    final decodedData = resp.body;
    final index =
        this.completadas.indexWhere((element) => element.id == task.id);

    completadas.forEach((value) {
      final tempTask = value.titulo;
      print(tempTask);
    });
    this.hoy.add(task);
    this.completadas.removeAt(index);
    return task.id!;
  }

  Future<String> uncompletePendienteTask(Tasks task) async {
    final url = Uri.https(_baseUrl, 'tareas/${task.id}.json');
    final resp = await http.put(url, body: task.toJson());
    final decodedData = resp.body;
    final index =
        this.pendientes.indexWhere((element) => element.id == task.id);

    pendientes.forEach((value) {
      final tempTask = value.titulo;
      print(tempTask);
    });
    this.pendientes.add(task);
    this.completadas.removeAt(index);
    return task.id!;
  }

  Future<String> completeVencidaTask(Tasks task) async {
    final url = Uri.https(_baseUrl, 'tareas/${task.id}.json');
    final resp = await http.put(url, body: task.toJson());
    final decodedData = resp.body;
    final index = this.vencidas.indexWhere((element) => element.id == task.id);

    vencidas.forEach((value) {
      final tempTask = value.titulo;
      print(tempTask);
    });
    this.completadas.add(task);
    this.vencidas.removeAt(index);
    return task.id!;
  }

  Future<String> completeHoyTask(Tasks task) async {
    final url = Uri.https(_baseUrl, 'tareas/${task.id}.json');
    final resp = await http.put(url, body: task.toJson());
    final decodedData = resp.body;
    final index = this.hoy.indexWhere((element) => element.id == task.id);

    hoy.forEach((value) {
      final tempTask = value.titulo;
      print(tempTask);
    });
    this.completadas.add(task);
    this.hoy.removeAt(index);
    return task.id!;
  }

  Future<String> completePendienteTask(Tasks task) async {
    final url = Uri.https(_baseUrl, 'tareas/${task.id}.json');
    final resp = await http.put(url, body: task.toJson());
    final decodedData = resp.body;
    final index =
        this.pendientes.indexWhere((element) => element.id == task.id);

    vencidas.forEach((value) {
      final tempTask = value.titulo;
      print(tempTask);
    });
    this.completadas.add(task);
    this.pendientes.removeAt(index);
    return task.id!;
  }

  Future<String> deleteVencida(Tasks task) async {
    final url = Uri.https(_baseUrl, 'tareas/${task.id}.json');
    final resp = await http.delete(url, body: task.toJson());
    final decodedData = resp.body;
    final index = this.vencidas.indexWhere((element) => element.id == task.id);

    this.vencidas.removeAt(index);

    notifyListeners();

    vencidas.forEach((value) {
      final tempTask = value.titulo;
      print(tempTask);
    });

    return task.id!;
  }

  Future<String> deletePendiente(Tasks task) async {
    final url = Uri.https(_baseUrl, 'tareas/${task.id}.json');
    final resp = await http.delete(url, body: task.toJson());
    final decodedData = resp.body;

    final index =
        this.pendientes.indexWhere((element) => element.id == task.id);
    this.pendientes.removeAt(index);
    return task.id!;
  }

  Future<String> deleteHoy(Tasks task) async {
    final url = Uri.https(_baseUrl, 'tareas/${task.id}.json');
    final resp = await http.delete(url, body: task.toJson());
    final decodedData = resp.body;

    final index = this.hoy.indexWhere((element) => element.id == task.id);
    this.hoy.remove(task);
    return task.id!;
  }

  Future<String> updateTask(Tasks task) async {
    final url = Uri.https(_baseUrl, 'tareas/${task.id}.json');
    final resp = await http.put(url, body: task.toJson());
    final decodedData = resp.body;

    final index = this.tasks.indexWhere((element) => element.id == task.id);
    this.tasks[index] = task;
    return task.id!;
  }

  Future<String> updateVencida(Tasks task) async {
    final url = Uri.https(_baseUrl, 'tareas/${task.id}.json');
    final resp = await http.put(url, body: task.toJson());
    final decodedData = resp.body;

    final index = this.vencidas.indexWhere((element) => element.id == task.id);
    this.vencidas[index] = task;
    return task.id!;
  }

  Future<String> updateHoy(Tasks task) async {
    final url = Uri.https(_baseUrl, 'tareas/${task.id}.json');
    final resp = await http.put(url, body: task.toJson());
    final decodedData = resp.body;

    final index = this.hoy.indexWhere((element) => element.id == task.id);
    this.hoy[index] = task;
    return task.id!;
  }

  Future<String> updatePendiente(Tasks task) async {
    final url = Uri.https(_baseUrl, 'tareas/${task.id}.json');
    final resp = await http.put(url, body: task.toJson());
    final decodedData = resp.body;

    final index =
        this.pendientes.indexWhere((element) => element.id == task.id);
    this.pendientes[index] = task;
    return task.id!;
  }

  Future<String> createTask(Tasks task) async {
    final url = Uri.https(_baseUrl, 'tareas.json');
    final resp = await http.post(url, body: task.toJson());
    final decodedData = json.decode(resp.body);

    task.id = decodedData['name'];

    this.tasks.add(task);
    return task.id!;
  }

  Future<String> createVencida(Tasks task) async {
    final url = Uri.https(_baseUrl, 'tareas.json');
    final resp = await http.post(url, body: task.toJson());
    final decodedData = json.decode(resp.body);

    task.id = decodedData['name'];

    this.vencidas.add(task);
    return task.id!;
  }

  Future<String> createPendiente(Tasks task) async {
    final url = Uri.https(_baseUrl, 'tareas.json');
    final resp = await http.post(url, body: task.toJson());
    final decodedData = json.decode(resp.body);

    task.id = decodedData['name'];

    this.pendientes.add(task);
    return task.id!;
  }

  Future<String> createHoy(Tasks task) async {
    final url = Uri.https(_baseUrl, 'tareas.json');
    final resp = await http.post(url, body: task.toJson());
    final decodedData = json.decode(resp.body);

    task.id = decodedData['name'];

    this.hoy.add(task);
    return task.id!;
  }
}
