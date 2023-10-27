class DetailModel {
  List<Data1>? data1;
  List<Data2>? data2;
  String? pesan;
  String? status;

  DetailModel({this.data1, this.data2, this.pesan, this.status});

  DetailModel.fromJson(Map<String, dynamic> json) {
    if (json['data1'] != null) {
      data1 = <Data1>[];
      json['data1'].forEach((v) {
        data1!.add(new Data1.fromJson(v));
      });
    }
    if (json['data2'] != null) {
      data2 = <Data2>[];
      json['data2'].forEach((v) {
        data2!.add(new Data2.fromJson(v));
      });
    }
    pesan = json['pesan'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data1 != null) {
      data['data1'] = this.data1!.map((v) => v.toJson()).toList();
    }
    if (this.data2 != null) {
      data['data2'] = this.data2!.map((v) => v.toJson()).toList();
    }
    data['pesan'] = this.pesan;
    data['status'] = this.status;
    return data;
  }
}

class Data1 {
  String? cbranch;
  String? cimage1;
  String? cnama;
  String? cnik;
  String? dinputdate;
  String? status;

  Data1(
      {this.cbranch,
        this.cimage1,
        this.cnama,
        this.cnik,
        this.dinputdate,
        this.status});

  Data1.fromJson(Map<String, dynamic> json) {
    cbranch = json['cbranch'];
    cimage1 = json['cimage1'];
    cnama = json['cnama'];
    cnik = json['cnik'];
    dinputdate = json['dinputdate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cbranch'] = this.cbranch;
    data['cimage1'] = this.cimage1;
    data['cnama'] = this.cnama;
    data['cnik'] = this.cnik;
    data['dinputdate'] = this.dinputdate;
    data['status'] = this.status;
    return data;
  }
}

class Data2 {
  String? totalKaryawan;
  int? totalTelat;
  int? totalTepatWaktu;

  Data2({this.totalKaryawan, this.totalTelat, this.totalTepatWaktu});

  Data2.fromJson(Map<String, dynamic> json) {
    totalKaryawan = json['total_karyawan'];
    totalTelat = json['total_telat'];
    totalTepatWaktu = json['total_tepat_waktu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_karyawan'] = this.totalKaryawan;
    data['total_telat'] = this.totalTelat;
    data['total_tepat_waktu'] = this.totalTepatWaktu;
    return data;
  }
}
