import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
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
          itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () {
                  tasksService.selectedTask = tasksService.tasks[index].copy();
                  showSlidingBottomSheet(context,
                      builder: (context) => SlidingSheetDialog(
                            cornerRadius: 16,
                            color: Colors.black12,
                            avoidStatusBar: true,
                            snapSpec: SnapSpec(
                              initialSnap: 0.6,
                              snappings: [0.6, 0.7],
                            ),
                            builder: buildSheet,
                            headerBuilder: headerSheet,
                          ));
                },
                child: TaskCard(
                  task: tasksService.tasks[index],
                ),
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

  Widget buildSheet(context, state) => Material(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Nombre de la Tarea ', style: TextStyle(fontSize: 22)),
                  SizedBox(width: 105),
                  IconButton(
                      onPressed: (() {}), icon: Icon(Icons.more_vert_rounded))
                ],
              ),
              const Divider(
                height: 20,
                thickness: 1,
                color: Color.fromARGB(255, 184, 181, 181),
              ),
              Text('''Descripcion de la tarea''',
                  style: TextStyle(fontSize: 20), textAlign: TextAlign.start),
              SizedBox(height: 30),
              const Divider(
                height: 20,
                thickness: 1,
                color: Color.fromARGB(255, 184, 181, 181),
              ),
              Row(
                children: [
                  Text('Fecha :', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 50),
                  Text('fecha', style: TextStyle(fontSize: 18))
                ],
              ),
              const Divider(
                height: 20,
                thickness: 1,
                color: Color.fromARGB(255, 184, 181, 181),
              ),
              SizedBox(height: 300),
            ],
          ),
        ),
      );

  Widget headerSheet(context, state) => Material(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(height: 16),
          Center(
            child: Container(
              width: 32,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.indigo,
              ),
            ),
          ),
          SizedBox(height: 16),
        ]),
      );
}
