import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    UserModel({
        this.email,
        this.password,
    });

    String email;
    String password;

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
    };
}

ResponseModel responseModelFromJson(String str) => ResponseModel.fromJson(json.decode(str));
class ResponseModel {
    ResponseModel({
        this.data,
        this.msg,
        this.success
    });

    dynamic data;
    String msg;
    bool success;

    factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
        data: json["data"],
        msg: json["msg"],
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "data": data,
        "msg": msg,
        "success": success
    };
}