import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../decoration/input_decorations.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(
            children: [
              Center(
                child: Text(
                  'Crear Tarea',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
          SizedBox(height: 100),
          _TaskForm(),
          SizedBox(height: 100),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  'Crear Tarea',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () {}),
        ],
      )),
    );
  }
}

class _TaskForm extends StatelessWidget {
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: _buildBoxDecoration(),
        child: Form(
            child: Column(
          children: [
            SizedBox(height: 10),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre de la Tarea',
                  labelText: 'Nombre',
                  prefixIcon: Icons.task),
            ),
            SizedBox(height: 50),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.datetime,
              initialValue: DateFormat('yyyy-MM-dd').format(date),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Fecha de la tarea',
                  labelText: 'Fecha',
                  prefixIcon: Icons.date_range),
              /* onTap: () async {
                DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100));
                if (newDate == null) return;
                setState(() => date = newDate)
              },*/
            ),
          ],
        )),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Color.fromARGB(255, 0, 0, 0),
      );
}
