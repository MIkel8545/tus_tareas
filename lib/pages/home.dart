import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:tus_tareas/data/menu_items.dart';
import 'package:tus_tareas/data/menu_task.dart';
import 'package:tus_tareas/data/notifications.dart';
import 'package:tus_tareas/models/models.dart';
import 'package:tus_tareas/pages/pages.dart';
import 'package:tus_tareas/services/services.dart';
import 'package:tus_tareas/widgets/widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final tasksService = Provider.of<TaskService>(context);
    final authService = Provider.of<AuthService>(context);

    if (tasksService.isLoading) return Loading();

    DateTime now = DateTime.now();
    initializeDateFormatting();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hoy ' + DateFormat.MMMMd('es').format(now),
          style: TextStyle(
              color: Color.fromARGB(255, 115, 141, 228), fontSize: 23),
        ),
        actions: [
          PopupMenuButton<MenuItemModel>(
              onSelected: (item) => onSelectedMenu(context, item, authService),
              itemBuilder: (context) => [
                    ...MenuItems.itemsFirst.map(buildItem).toList(),
                    PopupMenuDivider(),
                    ...MenuItems.itemsSecond.map(buildItem).toList()
                  ])
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Text(
              'Vencidas',
              style: TextStyle(fontSize: 20),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: tasksService.vencidas.length,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                    onTap: () {
                      final task = tasksService.selectedTask =
                          tasksService.vencidas[index].copy();

                      final DateTime date;
                      date = DateTime.parse(task.fecha);

                      showSlidingBottomSheet(context,
                          builder: (context) => SlidingSheetDialog(
                                cornerRadius: 16,
                                color: Colors.black12,
                                avoidStatusBar: true,
                                snapSpec: SnapSpec(
                                  initialSnap: 0.6,
                                  snappings: [0.6, 0.7],
                                ),
                                builder: ((context, state) {
                                  return Material(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(task.titulo,
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              Spacer(),
                                              PopupMenuButton<MenuItemModel>(
                                                  onSelected: (item) =>
                                                      onSelectedMenuTask(
                                                          context,
                                                          item,
                                                          task,
                                                          tasksService),
                                                  itemBuilder: (context) => [
                                                        ...MenuTasks.itemsFirst
                                                            .map(buildItem)
                                                            .toList(),
                                                      ])
                                            ],
                                          ),
                                          const Divider(
                                            height: 20,
                                            thickness: 1,
                                            color: Color.fromARGB(
                                                255, 184, 181, 181),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                alignment: Alignment.centerLeft,
                                                onPressed: (() {}),
                                                icon: Icon(Icons.today),
                                                color: Colors.indigo,
                                              ),
                                              Text(
                                                  DateFormat.yMMMMd('es')
                                                      .format(date),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.indigo))
                                            ],
                                          ),
                                          const Divider(
                                            height: 20,
                                            thickness: 1,
                                            color: Color.fromARGB(
                                                255, 184, 181, 181),
                                          ),
                                          Text(
                                              task.detalles ??
                                                  'No tiene descripción',
                                              style: TextStyle(fontSize: 18),
                                              textAlign: TextAlign.start),
                                          SizedBox(height: 30),
                                          const Divider(
                                            height: 20,
                                            thickness: 1,
                                            color: Color.fromARGB(
                                                255, 184, 181, 181),
                                          ),
                                          TextButton(
                                              onPressed: (() async {
                                                TimeOfDay? picked =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay(
                                                      hour: date.hour,
                                                      minute: date.minute),
                                                );
                                                if (picked == null) return;
                                                DateTime? newDate =
                                                    await showDatePicker(
                                                        locale: const Locale(
                                                            'es', ''),
                                                        context: context,
                                                        initialDate: date,
                                                        firstDate:
                                                            DateTime(1900),
                                                        lastDate:
                                                            DateTime(2100));

                                                if (newDate == null) return;

                                                setState(() {
                                                  final dateTime = DateTime(
                                                      newDate.year,
                                                      newDate.month,
                                                      newDate.day,
                                                      picked.hour,
                                                      picked.minute);

                                                  //  date = dateTime;

                                                  createTaskReminderNotification(
                                                      dateTime);
                                                });
                                              }),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.alarm,
                                                    color: Colors.indigo,
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    'Crear Recordatorio',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              )),
                                          SizedBox(
                                            height: 200,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                headerBuilder: headerSheet,
                              ));
                    },
                    child: TaskCard(
                      task: tasksService.vencidas[index],
                    ),
                  )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Text(
              'Hoy',
              style: TextStyle(fontSize: 20),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: tasksService.hoy.length,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                    onTap: () {
                      final task = tasksService.selectedTask =
                          tasksService.hoy[index].copy();

                      final DateTime date;
                      date = DateTime.parse(task.fecha);

                      showSlidingBottomSheet(context,
                          builder: (context) => SlidingSheetDialog(
                                cornerRadius: 16,
                                color: Colors.black12,
                                avoidStatusBar: true,
                                snapSpec: SnapSpec(
                                  initialSnap: 0.6,
                                  snappings: [0.6, 0.7],
                                ),
                                builder: ((context, state) {
                                  return Material(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(task.titulo,
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              Spacer(),
                                              PopupMenuButton<MenuItemModel>(
                                                  onSelected: (item) =>
                                                      onSelectedMenuTask(
                                                          context,
                                                          item,
                                                          task,
                                                          tasksService),
                                                  itemBuilder: (context) => [
                                                        ...MenuTasks.itemsFirst
                                                            .map(buildItem)
                                                            .toList(),
                                                      ])
                                            ],
                                          ),
                                          const Divider(
                                            height: 20,
                                            thickness: 1,
                                            color: Color.fromARGB(
                                                255, 184, 181, 181),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                alignment: Alignment.centerLeft,
                                                onPressed: (() {}),
                                                icon: Icon(Icons.today),
                                                color: Colors.indigo,
                                              ),
                                              Text(
                                                  DateFormat.yMMMMd('es')
                                                      .format(date),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.indigo))
                                            ],
                                          ),
                                          const Divider(
                                            height: 20,
                                            thickness: 1,
                                            color: Color.fromARGB(
                                                255, 184, 181, 181),
                                          ),
                                          Text(
                                              task.detalles ??
                                                  'No tiene descripción',
                                              style: TextStyle(fontSize: 18),
                                              textAlign: TextAlign.start),
                                          SizedBox(height: 30),
                                          const Divider(
                                            height: 20,
                                            thickness: 1,
                                            color: Color.fromARGB(
                                                255, 184, 181, 181),
                                          ),
                                          TextButton(
                                              onPressed: (() async {
                                                TimeOfDay? picked =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay(
                                                      hour: date.hour,
                                                      minute: date.minute),
                                                );
                                                if (picked == null) return;
                                                DateTime? newDate =
                                                    await showDatePicker(
                                                        locale: const Locale(
                                                            'es', ''),
                                                        context: context,
                                                        initialDate: date,
                                                        firstDate:
                                                            DateTime(1900),
                                                        lastDate:
                                                            DateTime(2100));

                                                if (newDate == null) return;

                                                setState(() {
                                                  final dateTime = DateTime(
                                                      newDate.year,
                                                      newDate.month,
                                                      newDate.day,
                                                      picked.hour,
                                                      picked.minute);

                                                  //  date = dateTime;

                                                  createTaskReminderNotification(
                                                      dateTime);
                                                });
                                              }),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.alarm,
                                                    color: Colors.indigo,
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    'Crear Recordatorio',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              )),
                                          const Divider(
                                            height: 20,
                                            thickness: 1,
                                            color: Color.fromARGB(
                                                255, 184, 181, 181),
                                          ),
                                          SizedBox(
                                            height: 200,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                headerBuilder: headerSheet,
                              ));
                    },
                    child: TaskCard(
                      task: tasksService.hoy[index],
                    ),
                  )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Text(
              'Completadas',
              style: TextStyle(fontSize: 20),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: tasksService.completadas.length,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                    onTap: () {
                      final task = tasksService.selectedTask =
                          tasksService.completadas[index].copy();

                      final DateTime date;
                      date = DateTime.parse(task.fecha);

                      showSlidingBottomSheet(context,
                          builder: (context) => SlidingSheetDialog(
                                cornerRadius: 16,
                                color: Colors.black12,
                                avoidStatusBar: true,
                                snapSpec: SnapSpec(
                                  initialSnap: 0.6,
                                  snappings: [0.6, 0.7],
                                ),
                                builder: ((context, state) {
                                  return Material(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                task.titulo,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              Spacer(),
                                              PopupMenuButton<MenuItemModel>(
                                                  onSelected: (item) =>
                                                      onSelectedMenuTask(
                                                          context,
                                                          item,
                                                          task,
                                                          tasksService),
                                                  itemBuilder: (context) => [
                                                        ...MenuTasks.itemsFirst
                                                            .map(buildItem)
                                                            .toList(),
                                                      ])
                                            ],
                                          ),
                                          const Divider(
                                            height: 20,
                                            thickness: 1,
                                            color: Color.fromARGB(
                                                255, 184, 181, 181),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                alignment: Alignment.centerLeft,
                                                onPressed: (() {}),
                                                icon: Icon(Icons.today),
                                                color: Colors.indigo,
                                              ),
                                              Text(
                                                  DateFormat.yMMMMd('es')
                                                      .format(date),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.indigo))
                                            ],
                                          ),
                                          const Divider(
                                            height: 20,
                                            thickness: 1,
                                            color: Color.fromARGB(
                                                255, 184, 181, 181),
                                          ),
                                          Text(
                                              task.detalles ??
                                                  'No tiene descripción',
                                              style: TextStyle(fontSize: 18),
                                              textAlign: TextAlign.start),
                                          SizedBox(height: 30),
                                          const Divider(
                                            height: 20,
                                            thickness: 1,
                                            color: Color.fromARGB(
                                                255, 184, 181, 181),
                                          ),
                                          TextButton(
                                              onPressed: (() async {
                                                TimeOfDay? picked =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay(
                                                      hour: date.hour,
                                                      minute: date.minute),
                                                );
                                                if (picked == null) return;
                                                DateTime? newDate =
                                                    await showDatePicker(
                                                        locale: const Locale(
                                                            'es', ''),
                                                        context: context,
                                                        initialDate: date,
                                                        firstDate:
                                                            DateTime(1900),
                                                        lastDate:
                                                            DateTime(2100));

                                                if (newDate == null) return;

                                                setState(() {
                                                  final dateTime = DateTime(
                                                      newDate.year,
                                                      newDate.month,
                                                      newDate.day,
                                                      picked.hour,
                                                      picked.minute);

                                                  //  date = dateTime;

                                                  createTaskReminderNotification(
                                                      dateTime);
                                                });
                                              }),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.alarm,
                                                    color: Colors.indigo,
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    'Crear Recordatorio',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              )),
                                          const Divider(
                                            height: 20,
                                            thickness: 1,
                                            color: Color.fromARGB(
                                                255, 184, 181, 181),
                                          ),
                                          SizedBox(
                                            height: 200,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                headerBuilder: headerSheet,
                              ));
                    },
                    child: CompleteTaskCard(
                      task: tasksService.completadas[index],
                    ),
                  )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          DateTime date = DateTime.now();
          tasksService.selectedTask = new Tasks(
              estado: 'pendiente',
              detalles: 'Detalles de la Tarea',
              fecha: DateFormat('yyyy-MM-dd').format(date),
              titulo: 'Nueva Tarea');
          Navigator.pushNamed(context, 'task');
        },
      ),
    );
  }

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

  PopupMenuItem<MenuItemModel> buildItem(MenuItemModel item) =>
      PopupMenuItem<MenuItemModel>(
          value: item,
          child: Row(
            children: [
              Icon(item.icon),
              SizedBox(width: 10),
              Text(
                item.text,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ));

  void onSelectedMenu(
      BuildContext context, MenuItemModel item, AuthService authService) {
    switch (item) {
      case MenuItems.itemSettings:
        print('Prueba Menu Top bar');
        break;
      case MenuItems.itemSignOut:
        authService.logout();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()), (route) => false);
        break;
    }
  }

  Future<void> onSelectedMenuTask(BuildContext context, MenuItemModel item,
      Tasks task, TaskService taskService) async {
    switch (item) {
      case MenuTasks.itemUpdate:
        taskService.selectedTask = task;
        Navigator.pushNamed(context, 'task');
        break;
      case MenuTasks.itemDelete:
        await taskService.onDeleteTask(task);
        Navigator.of(context).pop();
        break;
    }
  }
}
