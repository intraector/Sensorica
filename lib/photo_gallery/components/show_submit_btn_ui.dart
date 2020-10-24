import 'package:flutter/material.dart';

Widget showSubmitBtnUi(BuildContext context, Map photos) => Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        InkWell(
          splashColor: Colors.green, // splash color
          onTap: () {
            Navigator.pop<Map>(context, photos);
          },
          child: SizedBox.fromSize(
            size: Size(40, 40), // button width and height
            child: ClipOval(
              child: Container(
                  color: Colors.black54, // button color
                  child: Icon(Icons.check, color: Colors.white, size: 24.0)),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(right: 15)),
        // Padding(
        //   padding: const EdgeInsets.only(right: 18.0),
        //   child: Container(
        //     // alignment: Alignment.center,
        //     height: 40.0,
        //     width: 40.0,
        //     child: FlatButton(
        //       color: Colors.black54,
        //       child: Container(
        //           alignment: Alignment.center,
        //           padding: const EdgeInsets.only(right: 18.0),
        //           child: Icon(Icons.check, color: Colors.white, size: 24.0)),
        //       shape: RoundedRectangleBorder(
        //           side: BorderSide(color: Colors.white, width: 2, style: BorderStyle.solid),
        //           borderRadius: BorderRadius.circular(30)),
        //       onPressed: () {
        //         Navigator.pop<Map>(context, photos);
        //       },
        //     ),
        //   ),
        // ),
      ],
    );
