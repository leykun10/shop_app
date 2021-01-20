import 'package:flutter/material.dart';
import 'package:shopapp/provider/Cart.dart';
import 'package:shopapp/widgets/CartScreen.dart';
import 'package:shopapp/widgets/Drawer.dart';
import '../model/product.dart';
import '../widgetsItems/productItem.dart';
import '../widgetsItems/griditem.dart';
import 'package:provider/provider.dart';
import '../provider/provider.dart';
import 'package:shopapp/widgetsItems/Batch.dart';
enum Filteroptions {onlyfavourite,all}
class ProductScreen extends StatelessWidget {

  static final String route="/detailScreen";


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(actions:<Widget>[
      Consumer<Products>(builder: (context,productContainer,_)=>
        PopupMenuButton(onSelected: (Filteroptions selectedValue){
      if(selectedValue==Filteroptions.all){
        productContainer.showoptionvalue(true);
      }
      else{
        productContainer.showoptionvalue(false);
      }
    },elevation: 4,color:Colors.white70,icon: Icon(Icons.more_vert),
    itemBuilder:(_)=> [PopupMenuItem(child: Text("All",style: TextStyle(fontWeight: FontWeight.bold),),value: Filteroptions.all,),
    PopupMenuItem(child: Text("Favourites only",style:
    TextStyle(fontWeight: FontWeight.bold)),value:Filteroptions.onlyfavourite ,)],)
    ),

     Consumer<Cart>(builder: (context,product,_)=>
         Badge(child: IconButton(icon: Icon(Icons.shopping_cart),onPressed: (){
           Navigator.pushNamed(context, CartScreen.routname);

         },)
       ,value: product.quantity().toString(),),)],title: Text("ShopApp"),),drawer: DrawerPage(),body:

        FutureBuilder(future:  Provider.of<Products>(context,listen: false).fetchAndStore(),
         builder: (ctx,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting ){
            return  Center(child: CircularProgressIndicator(),);

          }
         if(snapshot.hasError){
                  return Center(child: Text("error occurred"),);
         }
          else if(snapshot.connectionState==ConnectionState.done){
            return GridViewItem();
          }
          return null;

         }

         )

    );

  }
}
