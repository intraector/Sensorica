import 'dart:typed_data';

import 'package:flutter/material.dart';

Widget showSendMsgUI(BuildContext context, Map photos) {
  var _messageCtrler = TextEditingController();
  return Row(
    children: <Widget>[
      Expanded(
        child: Container(
          alignment: Alignment.center,
          color: Colors.black54,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          height: 50.0,
          child: TextField(
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
            controller: _messageCtrler,
            maxLines: 6,
            minLines: 1,
            decoration: InputDecoration.collapsed(
              focusColor: Colors.green,
              hoverColor: Colors.red,
              fillColor: Colors.white,
              hintText: "Сообщение",
              hintStyle: TextStyle(color: Colors.grey[300]),
            ),
          ),
        ),
      ),
      Container(
        color: Colors.black54,
        height: 50.0,
        child: IconButton(
          icon: Icon(
            Icons.send,
            color: Colors.grey[300],
          ),
          onPressed: () {
            Map<String, Uint8List> uint8s = {};
            Map result = {'file': photos['file']};
            if (photos['file'] == null) {
              for (int index = 0; index < photos['uint8s'].length; index++)
                uint8s[index.toString()] = photos['uint8s'][index];
              result['uint8s'] = uint8s;
            }
            result['body'] = _messageCtrler.text.trim();
            Navigator.pop<Map>(context, result);
          },
        ),
      ),
    ],
  );
}
