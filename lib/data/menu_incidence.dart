import 'package:flutter/material.dart';
import 'package:tus_tareas/models/models.dart';

class MenuIncidence {
  static const List<MenuItemModel> itemsFirst = [itemUpdate, itemDelete];

  static const itemUpdate = MenuItemModel(
    text: 'Editar Insidencia',
    icon: Icons.edit,
  );
  static const itemDelete = MenuItemModel(
    text: 'Eliminar Insidencia',
    icon: Icons.delete,
  );
}
