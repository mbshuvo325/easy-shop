import 'dart:ffi';

import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:e_shop/FirebaseService/auth.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20.0, bottom: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink, Colors.lightGreenAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end:  const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                  elevation: 8.0,
                  child: Container(
                    height: 160.0,
                    width: 160.0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl),
                      )
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                Text(EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),style: TextStyle(
                  color: Colors.white,fontSize: 30,fontFamily: "ConcertOne"
                ),),
              ],
            ),
          ),
          SizedBox(height: 12.0,),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink, Colors.lightGreenAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end:  const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.home,color: Colors.lightGreenAccent,),
                  title: Text("Home",style: TextStyle(color: Colors.white,fontFamily: "ConcertOne",fontSize: 20),),
                  trailing: Icon(Icons.arrow_forward_ios,color: Colors.pink,),
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => StoreHome()));
                  },
                ),
                Divider(height: 10,color: Colors.white,thickness: 6.0,),
                ListTile(
                  leading: Icon(Icons.reorder,color: Colors.lightGreenAccent,),
                  title: Text("My Orders",style: TextStyle(color: Colors.white,fontFamily: "ConcertOne",fontSize: 20),),
                  trailing: Icon(Icons.arrow_forward_ios,color: Colors.pink,),
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyOrders()));
                  },
                ),
                Divider(height: 10,color: Colors.white,thickness: 6.0,),
                ListTile(
                  leading: Icon(Icons.shopping_cart,color: Colors.lightGreenAccent,),
                  title: Text("My Carts",style: TextStyle(color: Colors.white,fontFamily: "ConcertOne",fontSize: 20),),
                  trailing: Icon(Icons.arrow_forward_ios,color: Colors.pink,),
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CartPage()));
                  },
                ),
                Divider(height: 10,color: Colors.white,thickness: 6.0,),
                ListTile(
                  leading: Icon(Icons.search,color: Colors.lightGreenAccent,),
                  title: Text("Search",style: TextStyle(color: Colors.white,fontFamily: "ConcertOne",fontSize: 20),),
                  trailing: Icon(Icons.arrow_forward_ios,color: Colors.pink,),
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SearchProduct()));
                  },
                ),
                Divider(height: 10,color: Colors.white,thickness: 6.0,),
                ListTile(
                  leading: Icon(Icons.add_location,color: Colors.lightGreenAccent,),
                  title: Text("Add New Address",style: TextStyle(color: Colors.white,fontFamily: "ConcertOne",fontSize: 20),),
                  trailing: Icon(Icons.arrow_forward_ios,color: Colors.pink,),
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AddAddress()));
                  },
                ),
                Divider(height: 10,color: Colors.white,thickness: 6.0,),
                ListTile(
                  leading: Icon(Icons.power_settings_new,color: Colors.lightGreenAccent,),
                  title: Text("LogOut",style: TextStyle(color: Colors.white,fontFamily: "ConcertOne",fontSize: 20),),
                  trailing: Icon(Icons.arrow_forward_ios,color: Colors.pink,),
                  onTap: (){
                    showDialog(context: context,builder: (c){
                      return LoadingAlertDialog(message: "Logging Out...!",);
                    });
                    AuthenticationService.logOut().then((_){
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AuthenticScreen()));
                    });
                  },
                ),
                Divider(height: 10,color: Colors.white,thickness: 6.0,),
                Padding(
                  padding: const EdgeInsets.only(left: 70.0),
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app,color: Colors.lightGreenAccent,),
                    title: Text("Exit",style: TextStyle(color: Colors.white,fontFamily: "ConcertOne",fontSize: 20),),
                    onTap: (){
                        Navigator.of(context).pop();
                    },
                  ),
                ),
                Divider(height: 10,color: Colors.white,thickness: 6.0,),
              ],
            ),
          )
        ],
      ),
    );
  }
}
