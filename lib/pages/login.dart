import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tus_tareas/decoration/input_decorations.dart';
import 'package:tus_tareas/pages/register.dart';
import 'package:tus_tareas/provider/login_form_provider.dart';
import 'package:tus_tareas/widgets/widgets.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 250),
          CardContainer(
            child: Column(children: [
              const SizedBox(
                height: 20,
              ),
              ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(), child: _LoginForm())
            ]),
          ),
          TextButton(
            child: const Text('No tienes cuenta ?, Registrarse',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Register()));
            },
          ),
          const Divider(
            height: 20,
            thickness: 1,
            indent: 45,
            endIndent: 45,
            color: Color.fromARGB(255, 184, 181, 181),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(width: 1.0, color: Colors.deepPurple),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              child: const Text(
                'Iniciar Sesion con Google',
                style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'home');
            },
          ),
          SizedBox(height: 20),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(width: 1.0, color: Colors.deepPurple),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 52, vertical: 15),
              child: const Text(
                'Iniciar Sesion con Microsoft',
                style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'home');
            },
          )
        ],
      ),
    )));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'ejemplo@gmail.com',
                  labelText: 'Correo Elrectronico',
                  prefixIcon: Icons.alternate_email_rounded),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                RegExp regExp = new RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'Correo electronico no válido';
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecorations.authInputDecoration(
                  hintText: '*******',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => loginForm.password = value,
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
                color: Colors.deepPurple,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    loginForm.isLoading ? 'Espere' : 'Iniciar Sesion',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        if (!loginForm.isValidForm()) return;

                        loginForm.isLoading = true;

                        Future.delayed(Duration(seconds: 2));

                        Navigator.pushReplacementNamed(context, 'home');
                      }),
          ],
        ),
      ),
    );
  }
}
