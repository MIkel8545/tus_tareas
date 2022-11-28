import 'package:flutter/material.dart';
import 'package:tus_tareas/models/models.dart';

class MenuTasks {
  static const List<MenuItemModel> itemsFirst = [itemUpdate, itemDelete];

  static const itemUpdate = MenuItemModel(
    text: 'Editar Tarea',
    icon: Icons.edit,
  );
  static const itemDelete = MenuItemModel(
    text: 'Eliminar Tarea',
    icon: Icons.delete,
  );
}
