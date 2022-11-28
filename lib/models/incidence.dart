// To parse this JSON data, do
//
//     final insidence = insidenceFromMap(jsonString);

import 'dart:convert';

class Incidence {
  Incidence({
    this.id,
    this.detalles,
    required this.estado,
    required this.fecha,
    required this.responable,
    required this.titulo,
  });
  String? id;
  String? detalles;
  String estado;
  String fecha;
  String responable;
  String titulo;

  factory Incidence.fromJson(String str) => Incidence.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Incidence.fromMap(Map<String, dynamic> json) => Incidence(
        detalles: json["Detalles"],
        estado: json["Estado"],
        fecha: json["Fecha"],
        responable: json["Responable"],
        titulo: json["Titulo"],
      );

  Map<String, dynamic> toMap() => {
        "Detalles": detalles,
        "Estado": estado,
        "Fecha": fecha,
        "Responable": responable,
        "Titulo": titulo,
      };

  Incidence copy() => Incidence(
      responable: this.responable,
      detalles: this.detalles,
      estado: this.estado,
      fecha: this.fecha,
      titulo: this.titulo,
      id: this.id);
}
