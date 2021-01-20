import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Product with ChangeNotifier{
final  String id;
final  String title;
final double price;
final  String description;
final String imageUrl;
final String creatorId;
     bool isFavourite;

     Product({
       @required this.creatorId,
       @required this.id,
       @required this.title,
       @required this.price,
       @required this.description,
       @required this.imageUrl,
        this.isFavourite=false});

Future<void> togglenotifier( String token,String uId) async{
  bool optimistic=isFavourite;
  isFavourite=!isFavourite;
  notifyListeners();
  String url ="https://shopapp-569f0.firebaseio.com/userFavourite/$uId/$id.json?auth=$token";
  var response= await http.put(url,body: json.encode(
    isFavourite
  ));
  if(response.statusCode>=400){
    isFavourite=optimistic;
    notifyListeners();
  }

}

}