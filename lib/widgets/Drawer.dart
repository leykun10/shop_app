import 'package:flutter/material.dart';
import 'package:shopapp/widgets/UserProductScreen.dart';
import '../widgets/OrdersScreen.dart';
import 'package:provider/provider.dart';
import '../provider/AuthData.dart';
class DrawerPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(child: Column(children: <Widget>[
      AppBar(title: Text(""),),
      ListTile(leading: Icon(Icons.shop),title: Text("Shop"),onTap: (){
        Navigator.pushNamed(context, "/");
      },),
      ListTile(leading: Icon(Icons.payment),title: Text("Order"),onTap: (){
        Navigator.pushNamed(context, OrderScreen.route);
      },),
      ListTile(leading: Icon(Icons.edit),title: Text("Manage products"),onTap: (){
        Navigator.pushNamed(context, UserProductScreen.route);
      },)
       ,ListTile(leading: Icon(Icons.exit_to_app),title: Text("Log out"),onTap: (){

             Navigator.pop(context);
             Navigator.of(context).pushReplacementNamed('/auth');
             Provider.of<Auth>(context,listen: false).logOut();
      },)

    ],),);
  }
}
