import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  var flutterLocalNotificationsPlugin;

  NotificationService() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    initNotifications();
  }

  getNotificationInstance() {
    return flutterLocalNotificationsPlugin;
  }

  void initNotifications() {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void showNotification(int id, String title, String body) async {
    var platformChannelSpecifics = getPlatformChannelSpecfics();
    await flutterLocalNotificationsPlugin.show(
        id, title, body, platformChannelSpecifics,
        payload: 'Default_Sound');
    print('Notification Successfully Triggered');
  }

  // void showNotificationDaily(
  //     int id, String title, String body, int hour, int minute) async {
  //   var time = new Time(hour, minute, 0);
  //   // remove previous if found
  //   removeReminder(id);
  //   // start the schdeuling
  //   await flutterLocalNotificationsPlugin.showDailyAtTime(
  //       id, title, body, time, getPlatformChannelSpecfics());
  //   print('Notification Successfully Scheduled at $hour:$minute ');
  // }
  void showNotificationDaily(int id, String title, String body, int hour, int minute) async {
    // Use DateTime to create the scheduled notification time
    var now = DateTime.now();
    var notificationTime = DateTime(now.year, now.month, now.day, hour, minute);

    // If the time has already passed today, schedule it for tomorrow
    if (now.isAfter(notificationTime)) {
      notificationTime = notificationTime.add(Duration(days: 1));
    }

    // Remove previous notification if found
    removeReminder(id);

    // Schedule the notification using basic schedule method
    await flutterLocalNotificationsPlugin.schedule(
      id,
      title,
      body,
      notificationTime,
      getPlatformChannelSpecfics(),  // Platform-specific notification settings (with high priority)
      androidAllowWhileIdle: true,   // Ensures notification triggers even in Doze mode
    );

    print('Notification Successfully Scheduled at $hour:$minute');
  }



  getPlatformChannelSpecfics() {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'Medicine Reminder');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    return platformChannelSpecifics;
  }

  Future onSelectNotification(String payload) async {
    print('Notification clicked');
    return Future.value(0);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return Future.value(1);
  }

  void removeReminder(int notificationId) {
    flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}
