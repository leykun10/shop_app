import 'package:flutter/material.dart';
class ProductDetailScreen extends StatelessWidget {
  final Map arguements;
  ProductDetailScreen(this.arguements);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body:
    CustomScrollView(slivers: [SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      title: Text(arguements['title']),
    flexibleSpace: FlexibleSpaceBar(background:Hero(
      tag: "image",
      transitionOnUserGestures: true,
      child: Image.network(arguements['image'],height:
      300,width: double.infinity,fit: BoxFit.cover,),
    ),),),
    SliverList(delegate: SliverChildListDelegate([SizedBox(height: 20,),Padding(
      padding: const EdgeInsets.fromLTRB(90, 0, 0, 0),
      child: Text("${arguements["price"]}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
    ),
      SizedBox(height: 10,)
      ,Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(arguements["description"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
      ),
    SizedBox(height: 1000,)]
        ),)],)
    );

  }
}
