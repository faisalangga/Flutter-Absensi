
import 'package:flutter/material.dart';

class AppCardDashboard extends StatelessWidget {
  const AppCardDashboard({Key? key, required this.icon,  required this.labelText, required this.value, required this.color, }) : super(key: key);
  final String icon;
  final String labelText;
  final String value;
  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                  width: 1, color: Colors.grey),
              bottom: BorderSide(
                  width: 1, color: Colors.grey),
              left: BorderSide(
                  width: 1, color: Colors.grey),
              right: BorderSide(
                  width: 1, color: Colors.grey),
            ),
            borderRadius:
            BorderRadius.circular(12)),

        padding:
        EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                Image.asset(
                  icon,
                  width: 60,
                  height: 60,
                ),
                SizedBox(height: 10,),
                Text(labelText,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12)),
                Text(
                    value,
                    style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        color: Colors.black,
                        fontSize: 30)),
                Text(
                    'orang',
                    style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
      );
  }
}
