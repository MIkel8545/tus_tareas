import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tus_tareas/provider/incidence_form_provider.dart';
import 'package:tus_tareas/provider/task_form_provider.dart';
import 'package:tus_tareas/services/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../decoration/input_decorations.dart';

class CreateIncidence extends StatelessWidget {
  const CreateIncidence({super.key});

  @override
  Widget build(BuildContext context) {
    final incidenceService = Provider.of<IncidenceService>(context);

    return ChangeNotifierProvider(
        create: (_) =>
            IncidenceFormProvider(incidenceService.selectedIncidence),
        child: _IncidencePageBody(incidenceService: incidenceService));
  }
}

class _IncidencePageBody extends StatelessWidget {
  const _IncidencePageBody({
    Key? key,
    required this.incidenceService,
  }) : super(key: key);

  final IncidenceService incidenceService;

  @override
  Widget build(BuildContext context) {
    final incidenceForm = Provider.of<IncidenceFormProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(
            children: [
              Center(
                child: Text(
                  ' Crear Insidencia ',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
          SizedBox(height: 100),
          _IncidenceForm(),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.indigo,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  'Crear Insidencia',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () async {
                await incidenceService
                    .saveOnCreateTask(incidenceForm.incidence);
                Navigator.of(context).pop();
              }),
        ],
      )),
    );
  }
}

class _IncidenceForm extends StatefulWidget {
  @override
  State<_IncidenceForm> createState() => _IncidenceFormState();
}

class _IncidenceFormState extends State<_IncidenceForm> {
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final incidenceForm = Provider.of<IncidenceFormProvider>(context);
    final incidence = incidenceForm.incidence;
    final IncidenceService incidenceService;
    String fecha = DateFormat('yyyy-MM-dd').format(date);
    var txt = TextEditingController();
    txt.text = DateFormat('yyyy-MM-dd').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
            key: incidenceForm.formkey,
            child: Column(
              children: [
                TextFormField(
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  initialValue: '${incidence.titulo}',
                  onChanged: (value) => incidence.titulo = value,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Nombre de la Tarea',
                      labelText: 'Nombre',
                      prefixIcon: Icons.task),
                ),
                SizedBox(height: 30),
                TextFormField(
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  initialValue: '${incidence.detalles}',
                  onChanged: (value) => incidence.detalles = value,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Detalles de la tarea',
                      labelText: 'Detalles',
                      prefixIcon: Icons.task),
                ),
                SizedBox(height: 30),
                TextFormField(
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  initialValue: '${incidence.responable}',
                  onChanged: (value) => incidence.responable = value,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'ejemplo@gmail.com',
                      labelText: 'Responsable',
                      prefixIcon: Icons.task),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: txt,
                  autocorrect: false,
                  keyboardType: TextInputType.none,
                  onChanged: (value) => incidence.fecha = value,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Fecha de la insidencia',
                      labelText: 'Fecha',
                      prefixIcon: Icons.date_range),
                  onTap: () async {
                    DateTime? newDate = await showDatePicker(
                        locale: const Locale('es', ''),
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100));

                    if (newDate == null) return;

                    setState(() {
                      date = newDate;
                      fecha = DateFormat('yyyy-MM-dd').format(date);
                      txt.text = fecha;
                      incidence.fecha = fecha;
                    });
                  },
                ),
                SizedBox(height: 40),
              ],
            )),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Color.fromARGB(255, 0, 0, 0),
      );
}
