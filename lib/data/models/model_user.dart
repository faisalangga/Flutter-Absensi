class UserModel {
  List<Data>? data;
  String? pesan;
  String? status;

  UserModel({this.data, this.pesan, this.status});

  UserModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    pesan = json['pesan'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['pesan'] = this.pesan;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  String? cBranch;
  String? cCompcode;
  String? cDesc;
  String? cLat;
  String? cLong;
  String? cPassword;
  String? jarak_radius;

  Data(
      {this.cBranch,
        this.cCompcode,
        this.cDesc,
        this.cLat,
        this.cLong,
        this.cPassword,
        this.jarak_radius});

  Data.fromJson(Map<String, dynamic> json) {
    cBranch = json['cBranch'];
    cCompcode = json['cCompcode'];
    cDesc = json['cDesc'];
    cLat = json['cLat'];
    cLong = json['cLong'];
    cPassword = json['cPassword'];
    jarak_radius = json['jarak_radius'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cBranch'] = this.cBranch;
    data['cCompcode'] = this.cCompcode;
    data['cDesc'] = this.cDesc;
    data['cLat'] = this.cLat;
    data['cLong'] = this.cLong;
    data['cPassword'] = this.cPassword;
    data['jarak_radius'] = this.jarak_radius;
    return data;
  }
}