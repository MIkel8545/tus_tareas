import 'package:flutter/material.dart';
import 'package:tus_tareas/models/models.dart';

class TeamFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formkey = new GlobalKey<FormState>();

  Team team;
  TeamFormProvider(this.team);

  bool isValidForm() {
    print(team.nombre);

    return formkey.currentState?.validate() ?? false;
  }
}
