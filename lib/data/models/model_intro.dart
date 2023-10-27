class IntroModel {
  String? pesan;
  String? status;

  IntroModel({this.pesan, this.status});

  IntroModel.fromJson(Map<String, dynamic> json) {
    pesan = json['pesan'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pesan'] = pesan;
    data['status'] = status;
    return data;
  }
}