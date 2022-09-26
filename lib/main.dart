// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:worker/login_page.dart';
import 'package:worker/util/bloc_observer.dart';
import 'package:workmanager/workmanager.dart';

import 'home_page.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher,isInDebugMode: true);
  Workmanager().registerPeriodicTask(
    "2",
    "simplePeriodicTask",

    frequency: const Duration(minutes: 1),
  );
  Bloc.observer = AppBlocObserver();
  runApp(  LoginScaffold());

}
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) {
    print("Task executing :$taskName");
    FlutterLocalNotificationsPlugin flip =   FlutterLocalNotificationsPlugin();
    var android =  const AndroidInitializationSettings('@mipmap/ic_launcher');

        ScheduledTask.control();
        var settings =   InitializationSettings(android: android);
        flip.initialize(settings);
        _showNotificationWithDefaultSound(flip);

    return Future.value(true);
  });
}
Future _showNotificationWithDefaultSound(flip) async {

  // Show a notification after every 15 minute with the first
  // appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Update Location at ',
      '${DateTime.now()}',
  );

  /// initialise channel platform for  Android   device.
  var platformChannelSpecifics =   NotificationDetails(
      android: androidPlatformChannelSpecifics,
   );
  await flip.show(0, 'Notify',
      'Your are one step away to connect with Attendance',
      platformChannelSpecifics, payload: 'Default_Sound'
  );
}
class ScheduledTask {
   static const String taskName = "control";
  static void control() {
   }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  void setupWorkManager() async {
    Workmanager().registerOneOffTask(
      "taskOne",
      "backUp",
        initialDelay:const Duration(seconds: 5),
        constraints: Constraints(
            networkType: NetworkType.connected,
            requiresBatteryNotLow: true,
            requiresCharging: true,
            requiresDeviceIdle: true,
            requiresStorageNotLow: true
        ),
        existingWorkPolicy: ExistingWorkPolicy.append
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Work manager Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Workmanager().registerOneOffTask(
                    "taskOne",
                    "backUp",
                    initialDelay:const Duration(seconds: 5),
                  );
                },
                child:const Text("Run Task")),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Workmanager().cancelByUniqueName("taskOne");
                },
                child:const Text("Cancel Task"))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
     super.initState();
     setupWorkManager();
  }
}