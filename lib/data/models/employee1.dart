import 'dart:convert';

class Employee {
  String cBranch;
  String cNik;
  String cNama;
  List cFacepoint;
  List cFacepoint2;
  List cFacepoint3;

  Employee({
    required this.cBranch,
    required this.cNik,
    required this.cNama,
    required this.cFacepoint,
    required this.cFacepoint2,
    required this.cFacepoint3,
  });

  static Employee fromMap(Map<String, dynamic> employee) {
    return new Employee(
      cBranch: employee['cBranch'],
      cNik: employee['cNik'],
      cNama: employee['cNama'],
      cFacepoint: jsonDecode(employee['cFacepoint']),
      cFacepoint2: jsonDecode(employee['cFacepoint2']),
      cFacepoint3: jsonDecode(employee['cFacepoint3']),
    );
  }

  toMap() {
    return {
      'cbranch': cBranch,
      'cNik': cNik,
      'cNama': cNama,
      'cFacePoint': jsonEncode(cFacepoint),
      'cFacePoint2': jsonEncode(cFacepoint2),
      'cFacePoint3': jsonEncode(cFacepoint3),
    };
  }
}