import 'package:flutter/material.dart';


class WideButton extends StatelessWidget {

  final String msg;
  final Function onPressed;


  WideButton({ Key key, this.msg, this.onPressed}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:  10, bottom: 10),
      child: Center(
        child: InkWell(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(color: Colors.pink),
            width: MediaQuery.of(context).size.width * 0.85,
            height: 50.0,
            child: Center(
              child: Text(msg,style: TextStyle(color: Colors.white),),
            ),
          ),
        ),
      ),
    );
  }
}
