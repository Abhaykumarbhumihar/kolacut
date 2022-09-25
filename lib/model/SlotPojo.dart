// To parse this JSON data, do
//
//     final slotPojo = slotPojoFromJson(jsonString);

import 'dart:convert';

SlotPojo slotPojoFromJson(String str) => SlotPojo.fromJson(json.decode(str));

String slotPojoToJson(SlotPojo data) => json.encode(data.toJson());

class SlotPojo {
  SlotPojo({
    this.status,
    this.message,
    this.notificationDetail,
  });

  int? status;
  String? message;
  List<NotificationDetail>? notificationDetail;

  factory SlotPojo.fromJson(Map<String, dynamic> json) => SlotPojo(
    status: json["status"],
    message: json["message"],
    notificationDetail: List<NotificationDetail>.from(json["Notification Detail"].map((x) => NotificationDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "Notification Detail": List<dynamic>.from(notificationDetail!.map((x) => x.toJson())),
  };
}

class NotificationDetail {
  NotificationDetail({
    this.morning,
    this.afternoon,
    this.evening,
  });

  List<String>?morning;
  List<String>?afternoon;
  List<String>?evening;

  factory NotificationDetail.fromJson(Map<String, dynamic> json) => NotificationDetail(
    morning: List<String>.from(json["Morning"].map((x) => x)),
    afternoon: List<String>.from(json["Afternoon"].map((x) => x)),
    evening: List<String>.from(json["Evening"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Morning": List<dynamic>.from(morning!.map((x) => x)),
    "Afternoon": List<dynamic>.from(afternoon!.map((x) => x)),
    "Evening": List<dynamic>.from(evening!.map((x) => x)),
  };
}
