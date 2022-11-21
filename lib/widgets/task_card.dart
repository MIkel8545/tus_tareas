import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tus_tareas/models/models.dart';

class TaskCard extends StatelessWidget {
  final Tasks task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    bool isChecked = false;
    final DateTime date;
    date = DateTime.parse(task.fecha);
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
              children: [
                Checkbox(
                  shape: CircleBorder(),
                  value: isChecked,
                  onChanged: (bool? value) {
                    SetState(() {
                      isChecked = value!;
                    });
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  task.titulo,
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.start,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.indigo,
                      size: 18,
                    ),
                    SizedBox(width: 10),
                    Text(
                      DateFormat.MMMMd('es').format(date),
                      style: TextStyle(
                          color: Color.fromARGB(255, 115, 141, 228),
                          fontSize: 20),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
      color: Color.fromARGB(255, 41, 41, 41),
      borderRadius: BorderRadius.circular(10));

  void SetState(Null Function() param0) {}
}
