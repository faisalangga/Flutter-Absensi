class NikModel {
  List<Data>? data;
  String? pesan;
  String? status;

  NikModel({this.data, this.pesan, this.status});

  NikModel.fromJson(Map<String, dynamic> json) {
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
  String? branch;
  String? jabatan;
  String? nama;
  String? nik;

  Data({this.branch, this.jabatan, this.nama, this.nik});

  Data.fromJson(Map<String, dynamic> json) {
    branch = json['branch'];
    jabatan = json['jabatan'];
    nama = json['nama'];
    nik = json['nik'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branch'] = this.branch;
    data['jabatan'] = this.jabatan;
    data['nama'] = this.nama;
    data['nik'] = this.nik;
    return data;
  }
}