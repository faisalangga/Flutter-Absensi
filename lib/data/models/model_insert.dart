class InsertModel {
  String? status;
  String? pesan;

  InsertModel({this.status, this.pesan});

  InsertModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    pesan = json['pesan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['pesan'] = this.pesan;
    return data;
  }
}