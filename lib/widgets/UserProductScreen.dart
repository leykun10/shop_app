import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../provider/provider.dart';
import '../widgetsItems/UserProductItem.dart';
import '../widgets/Drawer.dart';
import '../widgets/EditProductScreen.dart';

class UserProductScreen extends StatelessWidget {
  static final String route="UserProductScreen";
  Future<void> refreshData(BuildContext context) async{
    await Provider.of<Products>(context,listen: false).fetchAndStore(true);
  }
  @override
  Widget build(BuildContext context) {
     Provider.of<Products>(context,listen: false).fetchAndStore(true);

    return Scaffold(drawer: DrawerPage(),appBar: AppBar(actions: <Widget>[IconButton(icon: Icon(Icons.add),onPressed:
    (){
      Navigator.pushNamed(context, EditProductScreen.route,arguments: {"new":true});
    },)],title: Text("Your Products"),

    ),body: FutureBuilder(
      future: refreshData(context),
      builder:(ctx,snapshot){

        return snapshot.connectionState==ConnectionState.waiting?Center(child: CircularProgressIndicator(),):RefreshIndicator(onRefresh:(){
          return refreshData(context);
        },child: Consumer<Products>(builder:(ctx,productData,_)=>ListView.builder(itemBuilder: (ctx,i)=>UserProductItem(id:productData.items[i].id,
          title:productData.items[i].title,image: productData.items[i].imageUrl,),itemCount:productData.items.length)));
      },
    ),);
  }
}
