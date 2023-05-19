import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tus_tareas/services/services.dart';
import 'package:tus_tareas/widgets/widgets.dart';

import '../decoration/input_decorations.dart';
import '../provider/register_form_provider.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrarse'),
      ),
      body: RegisterBackground(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 200),
            CardContainer(
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                ChangeNotifierProvider(
                    create: (_) => RegisterFormProvider(),
                    child: _RegisterForm())
              ]),
            ),
          ],
        ),
      )),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<RegisterFormProvider>(context);

    return Container(
      child: Form(
        key: registerForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Carlos ',
                  labelText: 'Nombre',
                  prefixIcon: Icons.person),
              onChanged: (value) => registerForm.nombre = value,
              validator: ((value) {
                return (value != null && value.length >= 3)
                    ? null
                    : 'El nombre debe al menos 3 caracteres';
              }),
            ),
            const SizedBox(height: 20),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'ejemplo@gmail.com',
                  labelText: 'Correo Electronico',
                  prefixIcon: Icons.alternate_email_rounded),
              onChanged: (value) => registerForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                RegExp regExp = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'Correo electronico no válido';
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*******',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => registerForm.password = value,
              validator: ((value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe contener 6 caracteres';
              }),
            ),
            const SizedBox(height: 20),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*******',
                  labelText: 'Repite la Contraseña',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => registerForm.password2 = value,
              validator: ((value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe contener 6 caracteres';
              }),
            ),
            const SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.indigo,
                onPressed: registerForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();

                        final authService =
                            Provider.of<AuthService>(context, listen: false);

                        if (!registerForm.isValidForm()) return;

                        registerForm.isLoading = true;

                        final String? error = await authService.createUser(
                            registerForm.email, registerForm.password);

                        if (error == null) {
                          Navigator.pushReplacementNamed(context, 'tabs');
                        } else {
                          print(error);
                          registerForm.isLoading = false;
                        }
                      },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    registerForm.isLoading ? 'Espere' : 'Registrarse',
                    style: const TextStyle(color: Colors.white),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
