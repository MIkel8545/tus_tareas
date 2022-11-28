import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tus_tareas/models/models.dart';
import 'package:http/http.dart' as http;

class IncidenceService extends ChangeNotifier {
  final String _baseUrl = 'tareasapp-120e6-default-rtdb.firebaseio.com';

  final List<Incidence> incidences = [];
  final List<Incidence> completadas = [];
  late Incidence selectedIncidence;

  bool isLoading = true;
  bool isSaving = false;

  IncidenceService() {
    this.loadIncidences();
    this.loadCompleteIncidences();
  }
  Future<List<Incidence>> loadCompleteIncidences() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'insidencias.json');
    final resp = await http.get(url);

    final Map<String, dynamic> incidencesMap = json.decode(resp.body);
    print(incidencesMap);

    incidencesMap.forEach((key, value) {
      final tempIncidence = Incidence.fromMap(value);
      tempIncidence.id = key;

      if (tempIncidence.estado == 'completada') {
        this.completadas.add(tempIncidence);
      }
    });

    this.isLoading = false;
    notifyListeners();

    return this.completadas;
  }

  Future<List<Incidence>> loadIncidences() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'insidencias.json');
    final resp = await http.get(url);

    final Map<String, dynamic> incidencesMap = json.decode(resp.body);
    print(incidencesMap);

    incidencesMap.forEach((key, value) {
      final tempIncidence = Incidence.fromMap(value);
      tempIncidence.id = key;
      if (tempIncidence.estado == 'asignada') {
        this.incidences.add(tempIncidence);
      }
    });

    this.isLoading = false;
    notifyListeners();

    return this.incidences;
  }

  Future onUncompleteTasks(Incidence incidence) async {
    isSaving = true;
    notifyListeners();

    if (incidence.estado == 'asignada') {
      await this.uncompleteAsignadaIncidence(incidence);
    }

    isSaving = false;
    notifyListeners();
  }

  Future onCompleteIncidence(Incidence incidence) async {
    isSaving = true;
    notifyListeners();

    if (incidence.estado == 'completada') {
      await this.completeAsignadaIncidence(incidence);
    }

    isSaving = false;
    notifyListeners();
  }

  Future onDeleteIncidence(Incidence incidence) async {
    isSaving = true;
    notifyListeners();

    if (incidence.estado == 'completada') {
      await this.deleteCompletada(incidence);
    } else {
      await this.deleteAsignada(incidence);
    }

    isSaving = false;
    notifyListeners();
  }

  Future saveOnCreateTask(Incidence incidence) async {
    isSaving = true;
    notifyListeners();
    if (incidence.id == null) {
      await this.createIncidence(incidence);
    } else {
      if (incidence.estado == 'asignada') {
        await this.updateIncidence(incidence);
      } else {
        await this.updateComplete(incidence);
      }
    }
    isSaving = false;
    notifyListeners();
  }

  Future<String> updateComplete(Incidence incidence) async {
    final url = Uri.https(_baseUrl, 'insidencias/${incidence.id}.json');
    final resp = await http.put(url, body: incidence.toJson());
    final decodedData = resp.body;

    final index =
        this.completadas.indexWhere((element) => element.id == incidence.id);
    this.completadas[index] = incidence;
    return incidence.id!;
  }

  Future<String> updateIncidence(Incidence incidence) async {
    final url = Uri.https(_baseUrl, 'insidencias/${incidence.id}.json');
    final resp = await http.put(url, body: incidence.toJson());
    final decodedData = resp.body;

    final index =
        this.incidences.indexWhere((element) => element.id == incidence.id);
    this.incidences[index] = incidence;
    return incidence.id!;
  }

  Future<String> createIncidence(Incidence incidence) async {
    final url = Uri.https(_baseUrl, 'insidencias.json');
    final resp = await http.post(url, body: incidence.toJson());
    final decodedData = json.decode(resp.body);

    incidence.id = decodedData['name'];

    this.incidences.add(incidence);
    return incidence.id!;
  }

  Future<String> deleteCompletada(Incidence incidence) async {
    final url = Uri.https(_baseUrl, 'insidencias/${incidence.id}.json');
    final resp = await http.delete(url, body: incidence.toJson());
    final decodedData = resp.body;

    final index =
        this.completadas.indexWhere((element) => element.id == incidence.id);
    this.completadas.removeAt(index);
    return incidence.id!;
  }

  Future<String> deleteAsignada(Incidence incidence) async {
    final url = Uri.https(_baseUrl, 'insidencias/${incidence.id}.json');
    final resp = await http.delete(url, body: incidence.toJson());
    final decodedData = resp.body;

    final index =
        this.incidences.indexWhere((element) => element.id == incidence.id);
    this.incidences.removeAt(index);
    return incidence.id!;
  }

  Future<String> uncompleteAsignadaIncidence(Incidence incidence) async {
    final url = Uri.https(_baseUrl, 'insidencias/${incidence.id}.json');
    final resp = await http.put(url, body: incidence.toJson());
    final decodedData = resp.body;

    final index =
        this.completadas.indexWhere((element) => element.id == incidence.id);
    this.incidences.add(incidence);
    this.completadas.removeAt(index);
    return incidence.id!;
  }

  Future<String> completeAsignadaIncidence(Incidence incidence) async {
    final url = Uri.https(_baseUrl, 'insidencias/${incidence.id}.json');
    final resp = await http.put(url, body: incidence.toJson());
    final decodedData = resp.body;

    final index =
        this.incidences.indexWhere((element) => element.id == incidence.id);
    this.completadas.add(incidence);
    this.incidences.removeAt(index);
    return incidence.id!;
  }
}
