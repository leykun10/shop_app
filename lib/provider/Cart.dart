

import "package:flutter/foundation.dart";
class CartItem{
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String image;
  CartItem({this.price,this.title,this.id,this.quantity,this.image});

}
class Cart with ChangeNotifier{

  Map<String, CartItem> _items={};

  Map<String, CartItem> get items{
    return {..._items};
}
void addToCart(String title,String productId,double price,String image){


 if(_items.containsKey(productId)){
   _items.update(productId, (existingValue) => CartItem(id: existingValue.id,title: existingValue.title,
       price: existingValue.price,quantity:existingValue.quantity+1,image: existingValue.image));
 }

else {
  _items.putIfAbsent(productId, () => CartItem(id: DateTime.now().toString(),price: price,title: title,quantity: 1,image: image));
 }
    notifyListeners();

}
void RemoveItem(id){

    _items.remove(id);
    notifyListeners();

}

void removeSingleProduct(String productKey){
    if(_items.containsKey(productKey)){
      return;
    }
    else if(_items[productKey].quantity>1){
      _items.update(productKey, (value) => CartItem(id: value.id,price: value.price,quantity: value.quantity-1,image: value.image));
    }
    else{
  _items.remove(productKey);
    }
}

void clear(){
  _items={};
  notifyListeners();
}

double Total_amount(){
   var total=0.0;
  _items.forEach((key, value) {total+=value.quantity*value.price;}
  );
  return total;
}
  int quantity(){

    return _items.length;}

}