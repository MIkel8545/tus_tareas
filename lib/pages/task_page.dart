import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tus_tareas/provider/task_form_provider.dart';
import 'package:tus_tareas/services/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../decoration/input_decorations.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskService = Provider.of<TaskService>(context);

    return ChangeNotifierProvider(
        create: (_) => TaskFormProvider(taskService.selectedTask),
        child: _TaskPageBody(taskService: taskService));
  }
}

class _TaskPageBody extends StatelessWidget {
  const _TaskPageBody({
    Key? key,
    required this.taskService,
  }) : super(key: key);

  final TaskService taskService;

  @override
  Widget build(BuildContext context) {
    final taskForm = Provider.of<TaskFormProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(
            children: [
              Center(
                child: Text(
                  ' Crear Tarea ',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
          SizedBox(height: 100),
          _TaskForm(),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.indigo,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  'Crear Tarea',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () async {
                await taskService.saveOnCreateTask(taskForm.task);
                Navigator.of(context).pop();
              }),
        ],
      )),
    );
  }
}

class _TaskForm extends StatefulWidget {
  @override
  State<_TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<_TaskForm> {
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final taskForm = Provider.of<TaskFormProvider>(context);
    final task = taskForm.task;
    final TaskService taskService;
    String fecha = DateFormat('yyyy-MM-dd').format(date);
    var txt = TextEditingController();
    txt.text = DateFormat('yyyy-MM-dd').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
            key: taskForm.formkey,
            child: Column(
              children: [
                TextFormField(
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  initialValue: '${task.titulo}',
                  onChanged: (value) => task.titulo = value,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Nombre de la Tarea',
                      labelText: 'Nombre',
                      prefixIcon: Icons.task),
                ),
                SizedBox(height: 30),
                TextFormField(
                  maxLines: 5,
                  autocorrect: false,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(color: Colors.white),
                  initialValue: '${task.detalles}',
                  onChanged: (value) => task.detalles = value,
                  decoration: InputDecorations.authInputDecoration(
                    hintText: 'Detalles de la Tarea',
                    labelText: 'Detalles',
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: txt,
                  autocorrect: false,
                  keyboardType: TextInputType.none,
                  onChanged: (value) => task.fecha = value,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Fecha de la tarea',
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
                      task.fecha = fecha;
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
