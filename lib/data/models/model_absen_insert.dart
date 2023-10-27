class insertAbsenModel {
  List<DataAbsen>? data;
  String? pesan;
  String? status;

  insertAbsenModel({this.data, this.pesan, this.status});

  insertAbsenModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataAbsen>[];
      json['data'].forEach((v) {
        data!.add(new DataAbsen.fromJson(v));
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

class DataAbsen {
  String? date;
  String? image;
  String? time;
  String? name;

  DataAbsen({this.date, this.image, this.time,this.name});

  DataAbsen.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    image = json['image'];
    time = json['time'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['image'] = this.image;
    data['time'] = this.time;
    data['name'] = this.name;
    return data;
  }
}