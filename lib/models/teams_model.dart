// To parse this JSON data, do
//
//     final team = teamFromMap(jsonString);

import 'dart:convert';

class Team {
  Team({required this.nombre, this.id});

  String nombre;
  String? id;

  factory Team.fromJson(String str) => Team.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Team.fromMap(Map<String, dynamic> json) => Team(
        nombre: json["nombre"],
      );

  Map<String, dynamic> toMap() => {
        "nombre": nombre,
      };
  Team copy() => Team(nombre: this.nombre, id: this.id);
}
