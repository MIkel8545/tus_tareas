import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tus_tareas/pages/pages.dart';
import 'package:tus_tareas/pages/register.dart';
import 'package:tus_tareas/services/task_service.dart';

void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TaskService())],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(elevation: 0, color: Colors.black),
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.indigo)),
      initialRoute: 'login',
      routes: {
        'login': (_) => Login(),
        'home': (_) => Home(),
        'register': (_) => Register(),
        'task': (_) => TaskPage()
      },
    );
  }
}
