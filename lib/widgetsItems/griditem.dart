import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/provider.dart';
import '../widgetsItems/productItem.dart';
class GridViewItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

   final products_data = Provider.of<Products>(context);
   final loadedProducts = products_data.showoption?products_data.items:products_data.items.where((element) => element.isFavourite).toList();

     return GridView.builder(gridDelegate:
    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
        childAspectRatio: 1.5,crossAxisSpacing: 10,mainAxisSpacing: 10),
      itemBuilder: (context,index){
        return ChangeNotifierProvider.value(

            value: loadedProducts[index],
            child: ProductItem());
      },itemCount: loadedProducts.length,);
  }
}
