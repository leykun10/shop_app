

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../provider/Cart.dart' show Cart;
import '../provider/Order.dart';
import '../widgetsItems/cartItems.dart';
class CartScreen extends StatelessWidget {
  static final routname= "CartScreen";

  @override
  Widget build(BuildContext context) {
  var cartContainer= Provider.of<Cart>(context);
    return Scaffold(appBar: AppBar(title: Text("Cart"),),
      body: Column(children: <Widget>[Consumer<Cart>(builder: (context,cart,child)=>
          Card(margin: EdgeInsets.all(10),child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text("Total Sum",
              style:TextStyle(fontSize: 22),),
              Chip(backgroundColor: Colors.purple,label: Text("\$"+cart.Total_amount().toStringAsFixed(2),
                style: TextStyle(fontSize: 22),)),
             OrderButton(cartContainer)
               ],),
          ),),), Expanded(child: ListView.builder(itemBuilder:(context,index){
        return Dismissible(
          key: ValueKey(cartContainer.items.values.toList()[index].id),
          onDismissed: (direction){
            cartContainer.RemoveItem(cartContainer.items.keys.toList()[index]);
          },
          confirmDismiss: (value){

            return showDialog(context: context,builder: (ctx){
              return AlertDialog(title: Text("Are you sure"),content: Text("Do you want to delete"),actions: <Widget>[
                FlatButton(child: Text("yes"),onPressed: (){
                  Navigator.of(context).pop(true);},),
                FlatButton(child: Text("no"),onPressed: (){
                  Navigator.of(context).pop(false);
                },)
              ],);
            }
            );
          },
          direction: DismissDirection.endToStart,
          background: Container(alignment: Alignment.centerRight,color: Colors.red,child:
          IconButton(iconSize:40 ,icon: Icon(Icons.delete),),),
          child: CartItems(title: cartContainer.items.values.toList()[index].title,
            quantity: cartContainer.items.values.toList()[index].quantity,
            price: cartContainer.items.values.toList()[index].price,),
        );
      },itemCount: cartContainer.quantity(),),)],),);
  }
}
class OrderButton extends StatefulWidget {
  @override
  final Cart cartContainer;
  OrderButton(this.cartContainer);
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {

 bool isLoading=false;

  Widget build(BuildContext context) {
    return  FlatButton(child:isLoading?CircularProgressIndicator():Text("Order now",style: TextStyle(fontSize: 22,color: Colors.black),),
      onPressed: (widget.cartContainer.items.length==0 || isLoading)?null:() async{
        setState(() {
          isLoading=true;
        });
        await Provider.of<Order>(context,listen: false).addToOrder(widget.cartContainer.items.values.toList(),widget.cartContainer.Total_amount());
        setState(() {
          isLoading=false;
        });
        widget.cartContainer.clear();


      },) ;
  }
}
