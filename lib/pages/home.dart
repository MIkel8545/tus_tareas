import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:tus_tareas/pages/pages.dart';
import 'package:tus_tareas/services/services.dart';
import 'package:tus_tareas/widgets/widgets.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final tasksService = Provider.of<TaskService>(context);

    if (tasksService.isLoading) return Loading();

    DateTime now = DateTime.now();
    initializeDateFormatting();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat.yMMMMd('es').format(now),
          style: TextStyle(
              color: Color.fromARGB(255, 115, 141, 228), fontSize: 23),
        ),
        actions: [IconButton(onPressed: (() {}), icon: Icon(Icons.menu))],
      ),
      body: ListView.builder(
          itemCount: tasksService.tasks.length,
          itemBuilder: (BuildContext context, int index) => TaskCard(
                task: tasksService.tasks[index],
              )),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, 'task');
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Equipos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Tareas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'Calendario'),
        ],
        selectedItemColor: Colors.indigo,
        backgroundColor: Colors.black,
      ),
    );
  }
}
