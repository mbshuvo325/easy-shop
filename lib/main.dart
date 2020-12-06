import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Counters/ItemsQuantity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => CartItemCounter(),),
        ChangeNotifierProvider(create: (c) => ItemkQuantity(),),
        ChangeNotifierProvider(create: (c) => AddressChanger(),),
        ChangeNotifierProvider(create: (c) => TotalAmount(),),
      ],
      child: MaterialApp(
              title: 'e-Shop',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: Colors.green,
              ),
              home: SplashScreen()
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    displaySplesh();
  }
  displaySplesh(){
    Timer(Duration(seconds: 5), () async{
      if( await EcommerceApp.auth.currentUser != null){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>StoreHome()));
      }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>AuthenticScreen()));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.lightGreenAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end:  const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Welcome",style: TextStyle(color: Colors.white,fontSize: 25,fontFamily: "ConcertOne"),),
              SizedBox(height: 20,),
              Image.asset("images/welcome.png"),
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("World number '1' online Shopping platform",
                  style: TextStyle(color: Colors.white,fontSize: 17,fontFamily: "ConcertOne"),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
