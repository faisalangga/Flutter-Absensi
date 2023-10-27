import 'package:sas_hima/constant/const_image.dart';
import 'package:sas_hima/data/models/model_detail.dart';
import 'package:sas_hima/utils/utils.dart';
import 'package:flutter/material.dart';

class CardviewDetailAbsen extends StatelessWidget {
  final Data1 datalist;

  const CardviewDetailAbsen(this.datalist, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ClipOval(
                  child: Image.asset(
                    iconUser,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Utils.shortenString('${datalist.cnama}', 18),
                        style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    const SizedBox(
                      height: 5,
                    ),
                    Text('Nik : ${datalist.cnik}',
                        style: const TextStyle(
                          fontSize: 14,
                        )),
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    datalist.status != null
                        ? Container(
                            decoration: BoxDecoration(
                                color:  datalist.status =='Terlambat'?Colors.red.shade100  :Colors.green.shade100,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                              datalist.status =='Terlambat'
                              ?Text('${datalist.status}',
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10))
                              :Text('${datalist.status}',
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10)),
                            ))
                        : Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${datalist.dinputdate}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
