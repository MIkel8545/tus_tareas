// To parse this JSON data, do
//
//     final task = taskFromMap(jsonString);

import 'dart:convert';

class Tasks {
  Tasks(
      {required this.estado,
      required this.fecha,
      required this.titulo,
      this.detalles,
      this.id});

  String estado;
  String? detalles;
  String fecha;
  String titulo;
  String? id;

  factory Tasks.fromJson(String str) => Tasks.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Tasks.fromMap(Map<String, dynamic> json) => Tasks(
      estado: json["Estado"],
      fecha: json["Fecha"],
      titulo: json["Titulo"],
      detalles: json["Detalles"]);

  Map<String, dynamic> toMap() => {
        "Estado": estado,
        "Fecha": fecha,
        "Titulo": titulo,
        "Detalles": detalles,
      };

  Tasks copy() => Tasks(
      estado: this.estado,
      fecha: this.fecha,
      detalles: this.detalles,
      titulo: this.titulo,
      id: this.id);
}
