import 'package:flutter/foundation.dart';
import '../provider/Cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrdeItem{
  final String id;
  final double amount;
  final DateTime date;

  final List<CartItem> products;


  OrdeItem({this.id,this.amount,this.date,this.products});

}

class Order with ChangeNotifier{
  final String userId;
  final String authToken;

  Order(this.authToken,this._orders,this.userId);

  List<OrdeItem> _orders =[];
  List get orders{
    return [..._orders];

  }
  Future<void> fetchAndSet() async{
    String url='https://shopapp-569f0.firebaseio.com/orders/$userId.json?auth=$authToken';

    final response = await http.get(url);
    Map<String, dynamic> extractedData= json.decode(response.body);
    _orders.clear();
    extractedData.forEach((key, value) {

      _orders.add(OrdeItem(id: key,date:DateTime.parse(value["date"]) ,
          products:   (value['products'] as List<dynamic>).map((prod)=>CartItem(id: prod['id'],quantity: prod['quantity'],price: prod['price'],
          image: prod['image'],title: prod['title']
      )).toList()
      ,
          amount: value['amount']));
    });
    notifyListeners();
  }
  Future<void> addToOrder(List<CartItem> element,amount) async{
    String url ="https://shopapp-569f0.firebaseio.com/orders/$userId.json?auth=$authToken";
    var timestamp=DateTime.now();
    final response=await http.post(url,body: json.encode({
      "amount":amount,
      "date":timestamp.toString(),
      "products":  element.map((product) => {"price":product.price, "title":product.title, "image":product.image,
    "id":product.id,"quantity":product.quantity}).toList()
    }));
    _orders.insert(0,OrdeItem(id: json.decode(response.body)['name'],amount: amount,date: timestamp,products: element));
    notifyListeners();
}
}