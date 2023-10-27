class LandingModel {
  List<DataLanding>? data;
  String? pesan;
  String? status;

  LandingModel({this.data, this.pesan, this.status});

  LandingModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataLanding>[];
      json['data'].forEach((v) {
        data!.add(new DataLanding.fromJson(v));
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

class DataLanding {
  int? csasradius;
  String? jmlPegawai;
  int? needapprove;
  int? totalHadir;
  int? totalKeluar;

  DataLanding({this.csasradius,this.jmlPegawai, this.needapprove, this.totalHadir, this.totalKeluar});

  DataLanding.fromJson(Map<String, dynamic> json) {
    csasradius = json['csasradius'];
    jmlPegawai = json['jml_pegawai'];
    needapprove = json['needapprove'];
    totalHadir = json['total_hadir'];
    totalKeluar = json['total_keluar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['csasradius'] = this.csasradius;
    data['jml_pegawai'] = this.jmlPegawai;
    data['needapprove'] = this.needapprove;
    data['total_hadir'] = this.totalHadir;
    data['total_keluar'] = this.totalKeluar;
    return data;
  }
}