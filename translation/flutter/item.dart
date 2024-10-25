class Item {
  String title;
  String subtitle;
  String longitude;
  String latitude;
  String image;
  String detailtext;
  String tag;
  String icon;
  Map<String, dynamic> additionalAttributes;

  Item(
      {this.title = "",
      this.subtitle = "",
      this.longitude = "",
      this.latitude = "",
      this.image = "",
      this.detailtext = "",
      this.tag = "",
      this.icon = "",
      this.additionalAttributes = const {}});

  Item.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        subtitle = json['subtitle'],
        longitude = json['longitude'],
        latitude = json['latitude'],
        image = json['image'],
        detailtext = json['detailtext'],
        tag = json['tag'],
        icon = json['icon'],
        additionalAttributes = json;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'longitude': longitude,
      'latitude': latitude,
      'image': image,
      'detailtext': detailtext,
      'tag': tag,
      'icon': icon,
      ...additionalAttributes
    };
  }
}
