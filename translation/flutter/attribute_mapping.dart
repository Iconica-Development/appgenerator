//#pragma: execution
AttributeMapping(
  attributeName: '[[name]]',
  jsonAttribute: '[[attribute]]', 
),

//#pragma: declaration
class AttributeMapping {
  AttributeMapping({
    required this.attributeName,
    required this.jsonAttribute,
  });
  final String attributeName;
  final String jsonAttribute;
}

