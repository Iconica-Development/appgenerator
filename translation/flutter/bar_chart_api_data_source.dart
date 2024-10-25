//#pragma: imports
import 'package:http/http.dart' as http;
import 'dart:convert';

//#pragma: declaration
class HydroBarChartData {
  final String xLabel;
  final double yValue;

  HydroBarChartData(this.xLabel, this.yValue);
}

class BarChartApiDatasource extends ChangeNotifier {
  String url = "";
  List<HydroBarChartData>  response = [];
  BarChartApiDatasource({this.url = ""}) ;
  Map<String, List<HydroBarChartData> Function(dynamic apiData)> dataAdapters = {};
  Map<String, dynamic> filter = {};
  Map<String, String Function()> endpointBuilders = {};
  

  set ur(v) {
      url = v;
      notifyListeners();
      
  }
  List<HydroBarChartData> load() {
    var urlName = '';
    
    for (var endpointBuilderKey in endpointBuilders.keys) {
      var key = endpointBuilderKey;
      if (url.contains(key)) {
        urlName = key;
      }
    }

    var urlWithFilter = endpointBuilders[urlName]!();

    print('Loading data from $urlWithFilter');

    http.read(Uri.parse(urlWithFilter)).then((httpResponse) {
        response = dataAdapters[urlName]!(json.decode(httpResponse));
        notifyListeners();
      });
    return response;
  }

  setValue(u)  { url = u; () async { response = json.decode(await http.read(Uri.parse(url))); notifyListeners(); }();}
  void setFilter(Map<String, dynamic> filter)  { 
    var filterItems = <String, dynamic>{};
    this.filter.forEach((key, value) {
      filterItems[key] = value;
    });
    filter.forEach((key, value) {
      filterItems[key] = value;
    });
    this.filter = filterItems;
    load();
  }
  List<dynamic>  getValue()  { return response; }

  List<HydroBarChartData> localHostDataAdapter(dynamic apiData) {
    var data = apiData as List<dynamic>;
    var chartDataList = <HydroBarChartData>[];
    
    for (var chartDataEntry in data) {
      var entry = chartDataEntry as Map<String, dynamic>;
      var timestamp = entry['day'];
      var date = DateTime.parse(timestamp);
      var day = DateFormat('dd/MM').format(date);
      var rainfall = entry['rainfall'];
       chartDataList.add(HydroBarChartData(day, rainfall));
    }
    return chartDataList;
  }

  String localHostEndpointBuilder() {
    var filterString = '?';
    filterString += 'province=${filter['name']}&';
    // filterString += 'latitude=${filter['latitude']}&';
    // filterString += 'longitude=${filter['longitude']}&';
    return url + filterString;
  }
}
             
//#pragma: global
BarChartApiDatasource datasource[[id]] = BarChartApiDatasource(url:'[[url]]');



//#pragma: setup
datasource[[id]].addListener((){
  setState(() {});
});
datasource[[id]].dataAdapters['localhost'] = datasource[[id]].localHostDataAdapter;
datasource[[id]].endpointBuilders['localhost'] = datasource[[id]].localHostEndpointBuilder;
datasource[[id]].load();