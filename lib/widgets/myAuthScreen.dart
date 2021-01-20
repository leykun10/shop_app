import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class MyAuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
    Stack(children: <Widget>[Container(decoration: BoxDecoration(
      gradient: LinearGradient(colors: [Colors.pink,Colors.blue],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        stops: [0.0,1]

      )
    ),),


   Column(children: <Widget>[
   Container(
     margin: EdgeInsets.only(left: 10,right: 20,top: 130),
     child: Transform(
         transform: Matrix4.rotationZ(-0.2),
         child: Text("Welcome!",style: GoogleFonts.raleway(fontSize: 50,color: Colors.white),

         )),
   height:  70,),
     
    Flexible(
        flex: 2,
        child: AuthForm())],) ],),);


  }
}
class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  @override
  Widget build(BuildContext context) {
    return Container(

      height: 300,
      padding: EdgeInsets.fromLTRB(30, 60, 30, 0),
      child: Form(
      child: SingleChildScrollView(

        child: Column(

        children: <Widget>[
          TextFormField(decoration: InputDecoration(icon: Icon(Icons.account_circle,size: 44,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
              labelText: "enter your email address",prefixIcon: Icon(Icons.email),hoverColor: Colors.black,
              focusColor: Colors.red,floatingLabelBehavior: FloatingLabelBehavior.auto)),
          SizedBox(height: 20,),
          TextFormField(


              decoration: InputDecoration(icon: Icon(Icons.vpn_key,size: 44,),


              border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
              labelText: "enter your password",fillColor: Colors.white,
              focusColor: Colors.white,floatingLabelBehavior: FloatingLabelBehavior.never))


        ,FlatButton(child: Text("Login")),FlatButton(child: Text("SignUp"),)],),
      ),
    ),
    );
  }
}

