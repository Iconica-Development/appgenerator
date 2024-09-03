//#pragma: imports
import 'dart:async';

//#pragma: declaration
class DataSource extends ChangeNotifier {
  int _value = 0;
  DataSource() {
    Timer.periodic(Duration(seconds: 1), (t){
        this.value = this._value + 1;
  });
  }
  set value(v) {
      _value = v;
      notifyListeners();
      
  }

  reset(argument) {
    this.value = 0;
    notifyListeners(); 
  }
  
  refresh(argument) {
    notifyListeners(); 
  }

  setValue(v) { _value = v; notifyListeners(); }
  getValue() { return _value; }
}
             
//#pragma: global
DataSource datasource[[id]] = DataSource();

//#pragma: setup
datasource[[id]].addListener((){
  setState(() {});
});