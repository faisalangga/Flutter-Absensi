class AuthModel {
  String? pesan;
  String? status;
  String? token;

  AuthModel({this.pesan, this.status, this.token});

  AuthModel.fromJson(Map<String, dynamic> json) {
    pesan = json['pesan'];
    status = json['status'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pesan'] = this.pesan;
    data['status'] = this.status;
    data['token'] = this.token;
    return data;
  }
}
