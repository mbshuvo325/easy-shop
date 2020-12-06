import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/FirebaseService/auth.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Models/address.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatelessWidget {

  final formKey = GlobalKey<FormState>();
  final scafoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhone = TextEditingController();
  final cFlatRoad = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cZipCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scafoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: (){
              if(formKey.currentState.validate()){

                final model = AddressModel(
                  name: cName.text.trim(),
                  phoneNumber: cPhone.text,
                  flatNumber: cFlatRoad.text,
                  city: cCity.text.trim(),
                  state: cState.text.trim(),
                  pincode: cZipCode.text,
                ).toJson();
                FirebaseFirestore.instance.collection("esusers").doc(AuthenticationService.getCurrentUser().uid).
                collection(EcommerceApp.subCollectionAddress).doc(DateTime.now().millisecondsSinceEpoch.toString()).
                set(model).then((value){
                  final snak = SnackBar(content: Text("New Address Added Successfully"),);
                  scafoldKey.currentState.showSnackBar(snak);
                  FocusScope.of(context).requestFocus(FocusNode());
                  formKey.currentState.reset();
                });
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Address()));
              }
            },
            icon: Icon(Icons.check,color: Colors.white,),
            backgroundColor: Colors.pink,
            label: Text("Done",style: TextStyle(color: Colors.white),)),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Add New Address",
                    style: TextStyle(color: Colors.black,fontFamily: "ConcertOne",fontSize: 20,fontWeight: FontWeight.bold),),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hintText: "name",
                      controller: cName,
                    ),
                    MyTextField(
                      hintText: "Phonenumber",
                      controller: cPhone,
                    ),
                    MyTextField(
                      hintText: "Flat & Road",
                      controller: cFlatRoad,
                    ),
                    MyTextField(
                      hintText: "City",
                      controller: cCity,
                    ),
                    MyTextField(
                      hintText: "State / Country",
                      controller: cState,
                    ),
                    MyTextField(
                      hintText: "ZipCode",
                      controller: cZipCode,
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
}

class MyTextField extends StatelessWidget {
 final String hintText;
 final TextEditingController controller;

 MyTextField({Key key , this.hintText, this.controller}): super(key : key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hintText),
        validator: (value) => value.isEmpty ? "Filed Can not be Empty" : null,
      ),
    );
  }
}
