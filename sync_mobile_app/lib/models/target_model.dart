import 'dart:convert';

TargetModel targetModelFromJson(String str) =>
    TargetModel.fromJson(json.decode(str));

String targetModelToJson(TargetModel data) => json.encode(data.toJson());

class TargetModel {
  TargetModel({
    this.data,
    this.success,
    this.debugMessage,
  });

  List<Datum> data;
  bool success;
  String debugMessage;

  factory TargetModel.fromJson(Map<String, dynamic> json) => TargetModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        success: json["success"],
        debugMessage: json["debugMessage"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "success": success,
        "debugMessage": debugMessage,
      };
}

class Datum {
  Datum({
    this.createdAt,
    this.status,
    this.notification,
    this.id,
    this.driverId,
    this.driverEmail,
    this.targets,
  });

  DateTime createdAt;
  String status;
  String notification;
  String id;
  String driverId;
  String driverEmail;
  List<Target> targets;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        createdAt: DateTime.parse(json["createdAt"]),
        status: json["status"],
        notification: json["notification"],
        id: json["_id"],
        driverId: json["driverId"],
        driverEmail: json["driverEmail"],
        targets:
            List<Target>.from(json["targets"].map((x) => Target.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt.toIso8601String(),
        "status": status,
        "notification": notification,
        "_id": id,
        "driverId": driverId,
        "driverEmail": driverEmail,
        "targets": List<dynamic>.from(targets.map((x) => x.toJson())),
      };
}

class Target {
  Target({
    this.status,
    this.notification,
    this.salonId,
    this.salonName,
    this.requestId,
    this.lat,
    this.lng,
    this.noOfWigs,
  });

  String status;
  String notification;
  String salonId;
  String salonName;
  String requestId;
  double lat;
  double lng;
  int noOfWigs;

  factory Target.fromJson(Map<String, dynamic> json) => Target(
        status: json["status"],
        notification: json["notification"],
        salonId: json["salonId"],
        salonName: json["salonName"],
        requestId: json["requestId"],
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
        noOfWigs: json["noOfWigs"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "notification": notification,
        "salonId": salonId,
        "salonName": salonName,
        "requestId": requestId,
        "lat": lat,
        "lng": lng,
        "noOfWigs": noOfWigs,
      };
}
