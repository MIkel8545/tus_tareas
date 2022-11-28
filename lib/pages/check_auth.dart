import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tus_tareas/pages/pages.dart';
import 'package:tus_tareas/services/services.dart';

class CheckAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData)
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Espere',
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CircularProgressIndicator(
                    color: Colors.indigo,
                  )
                ],
              );

            if (snapshot.data == '') {
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => Login(),
                        transitionDuration: Duration(seconds: 0)));

                //Navigator.of(context).pushReplacementNamed('login');
              });
            } else {
              Future.microtask(() {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => TabsPage(),
                        transitionDuration: Duration(seconds: 0)));

                //Navigator.of(context).pushReplacementNamed('login');
              });
            }

            return Container();
          },
        ),
      ),
    );
  }
}
