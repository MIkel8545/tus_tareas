import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tus_tareas/models/models.dart';

import '../services/services.dart';

class CompleteTaskCard extends StatefulWidget {
  final Tasks task;

  const CompleteTaskCard({super.key, required this.task});

  @override
  State<CompleteTaskCard> createState() => _CompleteTaskCardState();
}

class _CompleteTaskCardState extends State<CompleteTaskCard> {
  @override
  Widget build(BuildContext context) {
    final tasksService = Provider.of<TaskService>(context);
    final authService = Provider.of<AuthService>(context);
    bool isChecked = true;
    final DateTime date;
    date = DateTime.parse(widget.task.fecha);
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
                  activeColor: Colors.indigo,
                  shape: CircleBorder(),
                  value: isChecked,
                  onChanged: (bool? value) async {
                    setState(() {
                      isChecked = value!;
                      print(widget.task.estado);
                    });
                    widget.task.estado = 'pendiente';
                    print(widget.task.estado);

                    await tasksService.onUncompleteTasks(widget.task);
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.task.titulo,
                  style: TextStyle(
                      fontSize: 18, decoration: TextDecoration.lineThrough),
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
                          decoration: TextDecoration.lineThrough,
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
