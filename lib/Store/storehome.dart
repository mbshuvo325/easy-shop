import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/FirebaseService/auth.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 5.0,
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
        ),
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned: true,delegate: SearchBoxDelegate(),),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("eshopItem")
                  .limit(15).orderBy("publishedDate",descending: true).snapshots(),
              builder: (context,datasnapshot){
                return datasnapshot.hasData ? SliverStaggeredGrid.
                countBuilder(crossAxisCount: 1,
                    staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                    itemBuilder: (context,index){
                    ItemModel model = ItemModel.fromJson(datasnapshot.data.docs[index].data());
                    return sourceInfo(model, context);
                    },
                    itemCount: datasnapshot.data.docs.length
                ) : SliverToBoxAdapter(child: Center(child: circularProgress(),),);
              },
            )
          ],
        ),
      ),
    );
  }
}



Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: (){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductPage(itemModel: model)));
    },
    splashColor: Colors.pink,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 190.0,
        width: width,
        child: Row(
          children: [
            Image.network(model.thumbnailUrl,width: 140,height: 140,),
            SizedBox(width: 4.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.0,),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(model.title,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontFamily: "ConcertOne"
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(model.shortInfo,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12.0,
                                fontFamily: "ConcertOne"
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.pink,
                        ),
                        alignment: Alignment.topLeft,
                        width: 40,
                        height: 43,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("50%",style: TextStyle(fontSize: 15.0,color: Colors.white,fontWeight: FontWeight.normal),),
                              Text("OFF",style: TextStyle(fontSize: 12.0,color: Colors.white,fontWeight: FontWeight.normal),)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text( r"Original Price: ৳",
                                  style: TextStyle(fontSize: 14.0,color: Colors.grey,
                                      decoration: TextDecoration.lineThrough),),
                                Text( (model.price+model.price).toString(),
                                  style: TextStyle(fontSize: 15.0,color: Colors.grey,
                                      decoration: TextDecoration.lineThrough),),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Text( r"New Price: ",
                                  style: TextStyle(fontSize: 14.0,color: Colors.grey),),
                                Text( "৳",
                                  style: TextStyle(fontSize: 16.0,color: Colors.red),),
                                Text(model.price.toString(),
                                  style: TextStyle(fontSize: 15.0,color: Colors.pink),),
                              ],
                            ),
                          )

                        ],
                      )
                    ],
                  ),
                  Flexible(
                    child: Container(
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: removeCartFunction == null
                        ? IconButton(
                          onPressed:(){
                            checkItemInCart(model.shortInfo, context);
                          },
                         icon: Icon(Icons.add_shopping_cart,color: Colors.pink,size: 30,),
                          ) :IconButton(
                      onPressed:() {
                        removeCartFunction();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>StoreHome()));
                      },
                      icon: Icon(Icons.delete,color: Colors.pink,size: 30,),
                  )
                  ),
                  Divider(
                    height: 5.0,
                    color: Colors.pink,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}



Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 150,
    width: width*0.34,
    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: <BoxShadow>
      [BoxShadow(offset: Offset(0,5),blurRadius: 10,color: Colors.grey[200]) ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(imgPath,height: 150,width: width*0.34,fit: BoxFit.fill,),
    ),
  );
}



void checkItemInCart(String shortInfoAsId, BuildContext context)
{
  EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).contains(shortInfoAsId)
      ? Fluttertoast.showToast(msg: "Item Already In CartList")
      : addItemToCArt(shortInfoAsId, context);
}
addItemToCArt(String shortInfo,BuildContext context){
  List tempCartList = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  tempCartList.add(shortInfo);

  FirebaseFirestore.instance.collection("esusers").
  doc(AuthenticationService.getCurrentUser().uid).
  update({
    EcommerceApp.userCartList : tempCartList
  }).then((value){
    Fluttertoast.showToast(msg: "Item SuccesFully Added To Cart");
    EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempCartList);
    Provider.of<CartItemCounter>(context, listen:  false).displayResult();
  });
}
