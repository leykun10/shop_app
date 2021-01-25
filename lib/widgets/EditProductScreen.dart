import 'dart:ui';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import '../model/product.dart';
import 'package:provider/provider.dart';
import '../provider/provider.dart';
class EditProductScreen extends StatefulWidget {

  static final String route= 'EditProductScreen';
  final Map<String,Object> id;
  EditProductScreen(this.id);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  @override
  void initState() {
    if(!widget.id["new"]){
      editedProduct= Provider.of<Products>(context,listen: false).items.firstWhere((element) => element.id==widget.id["id"]);
      urlController.text=editedProduct.imageUrl;
      titleController.text=editedProduct.title;
      priceController.text=editedProduct.price.toString();
      descriptionController.text=editedProduct.description;
    }

    urlFocusNode.addListener(() { if(!urlFocusNode.hasFocus){

      if(urlController.text.isEmpty||!urlController.text.startsWith("http")||!urlController.text.startsWith("https")||

      !urlController.text.endsWith(".com")){
        return;
      }

      setState(() {

      });
    }});
    // TODO: implement initState
    super.initState();
  }
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    urlFocusNode.dispose();
    descriptionFocus.dispose();
    priceFocusNode.dispose();
    urlController.dispose();
  }
  Product product;
  Product editedProduct;

  var formkey = GlobalKey<FormState>();
  final descriptionFocus =FocusNode();
  final priceFocusNode =FocusNode();
  final urlController=TextEditingController();
  final titleController=TextEditingController();
  final priceController=TextEditingController();
  final descriptionController=TextEditingController();
  final urlFocusNode = FocusNode();
  bool loading=false;

 Future <void> formState() async{
   bool isValid=formkey.currentState.validate();
    if(!isValid){
      return null;
    }
    formkey.currentState.save();
   setState(() {
    loading=true;
   });

   try{widget.id["new"]?await Provider.of<Products>(context,listen: false).addProduct(product):
   await Provider.of<Products>(context,listen: false).updateProduct(product.id,product);
     Navigator.pop(context);
     }
     catch (error){
       showDialog (context: context, builder: (ctx) =>
           AlertDialog (title: Text ("error occurred"),content: Text("check your internet connection"),
             actions: <Widget>[FlatButton (child: Text ("okay"), onPressed: () {
               Navigator.of (ctx).pop ();
               Navigator.pop (context);
             },)
             ],));
     }

  }
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Edit products"),),
    body: loading?Center(child: CircularProgressIndicator(),):Padding(

      padding: const EdgeInsets.all(15.0),
      child: Consumer<Products>(
        builder: (context,products,child) {
          return Form (key: formkey, child: ListView (children: <Widget>[

            TextFormField (
              controller: titleController,
              onFieldSubmitted: (_) {
                FocusScope.of (context).requestFocus (priceFocusNode);
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration (labelText: "Title"),
              validator: (value) {
                if (value.isEmpty) {
                  return "empty value not accepted";
                }
                return null;
              },)
            ,
            TextFormField (
              onFieldSubmitted: (_) {
                FocusScope.of (context).requestFocus (descriptionFocus);
              },
              controller: priceController,
              focusNode: priceFocusNode,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration (labelText: "Price"),
              validator: (value) {
                if (value.isEmpty) {
                  return "empty value not accepted";
                }
                else if (double.parse (value) == null) {
                  return "enter a valid price";
                }

                else if (double.parse (value) == 0) {
                  return " a price should have value greater than 0";
                }

                return null;
              },),
            TextFormField (
              maxLines: 3,
              focusNode: descriptionFocus,
              controller: descriptionController,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration (labelText: "Description",),
              validator: (value) {
                if (value.isEmpty) {
                  return "error";
                }
                if (value.length < 10) {
                  return "a description should have at least 10 characters";
                }
                return null;
              },),
            Row (crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
              Container (child: urlController.text.isEmpty ? Text ("No image") :
              FittedBox (child: Image.network (
                urlController.text, fit: BoxFit.cover,),)
                ,
                width: 100,
                height: 100,
                margin: EdgeInsets.fromLTRB (0, 10, 10, 0),
                decoration: BoxDecoration (border: Border.all (
                    color: Colors.grey, width: 1)),)
              ,
              Expanded (child: TextFormField (decoration: InputDecoration (
                  labelText: "Enter a URL"),
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                controller: urlController,
                focusNode: urlFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter an image URL.';
                  }
                  if (!value.startsWith ('http') &&
                      !value.startsWith ('https')) {
                    return 'Please enter a valid URL.';
                  }
                  if (value.endsWith ('.png') &&
                      value.endsWith ('.jpg') &&
                      value.endsWith ('.jpeg')) {
                    return 'Please enter a valid image URL.';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  formState ();
                },
                onSaved: (_) {
                  product = widget.id["new"] ? Product (
                      id: DateTime.now ().toString (),
                      title: titleController.text,
                      price: double.parse (priceController.text),
                      description: descriptionController.text,
                      imageUrl: urlController.text,
                      isFavourite: false) : Product (id: editedProduct.id,
                      title: titleController.text,
                      price: double.parse (priceController.text),
                      description: descriptionController.text,
                      imageUrl: urlController.text,
                      isFavourite: editedProduct.isFavourite);
                },


              ),)
            ],)
            ,
            SizedBox (height: 20,),
            RaisedButton (
              color: Colors.purple,
              child: Text ("Submit",
                style: TextStyle (fontSize: 22, color: Colors.white),),
              onPressed: () {
                formState();
              },)
          ],),);

        }),
    ),);
  }
}
