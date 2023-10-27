import 'package:flutter/material.dart';

class CameraDetail extends StatelessWidget {
  const CameraDetail(this.latlong, this.address, {Key? key}) : super(key: key);

  final String? latlong;
  final String? address;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          address == ''
              ? Column(
                children: [
                  Text(
                    'Mohon Tunggu....',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Proses Ambil Lokasi',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
              : Column(
                children: [
                  Text(
                    latlong!,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    address!,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
