import 'dart:typed_data';

import 'dart:math' as math;
import 'package:flutter/material.dart';

class CameraHeader extends StatelessWidget {
  CameraHeader(this.title, {this.onBackPressed, this.foto1, this.foto2, this.foto3, required this.vermuk});

  final String title;
  final Uint8List? foto1;
  final Uint8List? foto2;
  final Uint8List? foto3;
  final bool? vermuk;
  final void Function()? onBackPressed;

  @override
  Widget build(BuildContext context) {

    const double mirror = math.pi;
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          !vermuk! ?
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: onBackPressed,
                  child: Container(
                    // decoration: BoxDecoration(
                    //   color: Colors.black26,
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    height: 50,
                    width: 50,
                    child: Center(
                        child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  width: 140,
                  child: Row(children: [

                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: foto1 != null
                          ? Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(mirror),
                          child: ClipOval(
                            child: Image.memory(
                              foto1!,
                              width: 35,
                              height: 35,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                          : Icon(
                        Icons.account_circle,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                    SizedBox(width: 5,),

                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: foto2 != null ?
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(mirror),
                          child: ClipOval(
                            child: Image.memory(
                              foto2!,
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                          : Icon(
                        Icons.account_circle,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),

                    SizedBox(width: 5,),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: foto3 != null ?
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(mirror),
                          child: ClipOval(
                            child: Image.memory(
                              foto3!,
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                      :Icon(
                        Icons.account_circle,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  ]),
                )
              ],
            ),
          ):

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: onBackPressed,
                  child: Container(
                    // decoration: BoxDecoration(
                    //   color: Colors.black26,
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    height: 50,
                    width: 50,
                    child: Center(
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      child: Text(
                        title,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 50,),
              ],
            ),
          )
        ],
      ),
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.black, Colors.transparent],
        ),
      ),
    );
  }
}
