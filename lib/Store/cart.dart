import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/FirebaseService/auth.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Counters/totalMoney.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  double totalAmount;
  @override
  void initState() {
    super.initState();
    totalAmount = 0;
    Provider.of<TotalAmount>(context , listen: false).display(0);
  }
  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            if(EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length ==1){
              Fluttertoast.showToast(msg: "Your CartList Is Empty");
            }else{
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Address(totalAmount: totalAmount)));
            }
          },
          label: Text("Cheeck Out",style: TextStyle(fontFamily: "ConcertOne"),),backgroundColor: Colors.pink,
        icon: Icon(Icons.navigate_next,color: Colors.white,),
      ),
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(builder: (context , amountProvier, cartProvider, c){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: cartProvider.count == 0
                      ? Container()
                      : Text("Total Amount: ৳ ${amountProvier.amount.toString()}",
                    style: TextStyle(color: Colors.black,fontSize: 20.0,
                        fontWeight: FontWeight.w500,fontFamily: "Concertone"), ),
                ),
              );
            },),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("eshopItem").
            where("shortInfo", whereIn: EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList)).snapshots(),
            builder: (context,snapshot){
              return !snapshot.hasData
                  ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                  : snapshot.data.docs.length == 0
                  ? begunBuildingCart()
                  : SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index){
                          ItemModel model = ItemModel.fromJson(snapshot.data.docs[index].data());
                          if(index == 0){
                            totalAmount = 0;
                            totalAmount = model.price+totalAmount;
                          }else{
                            totalAmount = model.price+totalAmount;
                          }
                          if(snapshot.data.docs.length -1 == index){
                            WidgetsBinding.instance.addPostFrameCallback((t) {
                              Provider.of<TotalAmount>(context,listen: false).display(totalAmount);
                            });
                          }
                          return sourceInfo(model, context,
                              removeCartFunction: () =>removeItemFromUserCart(model.shortInfo));
                        },
                      childCount: snapshot.hasData ? snapshot.data.docs.length : 0,
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
  begunBuildingCart(){

    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
          height: 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_emoticon,color: Colors.yellow,),
              Text("CartList Is Empty",style: TextStyle(color: Colors.white,fontFamily: "ConcertOne"),),
              Text("Start Adding Products",style: TextStyle(color: Colors.white,fontFamily: "ConcertOne"),),
            ],
          ),
        ),
      ),
    );

  }
  removeItemFromUserCart(String shortInfoAsId){
    List tempCartList = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    tempCartList.remove(shortInfoAsId);

    FirebaseFirestore.instance.collection("esusers").
    doc(AuthenticationService.getCurrentUser().uid).
    update({
      EcommerceApp.userCartList : tempCartList
    }).then((value){
      Fluttertoast.showToast(msg: "Item SuccesFully Removed From Cart");
      EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempCartList);
      Provider.of<CartItemCounter>(context, listen:  false).displayResult();

      totalAmount = 0;
    });
  }
}
