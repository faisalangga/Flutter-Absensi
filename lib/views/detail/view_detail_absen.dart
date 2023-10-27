import 'package:sas_hima/constant/const_preference.dart';
import 'package:sas_hima/data/models/model_detail.dart';
import 'package:sas_hima/utils/connectivity.dart';
import 'package:sas_hima/utils/utils_dialog.dart';
import 'package:sas_hima/viewmodels/detail_viewmodel.dart';
import 'package:sas_hima/views/view_home.dart';
import 'package:sas_hima/widgets/app_datanotfound.dart';
import 'package:sas_hima/widgets/app_header.dart';
import 'package:sas_hima/widgets/cardview_detailabsen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailAbsenView extends StatefulWidget {
  const DetailAbsenView({Key? key, required this.ctipe}) : super(key: key);
  final String ctipe;

  @override
  State<DetailAbsenView> createState() => _DetailAbsenViewState();
}

class _DetailAbsenViewState extends State<DetailAbsenView> {
  bool isLoading = true;
  String totalKaryawanString='0';
  int? totalOntime=0;
  int? totalTelat=0;
  int? totalAbsen=0;
  int? totalBelumAbsen=0;
  List<dynamic> dataList = [];
  DetailViewmodel detailViewmodel = DetailViewmodel();
  late String branchString = '';
  String currentDate = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
    getCurrentDate1();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getCurrentDate1() async {
    DateTime ntpTime = await NTP.now();
    setState(() {
      currentDate = DateFormat('dd MMMM yyyy').format(ntpTime).toUpperCase();
    });
  }


  void _fetchData()async{
    bool isConnected = await Connection().checkInternetConnectivity();
    if (context.mounted) {
      if (isConnected) {
        UtilsDialog.loading(context, 'Mohon tunggu..');
        getAPi();
      } else {
        UtilsDialog.flushBarErrorMessage(
            'Tidak ada Internet', 'Tolong periksa koneksi internet anda',
            context);
      }
    }
  }

  void getAPi() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    branchString = prefs.getString(ConstPreference.CBRANCH)!;
    Map<String, dynamic> data = {
      'cbranch': branchString,
      'ctipe': widget.ctipe,
    };
    try{
      if (context.mounted) {
        var result = await detailViewmodel.getLandingDetailPage(data, context);
        DetailModel response = DetailModel.fromJson(result);
        if (response.status == "1") {
          if (context.mounted) {
            Navigator.pop(context);
            setState(() {
              isLoading = false;
              dataList.clear();
              dataList.addAll(response.data1!);
              totalKaryawanString = response.data2![0].totalKaryawan!;
              totalOntime = response.data2![0].totalTepatWaktu!;
              totalTelat = response.data2![0].totalTelat!;
              totalAbsen = response.data2![0].totalTelat! +
                  response.data2![0].totalTepatWaktu!;
              totalBelumAbsen = int.parse(totalKaryawanString) - totalAbsen!;
            });
          }
        } else {
          if (context.mounted) {
            isLoading = true;
            Navigator.pop(context);
          }
        }
      }
    }catch(error){
      if (context.mounted) {
        Navigator.pop(context);
      }
    }

  }

  String tipe(){
    return widget.ctipe=="I" ? "Masuk" : "Pulang";
  }

  _onBackPressed() {
    Navigator.pop(context,"refresh");
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppHeader(title: 'Absen ${tipe()} Hari ini', onBackPressed: _onBackPressed),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    decoration: BoxDecoration(
                        border: const Border(
                          top: BorderSide(width: 1, color: Colors.grey),
                          bottom: BorderSide(width: 1, color: Colors.grey),
                          left: BorderSide(width: 1, color: Colors.grey),
                          right: BorderSide(width: 1, color: Colors.grey),
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                      child: Text(currentDate,style: const TextStyle(fontWeight: FontWeight.bold),),
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Karyawan', style: TextStyle(fontSize: 16)),
                    Text(totalKaryawanString,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          widget.ctipe=="I"?
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
                width: width,
                decoration: BoxDecoration(
                    border: const Border(
                      top: BorderSide(width: 1, color: Colors.grey),
                      bottom: BorderSide(width: 1, color: Colors.grey),
                      left: BorderSide(width: 1, color: Colors.grey),
                      right: BorderSide(width: 1, color: Colors.grey),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 90,
                        width: 90,
                        child: Stack(
                          children: [
                            PieChart(PieChartData(
                                startDegreeOffset: 250,
                                sectionsSpace: 0,
                                centerSpaceRadius: 35,
                                sections: [
                                  PieChartSectionData(
                                      value: totalOntime!.toDouble(),
                                      color: Colors.blue,
                                      radius: 15,
                                      showTitle: false),
                                  PieChartSectionData(
                                      value: totalTelat!.toDouble(),
                                      color: Colors.deepOrange,
                                      radius: 13,
                                      showTitle: false),
                                  PieChartSectionData(
                                      value: totalBelumAbsen!.toDouble(),
                                      color: Colors.grey,
                                      radius: 10,
                                      showTitle: false),
                                ])),
                            Positioned.fill(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('$totalAbsen',style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                                  Text('/$totalKaryawanString',style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Total ${widget.ctipe=="I" ? "Datang Tepat Waktu" : "Absen Masuk"}:'),
                                    Text('$totalOntime',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  color: Colors.deepOrange,
                                ),
                                const SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Total ${widget.ctipe=="I" ? "Datang Terlambat" : "Absen Pulang"}:'),
                                    Text('$totalTelat',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ):Container(),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('Riwayat Absensi ${tipe()} Karyawan (${dataList.length})',style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          dataList.isEmpty && isLoading == false
          ? AppDataNotFound('Belum ada yang ${widget.ctipe=="I" ? "absen" : "pulang"}')
          :Expanded(
            child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return CardviewDetailAbsen(dataList[index]);
                }),
          ),
        ],
      ),
    );
  }

}
