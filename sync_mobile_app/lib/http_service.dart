import 'models/user_model.dart';
import 'package:http/http.dart' as http;

  class HttpService{
  

    Future<UserModel> authenticateUser(String email, String password)async{
      final String apiUrl="http://localhost:3000/user/authenticate";

     final response= await http.post(apiUrl,body: 
      {
        "email":email,
        "password": password
      });
      if(response.statusCode==201){
        final String responseString=response.body;

        return userModelFromJson(responseString);
      }else{
        return null;
      }
    }
  }