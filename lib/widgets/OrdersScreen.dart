import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgetsItems/OrderItem.dart';
import '../provider/Order.dart' show Order;

class OrderScreen extends StatelessWidget {
  static final String route="OrderScreen";

  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Your Orders"),),

    body:FutureBuilder(future: Provider.of<Order>(context,listen: false).fetchAndSet(),
    builder: (ctx,snapshot){
      if(snapshot.connectionState==ConnectionState.waiting){
        return Center(child: CircularProgressIndicator());
      }
      else if(snapshot.connectionState==ConnectionState.done){
        return Consumer<Order>(builder: (ctx,order,child)=>ListView.builder(itemBuilder: (context,index){
          return  OrderItem(order.orders[index]);
        },itemCount: order.orders.length,),);

      }
      else if(snapshot.hasError){
        return Center(child: Text("error occurred"),);
      }
      return null;

    },) ,);
  }
}
