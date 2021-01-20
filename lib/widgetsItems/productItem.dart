import 'package:flutter/material.dart';
import 'package:shopapp/provider/Cart.dart';
import '../widgets/productScreenOverview.dart';
import 'package:provider/provider.dart';
import '../provider/Cart.dart';
import '../model/product.dart';
import '../provider/AuthData.dart';
class ProductItem extends StatelessWidget {


  @override
  Widget build(BuildContext context)
  {
    var product = Provider.of<Product>(context);
    var cart = Provider.of<Cart>(context,listen: false);
    var auth =Provider.of<Auth>(context);
    return ClipRRect(
     borderRadius: BorderRadius.circular(10) ,
      child: GestureDetector(onTap: (){

        Navigator.pushNamed(context,ProductScreen.route,arguments: {"title":product.title,"price":product.price,"image":product.imageUrl,"description":product.description});
      },
        child: GridTile(footer: GridTileBar(backgroundColor: Colors.black54,
          leading: Consumer<Product>(builder: (context,product,_)=>IconButton(color: Colors.orange,icon:
          Icon((product.isFavourite?Icons.favorite:Icons.favorite_border)),
            onPressed: (){
              product.togglenotifier(auth.token,auth.uId);
            },),)
          ,trailing: IconButton( onPressed: (){
            cart.addToCart(product.title, product.id, product.price,product.imageUrl);
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Product added to cart"),action: SnackBarAction(
              label: "Undo",onPressed: (){
            cart.RemoveItem(product.id);
            },
            ),));
          },color:Colors.amber, icon:
          Icon(Icons.shopping_cart),),title:Text(product.title),),
            child:
        Hero(
          tag: "image",
          child: Image.network(product.imageUrl,
            fit: BoxFit.fill,),
        )),
      ),
    );
  }
}
