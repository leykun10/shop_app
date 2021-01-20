import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/AuthData.dart';
import 'package:shopapp/provider/Cart.dart';
import 'package:shopapp/provider/provider.dart';
import 'widgets/productScreenOverview.dart';
import 'widgets/productDetailScreen.dart';
import 'package:shopapp/provider/Order.dart';
import 'widgets/ErrorScreen.dart';
import 'widgets/LoadingSpinner.dart';
import 'widgets/CartScreen.dart';
import 'widgets/OrdersScreen.dart';
import 'widgets/UserProductScreen.dart';
import 'widgets/EditProductScreen.dart';
import 'widgets/AuthScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (ctx)=>Auth(),),
      ChangeNotifierProxyProvider<Auth,Products>(
    update: (ctx,auth,previous)=> Products(auth.token,previous==null?[]:previous.items,auth.uId)),
      ChangeNotifierProvider(
          create: (ctx)=> (Cart())) ,
      ChangeNotifierProxyProvider<Auth,Order>(
          update: (ctx,auth,previous)=> Order(auth.token,previous==null?[]:previous.orders,auth.uId))
    ],
      child: Consumer<Auth>(builder: (ctx,auth,_)=>MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.purple,
            accentColor: Colors.orange,
            fontFamily: "Lato",
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
             home: auth.isAuth?ProductScreen():
             FutureBuilder(future: auth.tryAutoLogin(),
             builder: (ctx,snapshot)=>snapshot.connectionState==ConnectionState.waiting?
                Indicator():AuthScreen(),),
          onGenerateRoute: (setting){
            if(setting.name=="/"){return MaterialPageRoute(builder: (context){
              return ProductScreen();});
            }
            else if(setting.name=='/auth'){
              return MaterialPageRoute(builder: (context)=>AuthScreen());
            }
            else if(setting.name=="/detailScreen"){
              return MaterialPageRoute(builder: (context){
                return ProductDetailScreen(setting.arguments); });
            }
            else if(setting.name==CartScreen.routname){
              return MaterialPageRoute(builder: (context){
                return CartScreen();});
            }
            else if(setting.name==OrderScreen.route){
              return MaterialPageRoute(builder: (context){
                return OrderScreen();
              });

            }
            else if(setting.name==UserProductScreen.route){
              return MaterialPageRoute(builder: (context){
                return UserProductScreen();
              });

            }
            else if(setting.name==EditProductScreen.route){
              return MaterialPageRoute(builder: (context){
                return EditProductScreen(setting.arguments);
              });

            }
            return MaterialPageRoute(builder: (context){
              return ErrorScreen();});
          }
      )) ,);
  }
}
