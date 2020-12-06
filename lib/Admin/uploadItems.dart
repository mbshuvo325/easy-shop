import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;


class UploadPage extends StatefulWidget
{
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>
{
  bool get wantKeepAlive => true;
  File file;
  String uploadfile;
  TextEditingController _descriptionTextEditingcontriller = TextEditingController();
  TextEditingController _priceTextEditingcontriller = TextEditingController();
  TextEditingController _titleEditingcontriller = TextEditingController();
  TextEditingController _shortInfoEditingcontriller = TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return file == null ?  adminHomeScreen() : displayAdminUploadScreen();
  }
  adminHomeScreen(){
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
        title: Text("Admin",style: TextStyle(fontSize: 45,fontFamily: "Signatra",color: Colors.white),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.border_color,color: Colors.white,),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminShiftOrders()));
            },
          ),
          IconButton(
            icon: Icon(Icons.power_settings_new,color: Colors.white,),
            onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SplashScreen()));
            },
          )
        ],
      ),
      body: adminPageBody(),
    );
  }
  adminPageBody(){
    return Container(
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
          children: [
            Icon(Icons.shop_two,color: Colors.white,size: 200.0,),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
                child: Text("Add new Items",style: TextStyle(fontSize: 20,color: Colors.white),),
                color: Colors.green,
                onPressed: (){
                  takeImage(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
  takeImage(context){
    return showDialog(context: context,builder: (con){
      return SimpleDialog(
        title: Text("Item Image",style: TextStyle(color: Colors.pinkAccent,fontWeight: FontWeight.bold),),
        children: [
          SimpleDialogOption(
            child: Text("Capture With Camera",style: TextStyle(color: Colors.green),),
            onPressed: captureImage,
          ),
          SimpleDialogOption(
            child: Text("Select From Gallery",style: TextStyle(color: Colors.green),),
            onPressed: pickFromGallery,
          ),
          SimpleDialogOption(
            child: Text("Cancel",style: TextStyle(color: Colors.pink),),
            onPressed: (){
              Navigator.of(context).pop();
            }
          ),
        ],
      );
    });
  }
  captureImage() async{
    Navigator.of(context).pop();
   File imagefile = await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 680,maxWidth: 970);
   setState(() {
     file = imagefile;
   });
  }
  pickFromGallery() async{
    Navigator.of(context).pop();
    File imagefile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = imagefile;
    });
  }

  displayAdminUploadScreen(){
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
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),
        onPressed: (){
          clearinfo();
        },
        ),
        title: Text("Add New products",style: TextStyle(fontSize: 24,color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.library_add,color: Colors.white,),
            onPressed: (){
              uploading ? null : uloadImageAndSaveitem();
              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminShiftOrders()));
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.height*0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(image: DecorationImage(image: FileImage(file),fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0)),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Colors.pink,),
            title: Container(
              width: 150.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _shortInfoEditingcontriller,
                decoration: InputDecoration(
                  hintText: "Short info",hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Colors.pink,),
            title: Container(
              width: 150.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _titleEditingcontriller,
                decoration: InputDecoration(
                  hintText: "Title",hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Colors.pink,),
            title: Container(
              width: 150.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _descriptionTextEditingcontriller,
                decoration: InputDecoration(
                  hintText: "Description",hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Colors.pink,),
            title: Container(
              width: 150.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _priceTextEditingcontriller,
                decoration: InputDecoration(
                  hintText: "Price",hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,),
        ],
      ),
    );
  }
  clearinfo(){
    setState(() {
      file = null;
      _titleEditingcontriller.clear();
      _descriptionTextEditingcontriller.clear();
      _shortInfoEditingcontriller.clear();
      _priceTextEditingcontriller.clear();
    });
  }
  uloadImageAndSaveitem() async{
    setState(() {
      uploading = true;
      uploadfile = file.path;
    });
    await uploadImage(uploadfile).then((imageDownloadUrl){
     saveIteminfo(imageDownloadUrl);
   });
  }
 Future<String> uploadImage(imagefile) async{
   String imageFileName  = DateTime.now().millisecondsSinceEpoch.toString();
   StorageReference rootRef = FirebaseStorage.instance.ref();
   StorageReference photoRef = rootRef.child("EshopProduceImage").child(imageFileName);
   final upLoadTask = photoRef.putFile(File(imagefile));
   final snapshot = await upLoadTask.onComplete;
   final url = await (snapshot.ref.getDownloadURL());
   return url;
  }
  saveIteminfo(String imageUrl){
    FirebaseFirestore.instance.collection("eshopItem").doc(productId).set({
      "shortInfo" : _shortInfoEditingcontriller.text.trim(),
      "longDescription" : _descriptionTextEditingcontriller.text.trim(),
      "price" : int.parse(_priceTextEditingcontriller.text),
      "publishedDate" :DateTime.now(),
      "status" : "Avaible",
      "thumbnailUrl" : imageUrl,
      "title" : _titleEditingcontriller.text.trim(),
    });
    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _shortInfoEditingcontriller.clear();
      _descriptionTextEditingcontriller.clear();
      _titleEditingcontriller.clear();
      _priceTextEditingcontriller.clear();
    });
  }
}
