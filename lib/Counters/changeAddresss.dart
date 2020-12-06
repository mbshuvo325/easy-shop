
import 'package:flutter/foundation.dart';

class AddressChanger extends ChangeNotifier{

  int _counter = 0;

  int get counter => _counter;

  displayresult(int number){
    _counter = number;
    notifyListeners();
  }
}