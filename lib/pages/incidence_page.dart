import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:tus_tareas/data/menu_incidence.dart';
import 'package:tus_tareas/models/models.dart';
import 'package:tus_tareas/pages/pages.dart';
import 'package:tus_tareas/services/services.dart';
import 'package:tus_tareas/widgets/complete_incidence_card.dart';
import 'package:tus_tareas/widgets/widgets.dart';

import '../data/menu_items.dart';
import '../data/menu_task.dart';
import '../data/notifications.dart';

class IncidencePage extends StatefulWidget {
  const IncidencePage({super.key});

  @override
  State<IncidencePage> createState() => _IncidencePageState();
}

class _IncidencePageState extends State<IncidencePage> {
  @override
  Widget build(BuildContext context) {
    final incidenceService = Provider.of<IncidenceService>(context);
    final authService = Provider.of<AuthService>(context);

    if (incidenceService.isLoading) return Loading();

    DateTime now = DateTime.now();
    initializeDateFormatting();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Incidencias',
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
              'Asignadas',
              style: TextStyle(fontSize: 20),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: incidenceService.incidences.length,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                    onTap: () {
                      final incidence = incidenceService.selectedIncidence =
                          incidenceService.incidences[index].copy();

                      final DateTime date;
                      date = DateTime.parse(incidence.fecha);

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
                                              Text(incidence.titulo,
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              Spacer(),
                                              PopupMenuButton<MenuItemModel>(
                                                  onSelected: (item) =>
                                                      onSelectedMenuIncidence(
                                                          context,
                                                          item,
                                                          incidence,
                                                          incidenceService),
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
                                              incidence.detalles ??
                                                  'Detalles de la Incidencia',
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
                                            height: 30,
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
                    child: IncidenceCard(
                      task: incidenceService.incidences[index],
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
              itemCount: incidenceService.completadas.length,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                    onTap: () {
                      final incidence = incidenceService.selectedIncidence =
                          incidenceService.completadas[index].copy();

                      final DateTime date;
                      date = DateTime.parse(incidence.fecha);

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
                                              Text(incidence.titulo,
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              Spacer(),
                                              PopupMenuButton<MenuItemModel>(
                                                  onSelected: (item) =>
                                                      onSelectedMenuIncidence(
                                                          context,
                                                          item,
                                                          incidence,
                                                          incidenceService),
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
                                              incidence.detalles ??
                                                  'Detalles de la Incidencia',
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
                                            height: 30,
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
                    child: CompleteIncidenceCard(
                      task: incidenceService.completadas[index],
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
          incidenceService.selectedIncidence = new Incidence(
              detalles: '''Detalles de la Incidencia''',
              responable: 'ejemplo@gmail.com',
              estado: 'asignada',
              fecha: DateFormat('yyyy-MM-dd').format(date),
              titulo: 'Nueva Incidencia');
          Navigator.pushNamed(context, 'createIncidence');
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
}

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

Future<void> onSelectedMenuIncidence(BuildContext context, MenuItemModel item,
    Incidence incidence, IncidenceService incidenceService) async {
  switch (item) {
    case MenuTasks.itemUpdate:
      incidenceService.selectedIncidence = incidence;
      Navigator.pushNamed(context, 'createIncidence');
      break;
    case MenuTasks.itemDelete:
      await incidenceService.onDeleteIncidence(incidence);
      Navigator.of(context).pop();
      break;
  }
}
