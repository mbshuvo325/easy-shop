import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyAppBar extends StatelessWidget with PreferredSizeWidget
{
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.lightGreenAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end:  const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
      title: Text("Easy-Shop",style: TextStyle(fontSize: 45,fontFamily: "Signatra",color: Colors.white),),
      centerTitle: true,
      bottom: bottom,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.shopping_cart,color: Colors.pink,),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartPage()));
              },
            ),
            Positioned(
              child: Stack(
                children: [
                  Icon(
                    Icons.brightness_1,
                    color: Colors.green,
                  ),
                  Positioned(
                    top: 5.0,
                    bottom: 3.0,
                    left: 8.0,
                    child: Consumer<CartItemCounter>(
                        builder: (context, counter, _){
                          return Text((EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length-1).toString(),
                            style: TextStyle(color: Colors.white,fontSize: 12.0,fontWeight: FontWeight.w500),
                          );
                        }
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );

  }


  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}
