import 'dart:convert';

import 'models/user_model.dart';
import 'models/target_model.dart';
import 'package:http/http.dart' as http;
import 'package:sync_mobile_app/screens/welcome_page.dart';

class HttpService {
  Future<ResponseModel> authenticateUser(String email, String password) async {
    final String apiUrl = "http://10.0.2.2:3000/user/authenticate";
    Map<String, String> headers = {
      "Content-type": "application/json",
      'authorization': 'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw=='
    };
    final json = jsonEncode({"email": email, "password": password});

    final response = await http.post(apiUrl, headers: headers, body: json);

    // if(response.statusCode==201){

    //   final String responseString=response.body;

    //   return userModelFromJson(responseString);
    // }else{
    //   return null;
    // }
    print(response.body);
    return responseModelFromJson(response.body);
  }

  Future<TargetModel> getTarget() async {
    final String apiUrl =
        "http://10.0.2.2:3000/targets/getTarget/aka@gmail.com";
    Map<String, String> headers = {
      "Content-type": "application/json",
      'authorization': 'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw=='
    };
    final json = await http.get(apiUrl);
    return TargetModel.fromJson(jsonDecode(json.body));
  }

  Future<ResponseModel> changePassword(
      String email, String password, String token) async {
    print(email);
    print(password);
    final data = jsonEncode({"email": email, "password": password});
    final String apiUrl = "http://10.0.2.2:3000/user/changePassword";
    Map<String, String> headers = {
      "Content-type": "application/json",
      'authorization': 'Bearer ' + token
    };
    final response = await http.post(apiUrl, body: data, headers: headers);
    print(".........." + response.body);
    return responseModelFromJson(response.body);
  }

  Future<ResponseModel> changeProfilePassword(
      String email, String password, String oldPassword, String token) async {
    final data = jsonEncode(
        {"email": email, "password": password, "oldPassword": oldPassword});
    print(UserDetails.userToken);
    final String apiUrl = "http://10.0.2.2:3000/user/profileChanePassword";
    Map<String, String> headers = {
      "Content-type": "application/json",
      'authorization': 'Bearer ' + token
    };
    var response;
    print("gggg");
    try {
      response = await http.post(apiUrl, body: data, headers: headers);
    } catch (e) {
      print(e);
    }

    print(".........." + response.body);
    return responseModelFromJson(response.body);
  }
}
