import 'dart:convert';

import 'package:sas_hima/constant/const_image.dart';
import 'package:sas_hima/constant/const_preference.dart';
import 'package:sas_hima/data/models/model_insert.dart';
import 'package:sas_hima/utils/connectivity.dart';
import 'package:sas_hima/utils/utils_dialog.dart';
import 'package:sas_hima/viewmodels/faceViewmodel.dart';
import 'package:sas_hima/views/register_face/view_succes_register.dart';
import 'package:sas_hima/widgets/app_button.dart';
import 'package:sas_hima/widgets/app_textfield.dart';
import 'package:sas_hima/widgets/camera_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_async_autocomplete/flutter_async_autocomplete.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/modul_nik.dart';

class RegisterNikView extends StatefulWidget {
  const RegisterNikView(
      {Key? key,
      required this.facepoint1,
      required this.base64String1,
      required this.mimetype1,
      required this.facepoint2,
      required this.base64String2,
      required this.mimetype2,
      required this.facepoint3,
      required this.base64String3,
      required this.mimetype3})
      : super(key: key);

  final String facepoint1;
  final String base64String1;
  final String mimetype1;
  final String facepoint2;
  final String base64String2;
  final String mimetype2;
  final String facepoint3;
  final String base64String3;
  final String mimetype3;

  @override
  State<RegisterNikView> createState() => _RegisterNikViewState();
}

class _RegisterNikViewState extends State<RegisterNikView> {
  Uint8List? bytes1, bytes2, bytes3;
  var autoController = TextEditingController();
  final _namaTextEditingController = TextEditingController();
  bool isvisible = false;
  bool isSelected = false;
  String? branchString;
  Data? selectedData;
  FaceViewmodel faceViewmodel = FaceViewmodel();

  @override
  void initState() {
    super.initState();
    _start();
  }

  _start() async {
    bytes1 = base64Decode(widget.base64String1);
    bytes2 = base64Decode(widget.base64String2);
    bytes3 = base64Decode(widget.base64String3);
    _getSharedPreference();
  }

  _getSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    branchString = prefs.getString(ConstPreference.CBRANCH)!;
  }

  _onBackPressed() {
    Navigator.of(context).pop();
  }

  Future<List<Data>> getNik(String search) async {
    String substring = branchString!.substring(1, 4);
    Map<String, dynamic> data = {
      "cbranch": substring,
    };
    var result = await faceViewmodel.getNik(data, context);
    NikModel response = NikModel.fromJson(result);

    List<Data> nikList = [];
    for (int i = 0; i <= (response.data!.length - 1); i++) {
      Data data = Data(
        branch: response.data![i].branch,
        nik: response.data![i].nik,
        nama: response.data![i].nama!.trim(),
      );
      nikList.add(data);
    }
    return nikList
        .where((element) =>
            element.nik!.toLowerCase().startsWith(search.toLowerCase()))
        .toList();
  }

  _signUp(context) async {
    String nama = _namaTextEditingController.text;
    String nik = autoController.text;
    if (nama.isEmpty) {
      Navigator.pop(context);
      UtilsDialog.flushBarErrorMessage(
          'Maaf!', 'Nama Karyawan tidak boleh kosong', context);
      return;
    }
    Map<String, dynamic> data = {
      'cbranch': branchString,
      'cnik': nik,
      'cnama': nama,
      'cakses': '',
      'cfacepoint': widget.facepoint1,
      'cfacepoint2': widget.facepoint2,
      'cfacepoint3': widget.facepoint3,
      'cimage1': widget.base64String1,
      'mimetype1': widget.mimetype1,
      'cimage2': widget.base64String2,
      'mimetype2': widget.mimetype2,
      'cimage3': widget.base64String3,
      'mimetype3': widget.mimetype3,
    };
    try {
      var result = await faceViewmodel.insertFace(data, context);
      InsertModel response = InsertModel.fromJson(result);
      if (response.status == '1') {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: SuccesRegister(
                    base64String: widget.base64String1,
                    namaString: nama,
                    nikString: nik),
                reverseDuration: const Duration(milliseconds: 1000),
                duration: const Duration(milliseconds: 1000),
                type: PageTransitionType.bottomToTop));
      } else {
        Navigator.pop(context);
        UtilsDialog.flushBarErrorMessage("Terjadi kesalahan", "${response.pesan}", context);
      }
    } catch (error) {
      Navigator.pop(context);
      UtilsDialog.flushBarErrorMessage("Terjadi kesalahan", 'Gagal Daftarkan wajah : $error', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    late Widget bottomsheet;
    bottomsheet = SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: height,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Lottie.asset(
                  lottieEmployee,
                  fit: BoxFit.cover,
                  width: width,
                  height: 200,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 90),
                        const Divider(height: 2),
                        const SizedBox(height: 20),
                        const Text('Nik Karyawan'),
                        const SizedBox(height: 5),
                        AsyncAutocomplete<Data>(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: 'Pilih Nik',
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.grey[200],
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                            controller: autoController,
                            onTapItem: (Data data) {
                              setState(() {
                                isSelected = false;
                                selectedData = data;
                                autoController.text = data.nik!;
                                _namaTextEditingController.text =
                                    data.nama!.toUpperCase();
                                if (data.nik != '') {
                                  isvisible = true;
                                }
                              });
                            },
                            onSubmitted: (value) {
                              setState(() {
                                isSelected = true;
                                autoController.text = '';
                                _namaTextEditingController.text = '';
                              });
                            },
                            asyncSuggestions: (searchValue) =>
                                getNik(searchValue),
                            suggestionBuilder: (data) => ListTile(
                                  title: Text('${data.nik}'),
                                  subtitle: Text('${data.nama}'),
                                )),
                        const SizedBox(height: 10),
                        isSelected == true
                            ? Row(
                                children: [
                                  Icon(Icons.warning,
                                      size: 16, color: Colors.red),
                                  // Ganti dengan ikon yang diinginkan
                                  SizedBox(width: 5),
                                  // Tambahkan jarak antara ikon dan teks
                                  Text(
                                      'Pilih list nik karyawan (Jangan tekan enter pada keyboard)',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.deepOrange)),
                                ],
                              )
                            : Container(),
                        const SizedBox(height: 20),
                        const Text('Nama Karyawan'),
                        const SizedBox(height: 5),
                        AppTextField(
                          controller: _namaTextEditingController,
                          isReadOnly: true,
                          labelText: "Nama Karyawan",
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        AppButton(
                          text: 'Daftarkan wajah',
                          onPressed: () async {
                            bool isConnected =
                                await Connection().checkInternetConnectivity();
                            if (mounted) {
                              if (isConnected) {
                                UtilsDialog.loading(context, 'Mohon tunggu..');
                                await _signUp(context);
                              } else {
                                UtilsDialog.flushBarErrorMessage(
                                    'Tidak ada Internet',
                                    'Tolong periksa koneksi internet anda',
                                    context);
                              }
                            }
                          },
                          icon: const Icon(
                            Icons.person_add,
                            color: Colors.white,
                          ),
                        )
                      ],
                    )),
              ],
            ),
          )
        ],
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          bottomsheet,
          CameraHeader(
            "Pilih Nik",
            onBackPressed: _onBackPressed,
            vermuk: false,
            foto1: bytes1!,
            foto2: bytes2!,
            foto3: bytes3!,
          ),
        ],
      ),
    );
  }
}
