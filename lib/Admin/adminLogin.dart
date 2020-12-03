import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{
  final TextEditingController _adminIDTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width, _screenheight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
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
              child: Text("Login To Admin Account",style: TextStyle(color: Colors.white),),
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIDTextEditingController,
                    data:Icons.person,
                    hintText: "Enter Admin Id",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data:Icons.vpn_key,
                    hintText: "Enter Admin Password",
                    isObsecure: true,
                  ),
                  RaisedButton(
                    color: Colors.pink,
                    child: Text("Log In",style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      _adminIDTextEditingController.text.isNotEmpty
                          && _passwordTextEditingController.text.isNotEmpty ?
                      loginAdmin()
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
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AuthenticScreen())),
                      icon: Icon(Icons.person_pin,color: Colors.pink,),
                      label: Text("I am not Admin",style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),)
                  ),
                  SizedBox(height: 50.0,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  loginAdmin(){
    FirebaseFirestore.instance.collection("esadmins").get().then((snapshot){
      snapshot.docs.forEach((result) {
        if(result.data()["id"] != _adminIDTextEditingController.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your Id is not Correct..!"),));
        }
        else if(result.data()["password"] != _passwordTextEditingController.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Your Password is not Correct..!"),));
        }
        else{
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Welcome Admin" + result.data()["name"]),));
          setState(() {
            _adminIDTextEditingController.text = "";
            _passwordTextEditingController.text = "";
          });
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UploadPage()));
        }
      });
    });
  }
}
