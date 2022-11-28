import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tus_tareas/models/models.dart';

class TeamCard extends StatelessWidget {
  final Team team;

  const TeamCard({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    String nombre = team.nombre.substring(0, 1);
    bool isChecked = false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
          margin: EdgeInsets.only(top: 20),
          width: double.infinity,
          height: 70,
          decoration: _cardBorders(),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.centerLeft,
                children: [],
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            child: Text(nombre),
                            backgroundColor: Colors.primaries[
                                Random().nextInt(Colors.primaries.length)],
                          ),
                          SizedBox(width: 10),
                          Text(
                            team.nombre,
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ])
            ],
          )),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
      color: Color.fromARGB(255, 41, 41, 41),
      borderRadius: BorderRadius.circular(10));
}
