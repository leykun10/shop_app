import'dart:convert';
import 'package:shopapp/model/Exception.dart';
import '../model/product.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class Products with ChangeNotifier{
  bool showoption=true;
  void showoptionvalue(value){
    showoption=value;
    notifyListeners();

  }
  final String authToken;
  final String uId;
  Products(this.authToken,this._items,this.uId);

  List<Product> _items = [
    ];



  List<Product> get items{
    return [..._items];
  }
  Future<void> addProduct(Product product) async{
   final String url="https://shopapp-569f0.firebaseio.com/products.json?auth=$authToken";
   try{ final response =await http.post(url,body: json.encode({
      "title":product.title,
      "price":product.price,
      "description":product.description,
       "image":product.imageUrl,
     "creatorId":uId
    }
    ));
      _items.add(Product(id: json.decode(response.body)["name"],imageUrl: product.imageUrl,
          description: product.description,isFavourite: false,price: product.price,creatorId:product.creatorId,title:
    product.title));
    notifyListeners();}
    catch(error){
     throw error;
    }

  }

  Future<void> fetchAndStore([bool filterbyUser=false]) async{

    String filterIndex = filterbyUser?'orderBy="creatorId"&equalTo="$uId"':'';
    var url ="https://shopapp-569f0.firebaseio.com/products.json?auth=$authToken&$filterIndex";
    final response=await http.get(url);
    url = 'https://shopapp-569f0.firebaseio.com/userFavourite/$uId.json?auth=$authToken';
    final userFavourite= await http.get(url);
    var userFavouriteData=json.decode(userFavourite.body);

    Map<String, dynamic> extractedData=json.decode(response.body);
    _items.clear();
    extractedData.forEach((prodId, product) {
      _items.add(Product(id: prodId,price: product["price"],title: product['title'],description: product['description'],imageUrl:
      product['image'],isFavourite: userFavouriteData==null?false:userFavouriteData[prodId])??false);
    });
    notifyListeners();
  }
  Future<void> updateProduct(String productId,Product product) async{
     final url = "https://shopapp-569f0.firebaseio.com/products/$productId.json?auth=$authToken";
    await http.patch(url,body: json.encode({
       'title':product.title,
       'description':product.description,
       'image':product.imageUrl,
       'price':product.price

     }));
    int productIndex=_items.indexWhere((element) => element.id==productId);
    _items[productIndex]=product;
    notifyListeners();
  }
  Future<void >removeProduct(String productId) async{


    final url = "https://shopapp-569f0.firebaseio.com/products/$productId.json?auth=$authToken";
    final existingIndex=_items.indexWhere((element) => element.id==productId );
  var existingProduct=_items[existingIndex];
   _items.removeWhere((element) => element.id==productId );
    notifyListeners();
   var response= await http.delete(url);


      if(response.statusCode>=400){
        _items.insert(existingIndex, existingProduct);
        notifyListeners();
        throw HttpException("error occurred");
      }
      existingProduct=null;


  }
}












