
import 'package:flutter/material.dart';
class AppHeader extends StatelessWidget {
  const AppHeader({Key? key, required this.title, this.onBackPressed}) : super(key: key);

  final String title;
  final void Function()? onBackPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SizedBox(
            height: 35,
          ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: onBackPressed,
                  child: Container(
                    height: 40,
                    width: 40,
                    child: Center(
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        )),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      child: Text(
                        title,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 50,),
              ],
            )
        ],
      ),
    );
  }
}
