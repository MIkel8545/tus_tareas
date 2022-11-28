import 'package:flutter/material.dart';
import 'package:tus_tareas/models/models.dart';

class MenuItems {
  static const List<MenuItemModel> itemsFirst = [itemSettings];
  static const List<MenuItemModel> itemsSecond = [itemSignOut];

  static const itemSettings = MenuItemModel(
    text: 'Configuraciones',
    icon: Icons.settings,
  );
  static const itemSignOut = MenuItemModel(
    text: 'Cerrar Sesión',
    icon: Icons.logout,
  );
}
