class VersionModel {
  List<Data>? data;
  String? pesan;
  String? status;

  VersionModel({this.data, this.pesan, this.status});

  VersionModel.fromJson(Map<String, dynamic> json) {
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
  String? cbranch;
  String? cversion;

  Data({this.cbranch, this.cversion});

  Data.fromJson(Map<String, dynamic> json) {
    cbranch = json['cbranch'];
    cversion = json['cversion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cbranch'] = this.cbranch;
    data['cversion'] = this.cversion;
    return data;
  }
}