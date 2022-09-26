import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:worker/service/fetch_IMEI.dart';
import 'package:worker/widgets/error_location_widget.dart';
import 'package:workmanager/workmanager.dart';
import 'attendance_page.dart';
import 'location/location_bloc.dart';
import 'location_repository/location_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  /// function to send attendance request
  Future sendAttend({
    required String lat,
    required String lng,
    required String accuracy,
    required String? imei,
  }) async {
    if (kDebugMode) {
      print('supervisor attending');
    }
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            "http://185.241.124.139:8080/Attendance/Mobile/trackSupervisor"));
    request.body = json
        .encode({"lat": lat, "lng": lng, "accuracy": accuracy, "imei": imei});
    request.headers.addAll(headers);
    var result = jsonDecode(request.body) as Map<String, dynamic>;
    if (kDebugMode) {
      print('supervisor data $result');
    }
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Timer.periodic(const Duration(seconds: 10), (timer) async {
        print("Request ${response.statusCode}");
      });
    } else if (response.statusCode == 401) {

    } else {
       if (kDebugMode) {
        print(response.reasonPhrase);
      }

    }
  }

  /// Function To getting device information -Serial Number
  Future<String?> getDeviceInfo() async {
    String? identifier = await DeviceInfo().getDeviceDetails();
    print('identifier: $identifier');
    return identifier;
  }


  @override
  void initState() {
     super.initState();
  }
  GlobalKey previewContainer =  GlobalKey();
  int originalSize = 80000;

  @override
  Widget build(BuildContext context) {
    String? identifier;

    /// provide repository to get request data
    return RepositoryProvider(
        create: (context) => LocationRepository(),
        child: BlocProvider<LocationBloc>(
          create: (context) => LocationBloc(
            locationRepository: context.read<LocationRepository>(),
          )..add(GetLocation()),
          child: WillPopScope(
            onWillPop: () async {
              MoveToBackground.moveTaskToBack();
              return false;
            },
            child: Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/back.png",
                    ),
                    fit: BoxFit.fitWidth,
                    // colorFilter: ColorFilter.mode(Colors.grey.withOpacity(0.5), BlendMode.modulate,)
                  ),
                ),
                child: BlocBuilder<LocationBloc, LocationState>(
                  buildWhen: (previous, current) =>
                  current.status.isLoading ||
                      current.status.isError ||
                      current.status.isSuccess,
                  builder: (context, state) {
                    ///Success Loading
                    if (state.status.isSuccess) {
                      return SingleChildScrollView(
                        child: Column(children: [
                          FutureBuilder(
                            future: Workmanager().registerOneOffTask(
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
                            ),
                            builder: (context, snapshot) {
                              /// get device information
                              getDeviceInfo().then((value) async {
                                identifier = value;
                                if (kDebugMode) {
                                  print('Serial Number: ${identifier?.replaceAll(RegExp(r'^0+(?=.)'), '')}');
                                }
                                ///Timer to sending request per seconds
                                Timer.periodic(const Duration(seconds: 10),
                                        (timer) async {
                                      print("Attendance Request Data:Lat${state.currentUserLocation.latitude.toString()} "
                                          " , lng: ${state.currentUserLocation.longitude.toString()}, accuracy: ${state.currentUserLocation.accuracy
                                          .toString()}");
                                      sendAttend(
                                          lat: state.currentUserLocation.latitude
                                              .toString(),
                                          lng: state.currentUserLocation.longitude
                                              .toString(),
                                          accuracy: state.currentUserLocation.accuracy
                                              .toString(),
                                          imei: identifier?.replaceAll(
                                              RegExp(r'^0+(?=.)'), ''));
                                           ///

                                    });
                              });

                              /// optional view in screen if no MoveTaskToBackground feature
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 100.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Image.asset(
                                          'assets/images/zain.png',
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const Text("Hello Zain Supervisor",
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 18)),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(top: 180.0),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [

                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                RepaintBoundary(
                                                  key: previewContainer,
                                                  child: Container(
                                                    height: MediaQuery.of(context).size.height/4,
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 5, right: 5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          15),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        const Center(
                                                          child: Text(
                                                              "SuperVisor Attendance Data",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                                  color: Colors
                                                                      .black87)),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Text(
                                                            "Latitude:  ${state.currentUserLocation.latitude}",
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w300,
                                                                color: Colors
                                                                    .black87)),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Text(
                                                            "Longitude:  ${state.currentUserLocation.longitude}",
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w300,
                                                                color: Colors
                                                                    .black87)),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left: 30.0),
                                                          child: identifier !=
                                                              null
                                                              ? Text(
                                                              "${identifier?.replaceAll(RegExp(r'^0+(?=.)'), '')}",
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                  18,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                                  color: Colors
                                                                      .black87))
                                                              : const CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color: Colors
                                                                .green,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          InkWell(
                            onTap: () {
                              ShareFilesAndScreenshotWidgets()
                                  .shareScreenshot(
                                  previewContainer,
                                  originalSize,
                                  "SuperVisor Data",
                                  "SuperVisorData.png",
                                  "SuperVisorData/png",
                                  text:
                                  "This is my information for the Attendance");
                            },
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius:
                                  BorderRadius.circular(
                                      20)),
                              padding:const EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                  left: 20,
                                  right: 20),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                                children: const [
                                  Text(
                                    "Send The Data",
                                    style: TextStyle(
                                        fontFamily:
                                        'Tajawal',
                                        fontSize: 16,
                                        fontWeight:
                                        FontWeight.w500,
                                        color:
                                        Colors.white),
                                  ),
                                  SizedBox(width: 20),
                                  Icon(
                                    Icons.share,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius:
                                BorderRadius.circular(
                                    20)),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            20.0),
                                        side: BorderSide(
                                            color: Colors
                                                .teal
                                                .withOpacity(
                                                0.5)))),
                                backgroundColor:
                                MaterialStateProperty
                                    .all<Color>(
                                    Colors.teal),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AttendancePage()),
                                );

                              },
                              child: Padding(
                                padding:
                                const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  mainAxisSize:
                                  MainAxisSize.min,
                                  children: const [
                                    Text(
                                      "Attend Now",
                                      style: TextStyle(
                                          fontFamily:
                                          'Tajawal',
                                          fontSize: 16,
                                          fontWeight:
                                          FontWeight
                                              .w500,
                                          color:
                                          Colors.white),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Icon(
                                      Icons
                                          .arrow_forward_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                      );

                    }

                    /// Error Loading
                    if (state.status.isError) {
                      return ErrorLocationWidget(
                        errorMessage: state.errorMessage,
                      );
                    }

                    /// Loading
                    return   const Center(
                      child: CircularProgressIndicator(color: Colors.black87),
                    );
                  },
                ),
              ),
            ),
          ),
        ));
  }
}
