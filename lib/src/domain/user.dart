import 'package:iwallet_case_study/src/domain/address.dart';
import 'package:iwallet_case_study/src/domain/company.dart';
import 'package:iwallet_case_study/src/domain/photo.dart';

class User {
  User({
    this.id,
    this.name,
    this.username,
    this.email,
    this.address,
    this.phone,
    this.website,
    this.company,
    this.photo,
  });

  int? id;
  String? name;
  String? username;
  String? email;
  Address? address;
  String? phone;
  String? website;
  Company? company;
  Photo? photo;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    var emailComing = json['email'];
    if (emailComing != null) {
      email = emailComing.toString().toLowerCase();
    }
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    /* 
        1- \(?(\d{3})\)? - Matches the first three digits, which may or may not be enclosed in parentheses.
        2- [-. ]? - Optionally matches a separator (dash, dot, or space).
        3- (\d{3}) - Matches the next three digits.
        4- [-. ]? - Optionally matches another separator.
        5- (\d{4}) - Matches the last four digits.
         */
    var phoneComing = json['phone'];
    if (phoneComing != null) {
      var regex = RegExp(r'\(?(\d{3})\)?[-. ]?(\d{3})[-. ]?(\d{4})')
          .firstMatch(phoneComing);
      if (regex != null && regex.groupCount > 0) {
        phone = regex.group(1)! + regex.group(2)! + regex.group(3)!;
      }
    }

    website = json['website'];
    company =
        json['company'] != null ? Company.fromJson(json['company']) : null;
    photo = json['photo'] != null ? Photo.fromJson(json['photo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['phone'] = phone;
    data['website'] = website;
    if (company != null) {
      data['company'] = company!.toJson();
    }
    if (photo != null) {
      data['photo'] = photo!.toJson();
    }
    return data;
  }
}
