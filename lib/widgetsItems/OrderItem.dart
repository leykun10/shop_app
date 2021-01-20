import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../provider/Order.dart' as Item;

class OrderItem extends StatefulWidget {
  @override
  final Item.OrdeItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool expanded =false;
  Widget build(BuildContext context) {
    return Card(child: Column(children: <Widget>[
      ListTile(title: Text('${widget.order.amount}'),subtitle: Text('${DateFormat("dd mm yyyy hh:mm").format(widget.order.date)}'),
      trailing:IconButton(icon: expanded?Icon(Icons.expand_less):Icon(Icons.expand_more),onPressed: (){
        setState(() {
          expanded=!expanded;

        });
      },),

      ),
      AnimatedContainer(
        duration: Duration(milliseconds: 600),
         height: expanded?widget.order.products.length.toDouble()*
        65:0,child: expanded?ListView(padding: EdgeInsets.only(bottom: 5),children: <Widget>
    [...widget.order.products.map((e) => ListTile(leading: CircleAvatar(child: Image.network(e.image),),
        title: Text(e.title),subtitle: Text("${e.price.toStringAsFixed(2)}"),trailing: Column(
          children: <Widget>[
            Text("${e.quantity}x"),
            Text("${e.price*e.quantity}")
          ],
        ),
        )).toList()],):SizedBox(height: 0,),),],),);
  }
}
