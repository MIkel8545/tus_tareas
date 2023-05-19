import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tus_tareas/decoration/input_decorations.dart';
import 'package:tus_tareas/pages/register.dart';
import 'package:tus_tareas/provider/login_form_provider.dart';
import 'package:tus_tareas/widgets/widgets.dart';

import '../services/services.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final googleService = Provider.of<SignInWithGoogleService>(context);
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(width: 1.0, color: Colors.indigo),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.google, color: Colors.indigo),
                    SizedBox(
                      width: 20,
                    ),
                    const Text(
                      'Iniciar Sesion con Google',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              onPressed: () {
                googleService.googleLogin();
                final user = FirebaseAuth.instance.currentUser!;

                if (user != null) {
                  Navigator.pushReplacementNamed(context, 'tabs');
                }
              },
            ),
          ),
          SizedBox(height: 20),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(width: 1.0, color: Colors.indigo),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 52, vertical: 15),
              child: const Text(
                'Iniciar Sesion con Microsoft',
                style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'tabs');
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
                  labelText: 'Correo Electronico',
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
                color: Colors.indigo,
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

                        final authService =
                            Provider.of<AuthService>(context, listen: false);

                        if (!loginForm.isValidForm()) return;

                        loginForm.isLoading = true;

                        final String? error = await authService.login(
                            loginForm.email, loginForm.password);

                        if (error == null) {
                          Navigator.pushReplacementNamed(context, 'tabs');
                        } else {
                          AlertService.showSnackBar(
                              "El usuario no existe o las creadenciales son invalidas");
                          loginForm.isLoading = false;
                        }
                      }),
          ],
        ),
      ),
    );
  }
}
