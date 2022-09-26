import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker/login_page.dart';
import 'package:worker/util/bloc_observer.dart';
import 'package:workmanager/workmanager.dart';

import 'home_page.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  Bloc.observer = AppBlocObserver();
  runApp(  LoginScaffold());

}
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) {
    print("Task executing :$taskName");
    switch(taskName)
    {
      case ScheduledTask.taskName:
        ScheduledTask.control(); // calls your control code
        break;
    }
    return Future.value(true);
  });
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