import 'package:contakt/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Add_Screen extends StatefulWidget {
  final Box box;

  Add_Screen(this.box);

  @override
  State<Add_Screen> createState() => _Add_ScreenState();
}

class _Add_ScreenState extends State<Add_Screen> {
  var maskFormatter = MaskTextInputFormatter(mask: '+###(##)###-##-##');
  TextEditingController txtIsm = TextEditingController();
  TextEditingController txtNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Add')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: txtIsm,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), label: Text('ism')),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: txtNumber,
              inputFormatters: [maskFormatter],
              decoration: InputDecoration(
                  border: OutlineInputBorder(), label: Text('tel')),
            ),
          ),
          MaterialButton(
            onPressed: () {
              Contact contact =
                  Contact(txtIsm.value.text, txtNumber.value.text);
              widget.box.add(contact);
              Navigator.pop(context);
            },
            child: Text('Save', style: TextStyle(color: Colors.white)),
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}
