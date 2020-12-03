import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/FirebaseService/auth.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}
class _LoginState extends State<Login>
{
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width, _screenheight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: Image.asset(
                  "images/login.png",
                height: 240.0,
                width: 240.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Login To Your Account",style: TextStyle(color: Colors.white),),
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data:Icons.email,
                    hintText: "Enter Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data:Icons.vpn_key,
                    hintText: "Enter Password",
                    isObsecure: true,
                  ),
                  RaisedButton(
                    color: Colors.pink,
                    child: Text("Sign In",style: TextStyle(color: Colors.white),),
                    onPressed: (){
                     _emailTextEditingController.text.isNotEmpty
                         && _passwordTextEditingController.text.isNotEmpty ?
                         loginUser(_emailTextEditingController.text, _passwordTextEditingController.text)
                         : showDialog(context: context,builder: (c){
                       return ErrorAlertDialog(message: "please Enter Email & Password",);
                     });
                    },
                  ),
                  SizedBox(height: 50,),
                  Container(
                    height: 4.0,
                    width: _screenwidth*0.8,
                    color: Colors.pink,
                  ),
                  SizedBox(height: 15.0,),
                  FlatButton.icon(
                      onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AdminSignInPage())),
                      icon: Icon(Icons.nature_people,color: Colors.pink,),
                      label: Text("I am Admin",style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
 void loginUser(String email, String password){
   showDialog(context: context,builder: (c){
     return LoadingAlertDialog(message: "Authenticating Please Wait...!",);
   });
    AuthenticationService.login(email, password).then((user){
      if(user != null){
        readData(user).then((value){
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => StoreHome()));
        });
      }
    }).catchError((error){
      showDialog(context: context,builder: (c){
        return ErrorAlertDialog(message: error.message.toString(),);
      });
   });
 }
 Future readData(User user) async{
   FirebaseFirestore.instance.collection("esusers").doc(user.uid).get().then((snapshot) async{
     await EcommerceApp.sharedPreferences.setString("id", snapshot.data()[EcommerceApp.userUID]);
     await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, snapshot.data()[EcommerceApp.userEmail]);
     await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, snapshot.data()[EcommerceApp.userName]);
     await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, snapshot.data()[EcommerceApp.userAvatarUrl]);
     List<String> cartList = snapshot.data()[EcommerceApp.userCartList].cast<String>();
     await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, cartList);
   });
 }
}
