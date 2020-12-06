import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/FirebaseService/auth.dart';
import 'package:e_shop/Models/address.dart';
import 'package:e_shop/Orders//placeOrder.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/wideButton.dart';
import 'package:e_shop/Counters/changeAddresss.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addAddress.dart';

class Address extends StatefulWidget
{
  final double totalAmount;
  const Address({ Key key, this.totalAmount}) : super(key : key);
  @override
  _AddressState createState() => _AddressState();
}


class _AddressState extends State<Address>
{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Select Shipment Address",
                  style: TextStyle(color: Colors.black,fontFamily: "ConcertOne",fontWeight: FontWeight.bold,fontSize: 20.0),),
              ),
            ),
            Consumer<AddressChanger>(builder: (context, address, c){
              return Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("esusers").
                  doc(AuthenticationService.getCurrentUser()
                      .uid).collection(EcommerceApp.subCollectionAddress).snapshots(),
                  builder: (context, snapshot){
                    return !snapshot.hasData
                        ? Center(child: circularProgress(),)
                        : snapshot.data.docs.length == 0
                        ? noAddressCard()
                        : ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index){
                            return AddressCard(
                              value : index,
                              currentIndex: address.counter,
                              addressId: snapshot.data.docs[index].id,
                              totalAmount: widget.totalAmount,
                              model: AddressModel.fromJson(snapshot.data.docs[index].data()),
                            );
                          },
                         );
                  },
                ),
              );
            })
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) =>AddAddress())),
            icon: Icon(Icons.add_location,color: Colors.white,),
            backgroundColor: Colors.pink,
            label: Text("Add New Address",style: TextStyle(color: Colors.white),)),
      ),
    );
  }

  noAddressCard() {
    return Card(
      color: Colors.pink.withOpacity(0.5),
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_location,color: Colors.white,),
            Text("No Address has been Added",style: TextStyle(fontFamily: "ConcertOne",color: Colors.white),),
            Text("Please Add One For Shipment",style: TextStyle(fontFamily: "ConcertOne",color: Colors.white),),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;
  final String addressId;
  final double totalAmount;
  final int value;
  final int currentIndex;
  AddressCard({Key key, this.model, this.addressId, this.totalAmount, this.value , this.currentIndex}) : super(key : key);

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        Provider.of<AddressChanger>(context).displayresult(widget.value);
      },
      child: Card(
        color: Colors.pinkAccent.withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  groupValue: widget.currentIndex,
                  value: widget.value,
                  activeColor: Colors.pink,
                  onChanged: (value){
                    Provider.of<AddressChanger>(context, listen: false).displayresult(value);
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      width: screenWidth *0.8,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              KeyText(msg: "Name",),
                              Text(widget.model.name,style: TextStyle(fontFamily: "ConcertOne"),)
                            ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "Phone Number",),
                                Text(widget.model.phoneNumber,style: TextStyle(fontFamily: "ConcertOne"),)
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "Flat & Road",),
                                Text(widget.model.flatNumber,style: TextStyle(fontFamily: "ConcertOne"),)
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "City",),
                                Text(widget.model.city,style: TextStyle(fontFamily: "ConcertOne"),)
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "State / Country",),
                                Text(widget.model.state,style: TextStyle(fontFamily: "ConcertOne"),)
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "Zip Code",),
                                Text(widget.model.pincode,style: TextStyle(fontFamily: "ConcertOne"),)
                              ]
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            widget.value == Provider.of<AddressChanger>(context).counter 
                ? WideButton(
              msg: "Process",
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>PaymentPage(
                  addressId: widget.addressId,
                  totalAmount: widget.totalAmount,
                )));
              },
            ) 
                : Container(),
          ],
        ),
      ),
    );
  }
}





class KeyText extends StatelessWidget {

  final String msg;


  KeyText({ Key key, this.msg}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Text(msg,
      style:
      TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: "ConcertOne"
    ),);
  }
}
