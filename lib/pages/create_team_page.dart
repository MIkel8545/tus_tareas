import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tus_tareas/provider/task_form_provider.dart';
import 'package:tus_tareas/provider/team_form_provider.dart';
import 'package:tus_tareas/services/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../decoration/input_decorations.dart';

class CreateTeamPage extends StatelessWidget {
  const CreateTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final teamService = Provider.of<TeamService>(context);

    return ChangeNotifierProvider(
        create: (_) => TeamFormProvider(teamService.selectedTeam),
        child: _TeamPageBody(teamService: teamService));
  }
}

class _TeamPageBody extends StatelessWidget {
  const _TeamPageBody({
    Key? key,
    required this.teamService,
  }) : super(key: key);

  final TeamService teamService;

  @override
  Widget build(BuildContext context) {
    final teamForm = Provider.of<TeamFormProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(
            children: [
              Center(
                child: Text(
                  ' Crear Equipo ',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
          SizedBox(height: 100),
          _TeamForm(),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.indigo,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  'Crear Equipo',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () async {
                await teamService.saveOnCreateTeam(teamForm.team);
                Navigator.of(context).pop();
              }),
        ],
      )),
    );
  }
}

class _TeamForm extends StatefulWidget {
  @override
  State<_TeamForm> createState() => _TeamFormState();
}

class _TeamFormState extends State<_TeamForm> {
  @override
  Widget build(BuildContext context) {
    final teamForm = Provider.of<TeamFormProvider>(context);
    final team = teamForm.team;
    final TeamService teamService;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
            key: teamForm.formkey,
            child: Column(
              children: [
                TextFormField(
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  initialValue: '${team.nombre}',
                  onChanged: (value) => team.nombre = value,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Nombre Del Equipo',
                      labelText: 'Nombre',
                      prefixIcon: Icons.group),
                ),
                SizedBox(height: 30),
              ],
            )),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Color.fromARGB(255, 0, 0, 0),
      );
}
