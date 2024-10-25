import 'attribute_mapping.dart';


//#pragma: declaration
class DataMapper {
  DataMapper({required this.attributeMappings});
  final List<AttributeMapping> attributeMappings;

  Map<String, String> get mappingsAsMap => Map.fromEntries(attributeMappings.map((e) => MapEntry(e.attributeName, e.jsonAttribute)));
}

//#pragma: execution
DataMapper(
  attributeMappings: [
    [[mappings]]
  ],
),