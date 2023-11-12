import 'package:iwallet_case_study/src/domain/geo.dart';

class Address {
  String? street;
  String? suite;
  String? city;
  String? zipCode;
  Geo? geo;

  Address({
    this.street,
    this.suite,
    this.city,
    this.zipCode,
    this.geo,
  });

  Address.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    suite = json['suite'];
    city = json['city'];
    zipCode = json['zipcode'];
    geo = json['geo'] != null ? Geo.fromJson(json['geo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['street'] = street;
    data['suite'] = suite;
    data['city'] = city;
    data['zipcode'] = zipCode;
    if (geo != null) {
      data['geo'] = geo!.toJson();
    }
    return data;
  }
}
