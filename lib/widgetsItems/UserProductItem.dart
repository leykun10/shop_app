import 'package:flutter/material.dart';
import '../widgets/EditProductScreen.dart';
import '../provider/provider.dart';
import 'package:provider/provider.dart';
class UserProductItem extends StatelessWidget {
  final String image;
  final String title;
  final String id;

  UserProductItem({this.image,this.title,this.id});
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold.of(context);

    return ListTile(title: Text(title),leading: CircleAvatar(backgroundImage: NetworkImage(image),),trailing:
    Container(child: Row(children: <Widget>[IconButton(color: Colors.pinkAccent,icon: Icon(Icons.edit),onPressed:
    (){
      Navigator.pushNamed(context, EditProductScreen.route,arguments: {"id":id,"new":false});
    },
    ),IconButton(icon: Icon(Icons.delete,color: Colors.red,),onPressed: (){
      Provider.of<Products>(context,listen: false).removeProduct(id).catchError((error){
        scaffold.showSnackBar(SnackBar(content: Text("Deleting failed"),));
      });
    },)],),width: 100),);
  }
}
