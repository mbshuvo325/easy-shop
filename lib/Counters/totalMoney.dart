import 'package:flutter/cupertino.dart';

class TotalAmount extends ChangeNotifier{

  double _amount = 0;

  double get amount => _amount;
  display(double number) async{
    _amount = number;
    await Future.delayed(Duration(milliseconds: 100),(){
      notifyListeners();
    });
  }
}