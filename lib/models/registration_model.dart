import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class RegistrationModel {
  String profile_path;
  String name;
  String gender_code;
  String localbody_code;
  String desig_code;
  String mobile;
  String email;
  String dcode;
  String bcode;
  String pvcode;

  RegistrationModel({
    required this.profile_path,
    required this.name,
    required this.gender_code,
    required this.localbody_code,
    required this.desig_code,
    required this.mobile,
    required this.email,
    required this.dcode,
    required this.bcode,
    required this.pvcode,
  });

  RegistrationModel copyWith({
    String? profile_path,
    String? name,
    String? gender_code,
    String? localbody_code,
    String? desig_code,
    String? mobile,
    String? email,
    String? dcode,
    String? bcode,
    String? pvcode,
  }) {
    return RegistrationModel(
      profile_path: profile_path ?? this.profile_path,
      name: name ?? this.name,
      gender_code: gender_code ?? this.gender_code,
      localbody_code: localbody_code ?? this.localbody_code,
      desig_code: desig_code ?? this.desig_code,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      dcode: dcode ?? this.dcode,
      bcode: bcode ?? this.bcode,
      pvcode: pvcode ?? this.pvcode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'profile_path': profile_path,
      'name': name,
      'gender_code': gender_code,
      'localbody_code': localbody_code,
      'desig_code': desig_code,
      'mobile': mobile,
      'email': email,
      'dcode': dcode,
      'bcode': bcode,
      'pvcode': pvcode,
    };
  }

  Map<String, dynamic> toUpload() {
    return {
      'service_id': "register",
      'name': name,
      'gender_code': gender_code,
      'user_level': localbody_code,
      'desig_code': desig_code,
      'mobile_no': mobile,
      'email': email,
      'dcode': dcode,
      'bcode': bcode,
      'pvcode': pvcode,
      'photo': getImageBytes(profile_path),
    };
  }

  factory RegistrationModel.fromMap(Map<String, dynamic> map) {
    return RegistrationModel(
      profile_path: map['profile_path'].toString(),
      name: map['name'].toString(),
      gender_code: map['gender_code'].toString(),
      localbody_code: map['localbody_code'].toString(),
      desig_code: map['desig_code'].toString(),
      mobile: map['mobile'].toString(),
      email: map['email'].toString(),
      dcode: map['dcode'].toString(),
      bcode: map['bcode'].toString(),
      pvcode: map['pvcode'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory RegistrationModel.fromJson(String source) => RegistrationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RegistrationModel(profile_path: $profile_path, name: $name, gender_code: $gender_code, localbody_code: $localbody_code, desig_code: $desig_code, mobile: $mobile, email: $email, dcode: $dcode, bcode: $bcode, pvcode: $pvcode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegistrationModel &&
        other.profile_path == profile_path &&
        other.name == name &&
        other.gender_code == gender_code &&
        other.localbody_code == localbody_code &&
        other.desig_code == desig_code &&
        other.mobile == mobile &&
        other.email == email &&
        other.dcode == dcode &&
        other.bcode == bcode &&
        other.pvcode == pvcode;
  }

  @override
  int get hashCode {
    return profile_path.hashCode ^
        name.hashCode ^
        gender_code.hashCode ^
        localbody_code.hashCode ^
        desig_code.hashCode ^
        mobile.hashCode ^
        email.hashCode ^
        dcode.hashCode ^
        bcode.hashCode ^
        pvcode.hashCode;
  }

  String getImageBytes(String path) {
    Uint8List uint8list = Uint8List.fromList(File(path).readAsBytesSync());
    String bytes = base64Encode(uint8list);

    return bytes;
  }
}
