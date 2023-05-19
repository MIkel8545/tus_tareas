import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tus_tareas/pages/create_incidence.dart';
import 'package:tus_tareas/pages/pages.dart';
import 'package:tus_tareas/pages/register.dart';

import 'package:tus_tareas/services/services.dart';
import 'package:tus_tareas/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'basic_chanel',
      channelName: 'Basic Notifications',
      defaultColor: Colors.indigo,
      importance: NotificationImportance.High,
      channelShowBadge: true,
      channelDescription: 'Basic Chanel Notification',
    ),
    NotificationChannel(
      channelKey: 'scheduled_chanel',
      channelName: 'Scheduled Notifications',
      locked: true,
      defaultColor: Colors.indigo,
      importance: NotificationImportance.High,
      channelShowBadge: true,
      channelDescription: 'Scheduled Chanel Notification',
    )
  ]);
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignInWithGoogleService()),
        ChangeNotifierProvider(create: (_) => IncidenceService()),
        ChangeNotifierProvider(create: (_) => TeamService()),
        ChangeNotifierProvider(create: (_) => TaskService()),
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
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
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('en'), const Locale('es')],
      debugShowCheckedModeBanner: false,
      title: 'Tus Tareas',
      scaffoldMessengerKey: AlertService.messengerKey,
      theme: miTema,
      initialRoute: 'checking',
      routes: {
        'createIncidence': (_) => CreateIncidence(),
        'incidence': (_) => IncidencePage(),
        'createTeam': (_) => CreateTeamPage(),
        'teams': (_) => Teams(),
        'tabs': (_) => TabsPage(),
        'checking': (_) => CheckAuth(),
        'login': (_) => Login(),
        'home': (_) => Home(),
        'register': (_) => Register(),
        'task': (_) => TaskPage(),
        'openTask': (_) => OpenTask(),
      },
    );
  }
}
