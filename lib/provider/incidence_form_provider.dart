import 'package:flutter/material.dart';
import 'package:tus_tareas/models/models.dart';

class IncidenceFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formkey = new GlobalKey<FormState>();

  Incidence incidence;
  IncidenceFormProvider(this.incidence);

  bool isValidForm() {
    print(incidence.titulo);
    print(incidence.fecha);
    return formkey.currentState?.validate() ?? false;
  }
}
