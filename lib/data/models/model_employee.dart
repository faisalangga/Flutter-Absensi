class EmployeeModel {
  List<DataEmployee>? data;
  String? pesan;
  String? status;

  EmployeeModel({this.data, this.pesan, this.status});

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataEmployee>[];
      json['data'].forEach((v) {
        data!.add(new DataEmployee.fromJson(v));
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

class DataEmployee {
  String? cbranch;
  String? cnik;
  String? cnama;
  String? cfacepoint;
  String? cfacepoint2;
  String? cfacepoint3;

  DataEmployee({this.cbranch,this.cnik,this.cnama,this.cfacepoint,this.cfacepoint2,this.cfacepoint3});

  DataEmployee.fromJson(Map<String, dynamic> json) {
    cbranch = json['cbranch'];
    cnik = json['cnik'];
    cnama = json['cnama'];
    cfacepoint = json['cfacepoint'];
    cfacepoint2 = json['cfacepoint2'];
    cfacepoint3 = json['cfacepoint3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cbranch'] = this.cbranch;
    data['cnik'] = this.cnik;
    data['cnama'] = this.cnama;
    data['cfacepoint'] = this.cfacepoint;
    data['cfacepoint2'] = this.cfacepoint2;
    data['cfacepoint3'] = this.cfacepoint3;
    return data;
  }

  toMap() {
    return {
      'cbranch': cbranch,
      'cnik': cnik,
      'cnama': cnama,
      'cFacePoint': cfacepoint,
      'cFacePoint2': cfacepoint2,
      'cFacePoint3': cfacepoint3,
    };
  }
}