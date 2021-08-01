class GPSLink {
  String id;
  String name;
  double lat;
  double lng;
  int radius;
  String remember;

  GPSLink({this.id, this.lat, this.lng, this.radius, this.remember});

  GPSLink.fromID(this.id);

  GPSLink.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lat = json['lat'];
    lng = json['lng'];
    radius = json['radius'];
    remember = json['remember'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['radius'] = this.radius;
    data['remember'] = this.remember;
    return data;
  }
}
