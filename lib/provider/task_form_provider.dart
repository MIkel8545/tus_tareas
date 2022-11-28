import 'package:flutter/material.dart';
import 'package:tus_tareas/models/models.dart';

class TaskFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formkey = new GlobalKey<FormState>();

  Tasks task;
  TaskFormProvider(this.task);

  updateState(String value) {
    this.task.estado = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(task.titulo);
    print(task.fecha);
    return formkey.currentState?.validate() ?? false;
  }
}
