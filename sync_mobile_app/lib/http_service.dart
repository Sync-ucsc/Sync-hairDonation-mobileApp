import 'dart:convert';

import 'models/user_model.dart';
import 'package:http/http.dart' as http;

  class HttpService{
  

    Future<ResponseModel> authenticateUser(String email, String password)async{
      final String apiUrl="http://10.0.2.2:3000/user/authenticate";
      Map<String, String> headers = {"Content-type": "application/json",'authorization':'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw=='};
      final json = jsonEncode({"email":email,"password": password});

     final response= await http.post(apiUrl, headers: headers, body: json);
      print(response.body);
      // if(response.statusCode==201){
        
      //   final String responseString=response.body;

      //   return userModelFromJson(responseString);
      // }else{
      //   return null;
      // }
      return responseModelFromJson(response.body);
    }
  }