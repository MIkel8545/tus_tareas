import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:tus_tareas/models/models.dart';
import 'package:tus_tareas/pages/pages.dart';
import 'package:tus_tareas/services/services.dart';
import 'package:tus_tareas/services/team_service.dart';
import 'package:tus_tareas/widgets/widgets.dart';

import '../data/menu_items.dart';

class Teams extends StatelessWidget {
  const Teams({super.key});

  @override
  Widget build(BuildContext context) {
    final teamService = Provider.of<TeamService>(context);
    final authService = Provider.of<AuthService>(context);

    if (teamService.isLoading) return Loading();

    DateTime now = DateTime.now();
    initializeDateFormatting();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat.yMMMMd('es').format(now),
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
      body: ListView.builder(
          itemCount: teamService.teams.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () {
                  final team = teamService.selectedTeam =
                      teamService.teams[index].copy();
                  Navigator.pushNamed(context, 'incidence');
                },
                child: TeamCard(
                  team: teamService.teams[index],
                ),
              )),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          teamService.selectedTeam = new Team(nombre: 'Nuevo Equipo');
          Navigator.pushNamed(context, 'createTeam');
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
}
