import 'dart:async';
import 'package:shopapp/utilities/keys.dart';
import 'package:http/http.dart ' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shopapp/model/Exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Auth with ChangeNotifier{
  String _token;
  DateTime _expiryDate;
  String _userId;
  var  authTimer;

  bool get isAuth {
    return _token!=null;
}
String get token{
    if(_expiryDate!=null&&_expiryDate.isAfter(DateTime.now())){
      return _token;
    }
    return null;
}
String get uId{
    return _userId;
}
Future<void> logOut() async{
    _token=null;
     _userId=null;
     _expiryDate=null;
     if(authTimer!=null){
       authTimer.cancel();
     }
     var prefs= await SharedPreferences.getInstance();
     prefs.clear();
     notifyListeners();

}

void autoLogout(){
    if(authTimer!=null){
     authTimer.cancel();
    }
   var timer=_expiryDate.difference(DateTime.now()).inSeconds;
    authTimer=Timer(Duration(seconds: timer),logOut);

}
Future<bool> tryAutoLogin() async{
    final prefs= await SharedPreferences.getInstance();
    if(!prefs.containsKey("userData")){
      return false;
    }
    var extractedData=json.decode(prefs.getString("userData")) as Map<String,Object>;
    _expiryDate=DateTime.parse(extractedData["expiryData"]);
    if(_expiryDate.isBefore(DateTime.now())){
      return false;
    }
    _token=extractedData["token"];
    _userId =extractedData["userID"];
    notifyListeners();
    autoLogout();
    return true;



}

Future<void> authenticate(String email, String password,urlSegment) async{
    String url ="https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey";
    try{ final response = await http.post(url,body: json.encode({
      'email':email,
      'password':password,
      'returnSecureToken':true
    }));
        var responseData=json.decode(response.body);

    if(responseData['error']!=null){
      throw HttpException(responseData['error']['message']);
    }
    _token = responseData['idToken'];
    _expiryDate=DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
    _userId=responseData['localId'];
    autoLogout();
    notifyListeners();
    final data = json.encode({"expiryData":_expiryDate.toIso8601String(),
                              "token":_token,   
                               "userId":uId
    });
    final prefs=await SharedPreferences.getInstance();
    prefs.setString("userData",data);
    }catch(error){
      throw error;
    }



  }

  Future<void> signUp(String email,String password) async{
   return authenticate(email, password, "signUp");
  }
  Future<void> signIn(String email,String password) async{

   return authenticate(email, password, 'signInWithPassword');
  }

}