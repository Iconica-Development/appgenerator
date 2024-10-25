
//#pragma: declaration
class HydroTableColumn {
  const HydroTableColumn({
    required this.columnName,
    required this.jsonAttribute,
  });

  final String columnName;
  final String jsonAttribute;
}


//#pragma: execution
SizedBox(child:HydroTableColumn(
  columnName: "[[name]]",
  jsonAttribute: "[[json_attribute]]", 
),),