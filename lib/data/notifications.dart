import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

Future<void> createTaskNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_chanel',
        title: '${Emojis.office_calendar} Notificacion de tareas pendientes!!',
        body: 'Es momento de completar lo que dejaste pendiente'),
  );
}

Future<void> createTaskReminderNotification(DateTime date) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'scheduled_chanel',
          title:
              '${Emojis.office_calendar} Notificacion de tareas pendientes!!',
          body: 'Tu tarea tiene que completarse hoy',
          wakeUpScreen: true,
          category: NotificationCategory.Reminder),
      schedule: NotificationCalendar.fromDate(date: date));
}
