import 'package:flutter/material.dart';
class CartItems extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String image;

  CartItems({this.quantity,this.price,this.title,this.id,this.image});

  



  @override
  Widget build(BuildContext context) {
    return Card(margin: EdgeInsets.all(10),child:ListTile(leading: CircleAvatar(radius: 40,
      child:Padding(padding: EdgeInsets.all(5),child: FittedBox(child: Text("\$${price*quantity}",style: TextStyle(fontSize: 18),))),),

        subtitle: Text(title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),trailing: Text("${quantity}x",style: TextStyle(fontSize: 20),),),);
  }
}
