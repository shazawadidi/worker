class TrackResponse {
  int? responseCode;
  String? responseMsg;
  TrackResponse({
      this.responseCode,
      this.responseMsg,});

  TrackResponse.fromJson(dynamic json) {
    responseCode = json['responseCode'];
    responseMsg = json['responseMsg'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['responseCode'] = responseCode;
    map['responseMsg'] = responseMsg;
    return map;
  }

}