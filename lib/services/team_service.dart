import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tus_tareas/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:tus_tareas/models/teams_model.dart';
import 'package:tus_tareas/pages/pages.dart';

class TeamService extends ChangeNotifier {
  final String _baseUrl = 'tareasapp-120e6-default-rtdb.firebaseio.com';

  final List<Team> teams = [];
  late Team selectedTeam;

  bool isLoading = true;
  bool isSaving = false;

  TeamService() {
    this.loadTeams();
  }

  Future<List<Team>> loadTeams() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'equipos.json');
    final resp = await http.get(url);

    final Map<String, dynamic> teamsMap = json.decode(resp.body);
    print(teamsMap);

    teamsMap.forEach((key, value) {
      final tempTeam = Team.fromMap(value);
      tempTeam.id = key;
      this.teams.add(tempTeam);
    });

    this.isLoading = false;
    notifyListeners();

    return this.teams;
  }

  Future saveOnCreateTeam(Team team) async {
    isSaving = true;
    notifyListeners();
    if (team.id == null) {
      await this.createTeam(team);
    } else {
      await this.updateTeam(team);
    }
    isSaving = false;
    notifyListeners();
  }

  Future<String> deleteTeam(Team team) async {
    final url = Uri.https(_baseUrl, 'equipos/${team.id}.json');
    final resp = await http.delete(url, body: team.toJson());
    final decodedData = resp.body;

    this.teams.remove(team);
    return team.id!;
  }

  Future<String> updateTeam(Team team) async {
    final url = Uri.https(_baseUrl, 'equipos/${team.id}.json');
    final resp = await http.put(url, body: team.toJson());
    final decodedData = resp.body;

    final index = this.teams.indexWhere((element) => element.id == team.id);
    this.teams[index] = team;
    return team.id!;
  }

  Future<String> createTeam(Team team) async {
    final url = Uri.https(_baseUrl, 'equipos.json');
    final resp = await http.post(url, body: team.toJson());
    final decodedData = json.decode(resp.body);

    team.id = decodedData['name'];

    this.teams.add(team);
    return team.id!;
  }
}
