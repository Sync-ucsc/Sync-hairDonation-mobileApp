// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);
import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));
String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    this.data,
    this.success,
    this.msg,
  });
  List<Notifications> data;
  bool success;
  String msg;
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        data: List<Notifications>.from(
            json["data"].map((x) => Notifications.fromJson(x))),
        success: json["success"],
        msg: json["msg"],
      );
  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "success": success,
        "msg": msg,
      };
}

class Notifications {
  Notifications({
    this.id,
    this.massage,
    this.title,
    this.role,
    this.validDate,
    this.icon,
    this.notificationStatus,
    this.groupId,
    this.v,
  });
  Id id;
  String massage;
  String title;
  String role;
  ValidDate validDate;
  String icon;
  String notificationStatus;
  String groupId;
  int v;
  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        id: Id.fromJson(json["_id"]),
        massage: json["massage"],
        title: json["title"],
        role: json["role"],
        validDate: ValidDate.fromJson(json["validDate"]),
        icon: json["icon"],
        notificationStatus: json["notificationStatus"],
        groupId: json["groupID"],
        v: json["__v"],
      );
  Map<String, dynamic> toJson() => {
        "_id": id.toJson(),
        "massage": massage,
        "title": title,
        "role": role,
        "validDate": validDate.toJson(),
        "icon": icon,
        "notificationStatus": notificationStatus,
        "groupID": groupId,
        "__v": v,
      };
}

class Id {
  Id({
    this.oid,
  });
  String oid;
  factory Id.fromJson(Map<String, dynamic> json) => Id(
        oid: json["\u0024oid"],
      );
  Map<String, dynamic> toJson() => {
        "\u0024oid": oid,
      };
}

class ValidDate {
  ValidDate({
    this.date,
  });
  DateTime date;
  factory ValidDate.fromJson(Map<String, dynamic> json) => ValidDate(
        date: DateTime.parse(json["\u0024date"]),
      );
  Map<String, dynamic> toJson() => {
        "\u0024date": date.toIso8601String(),
      };
}
