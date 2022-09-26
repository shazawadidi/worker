import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key,}) : super(key: key);


  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage>  with TickerProviderStateMixin {
  late AnimationController lottieController;


  @override
  void initState() {

    lottieController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1));
    lottieController.addListener(() {
      print(lottieController.value);
      //  if the full duration of the animation is 8 secs then 0.5 is 4 secs
      if (lottieController.value > 1.0) {
        lottieController.value = 1.0;
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    lottieController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    /// provide repository to get request data
    return Scaffold(
      body: Container(
          decoration:const BoxDecoration(
            image: DecorationImage(
              image:  AssetImage("assets/images/back.png",),
              fit: BoxFit.fitWidth,
              // colorFilter: ColorFilter.mode(Colors.grey.withOpacity(0.5), BlendMode.modulate,)
            ),
          ),
          child:  SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top:40.0),
                child: Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: Lottie.asset(
                            'assets/animation/attend.json',
                            controller: lottieController,
                            repeat: true,
                            onLoaded: (comp) {
                              lottieController
                                ..duration = comp.duration
                                ..forward();
                            },
                          ),
                        ),
                        SizedBox(height: 220,),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            " Attend Successfully",
                            style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.teal),
                          ),
                        ),
                        SizedBox(height: 200,),
                        Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(20)),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(
                                          color: Colors.teal.withOpacity(0.5)))),
                              backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.teal),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: const [

                                  Icon(
                                    Icons.arrow_back_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),

                                  Text(
                                    "Back",
                                    style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),




                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ),
          )
      ),
    );
  }
}
