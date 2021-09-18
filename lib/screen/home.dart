import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'menu.dart';

class HomeScreen extends StatefulWidget {
  final String branchName;
  const HomeScreen({Key? key, required this.branchName}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xffFFFFFF),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  height: size.width * 0.5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MenuScreen(
                                  branchName: widget.branchName,
                                )));
                  },
                  child: Container(
                    width: size.width * 0.33,
                    height: size.width * 0.33,
                    decoration: BoxDecoration(
                      color: Color(0xffECECEC),
                      border: Border.all(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(200),
                      ),
                    ),
                    child: Center(
                        child: Text(
                      "Menu",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.1,
                )
              ],
            ),
          ),
        ));
  }
}
