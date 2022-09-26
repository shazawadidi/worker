import 'package:flutter/foundation.dart';import 'package:http/http.dart' as http;
import 'dart:convert';



 class AttendanceRepository {
   static String mainUrl = "http://185.241.124.139:8080/Attendance/Mobile/";
   var trackSupervisor = '$mainUrl/trackSupervisor';

 /// Function to send  location and imei from supervisor's mobile*/
Future sendAttend({
  required String lat,
  required String lng,
  required String accuracy,
  required String imei,
}) async {
  if (kDebugMode) {
    print('supervisor attending');
  }
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request('POST', Uri.parse(trackSupervisor));
  request.body =
      json.encode({"lat": lat, "lng": lng,"accuracy" :accuracy,"imei" :imei});
  request.headers.addAll(headers);
  var result =jsonDecode(request.body) as Map<String,dynamic>;
  if (kDebugMode) {
    print('supervisor data $result');
  }
  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    if (kDebugMode) {
      print(await response.stream.bytesToString());
    }

  } else if (response.statusCode == 401) {
  } else {
    if (kDebugMode) {
      print(response.reasonPhrase);
    }
  }
}
}