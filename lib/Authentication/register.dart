import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/FirebaseService/DBFirebase.dart';
import 'package:e_shop/FirebaseService/auth.dart';
import 'package:e_shop/Models/user.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register>
{
  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _cpasswordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String uid;
  var user = ESUser();
   String _imageurl = '';
   File _imageFile;
   String _imageFileUp;
   String email;
   String password;
  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width, _screenheight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 10.0,),
            InkWell(
              onTap: (){
                _imagePick();
              },
              child: CircleAvatar(
                radius: _screenheight*0.15,
                backgroundColor: Colors.white,
                backgroundImage: _imageFile ==null ? null
                    : FileImage(_imageFile),
                child: _imageFile == null ?
                Icon(Icons.add_photo_alternate,size: _screenheight*0.15,color: Colors.grey,)
                    : null,
              ),
            ),
            SizedBox(height: 8.0,),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameTextEditingController,
                    data:Icons.person,
                    hintText: "Enter Name",
                    isObsecure: false,
                  ),
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
                  CustomTextField(
                    controller: _cpasswordTextEditingController,
                    data:Icons.vpn_key,
                    hintText: "Confirm Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              color: Colors.pink,
              child: Text("Sign up",style: TextStyle(color: Colors.white),),
              onPressed: (){
               _uploadImageAndSave();
              },
            ),
            SizedBox(height: 30,),
            Container(
              height: 4.0,
              width: _screenwidth*0.8,
              color: Colors.pink,
            ),
            SizedBox(height: 15.0,),
          ],
        ),
      ),
    );
  }
  Future<void>_imagePick() async{
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFileUp = _imageFile.path;
      //print(_imageFileUp);
    });
  }
  Future<void>_uploadImageAndSave()async{
    if(_imageFile == null){
      showDialog(context: context,builder: (c){
        return ErrorAlertDialog(message: "please select a photo",);
      });
    }else{
      _passwordTextEditingController.text == _cpasswordTextEditingController.text
          ? _emailTextEditingController.text.isNotEmpty
          && _passwordTextEditingController.text.isNotEmpty
          && _cpasswordTextEditingController.text.isNotEmpty
          && _nameTextEditingController.text.isNotEmpty
          ? uploadImage()
          : displayDialoague("Fill all the Field..!") 
          : displayDialoague("password don't  match!");
    }
  }
  displayDialoague(String msg){
    showDialog(context: context,builder: (c){
      return ErrorAlertDialog(message: msg,);
    });
  }
  Future uploadImage() async{
    showDialog(context: context,builder: (c){
      return LoadingAlertDialog(message: "Regestering Please Wait...!",);
    });
    String imageFileName  = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference rootRef = FirebaseStorage.instance.ref();
    StorageReference photoRef = rootRef.child("EshopUser_Image").child(imageFileName);
    final upLoadTask = photoRef.putFile(File(_imageFileUp));
    final snapshot = await upLoadTask.onComplete;
    final url = await (snapshot.ref.getDownloadURL());
    setState(() {
      _imageurl = url;
      user.imageUrl = _imageurl;
      print(user.imageUrl);
      _registerUser();
    });
  }
  void _registerUser() async{
    final email =  _emailTextEditingController.text;
    final password = _passwordTextEditingController.text;
    AuthenticationService.register(email, password ).then((firebaseuser){
      //Save User info
      //User firebaseuser = AuthenticationService.auth.currentUser;
      saveUserinfoToFireStore(firebaseuser);
      if(firebaseuser != null){
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => StoreHome()));
      }
    }).catchError((error){
      showDialog(context: context,builder: (c){
        return ErrorAlertDialog(message: error,);
      });
    });
  }
  Future saveUserinfoToFireStore(User fUser) async{
   /* DBFirebaseHelper.insertUser(user).then((value) async{*/
    FirebaseFirestore.instance.collection("esusers").doc(fUser.uid).set({
      "uid" : fUser.uid,
      "email" : fUser.email,
      "name" : _nameTextEditingController.text.trim(),
      "url" : _imageurl,
      EcommerceApp.userCartList : ["garbageValue"],
    });
      await EcommerceApp.sharedPreferences.setString("id", user.id);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, user.email);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, _nameTextEditingController.text);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, _imageurl);
      await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, ["garbageValue"]);
   /* });*/
  }
}

