import 'package:contakt/model/contact.dart';
import 'package:contakt/screens/add_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:url_launcher/url_launcher.dart';

late Box box;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<Contact>(
      ContactAdapter()); // Register the ContactAdapter
  box = await Hive.openBox('contact');
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

void launchPhoneNumber(String phoneNumber) async {
  String url = 'number:$phoneNumber';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Telefon raqamni ochirib bo\'lmadi: $url';
  }
}

class _MyAppState extends State<MyApp> {
  void _callPhoneNumber(String phoneNumber) {
    launchPhoneNumber(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact'),
      ),
      body: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (value, box, child) {
            return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  return Container(
                      width: MediaQuery.sizeOf(context).width,
                      margin: EdgeInsets.all(10),
                      color: Colors.cyanAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(box.getAt(index).ism,
                                    style: TextStyle(fontSize: 22)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(box.getAt(index).number),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Ochrish',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.red)),
                                            content:
                                                Text('Rostan ham ochraszmi'),
                                            actions: <Widget>[
                                              MaterialButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("yoq",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                color: Colors.indigo,
                                              ),
                                              MaterialButton(
                                                onPressed: () {
                                                  box.deleteAt(index);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "Contacingiz o'chirildi")));
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Ha",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                color: Colors.red,
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(Icons.edit),
                                SizedBox(
                                  width: 15,
                                ),
                                IconButton(
                                    onPressed: () {
                                      _callPhoneNumber(box.getAt(index).number);
                                    },
                                    icon: Icon(Icons.phone))
                              ],
                            ),
                          )
                        ],
                      ));
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => Add_Screen(box)));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
