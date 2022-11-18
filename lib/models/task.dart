// To parse this JSON data, do
//
//     final task = taskFromMap(jsonString);

import 'dart:convert';

/*
class Task {
  Task({
    required this.objTask,
  });

  Tasks objTask;

  factory Task.fromJson(String str) => Task.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        objTask: Tasks.fromMap(json["TASK001"]),
      );

  Map<String, dynamic> toMap() => {
        "TASK001": objTask.toMap(),
      };
} */

class Tasks {
  Tasks({
    required this.estado,
    required this.fecha,
    required this.titulo,
  });

  String estado;
  String fecha;
  String titulo;
  String? id;

  factory Tasks.fromJson(String str) => Tasks.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Tasks.fromMap(Map<String, dynamic> json) => Tasks(
        estado: json["Estado"],
        fecha: json["Fecha"],
        titulo: json["Titulo"],
      );

  Map<String, dynamic> toMap() => {
        "Estado": estado,
        "Fecha": fecha,
        "Titulo": titulo,
      };
}
