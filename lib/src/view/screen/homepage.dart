import 'dart:convert';

import 'package:chain_guard/src/common_widgets/toast.dart';
import 'package:chain_guard/src/view/screen/login_screen.dart';
import 'package:chain_guard/src/view/screen/profilepage.dart';
import 'package:chain_guard/src/view/screen/resultpage.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String fullName = 'Başak';
  String result = "";
  String data = "";


  List<dynamic> users = [];
  dynamic firstUser;

  Future<void> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse("https://chainguard-api.onrender.com/getusers"));
      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body);
          print(users);
          // İlk kullanıcıyı almak için veri dizisinin ilk öğesini seçin

        });
      } else {
        print("Failed to load users: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  Future<void> _fetchUserInfo() async {
    fetchUsers();

  /*  final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: currentUser.email)
            .get();


        var db = await M.Db.create(MONGO_CONNECTION_URL);
        await db.open();
        final collection = db.collection('users');
        final query = M.where.eq('email', currentUser.email);
        final result = await collection.find(query).toList();
        if (result.isNotEmpty) {
          final user = result.first;
          final fullname = user['fullname'];
          debugPrint('Fullname: '+fullname);
        } else {
          print('User not found.');
        }

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot userSnapshot = querySnapshot.docs.first;
          setState(() {
            fullName = userSnapshot['fullname'] as String;
          });
        } else {
          print('Kullanıcı verisi bulunamadı');
        }
      } catch (error) {
        print('Veri çekerken hata oluştu: $error');
      }
    }*/
  }



Future<void> scanQrCode( BuildContext context) async {

   FlutterBarcodeScanner.scanBarcode("#000000", "Cancel", true, ScanMode.QR)
       .then((value) {
     if (value != '-1') {
       // QR code scanned successfully
       if (value.startsWith('https://chainguard.com')) {
         setState(() {
           data = value;
           showModalBottomSheet(
             context: context,
             isScrollControlled: true,
             builder: (BuildContext context) {
               return Padding(
                 padding: EdgeInsets.only(
                     bottom: MediaQuery.of(context).viewInsets.bottom),
                 child: FractionallySizedBox(
                   heightFactor: 0.5, // Set the height to 50% of screen height
                   child: ResultPage(data), // Pass parsedValues to ResultPage
                 ),
               );
             },
           );
         });
         print("QR Code Content: $value");
       } else {
         print("QR code does not start with 'https://www.chainguard.com'");
       }
     } else {
       // User canceled the scan
       print("Scan canceled");
     }
   }).catchError((error) {
     // Handle error if any
     print("Error while scanning QR code: $error");
   });

 }

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ChainGuard"),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome !',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
            ),
            const SizedBox(
              height: 15,
            ),
            Card(
              elevation: 50,
              shadowColor: Colors.black,
              color: Colors.blue[100],
              child: SizedBox(
                height: 210,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Icon(
                            Icons.qr_code_scanner_outlined,
                            color: Colors.green[900],
                            size: 40,
                          ), // Icon for the first Text widget
                          Text(
                            'Scan',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.green[900],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ), //SizedBox

                      const Text(
                        'This feature will allow you to receive packages and many more. ',
                        style: TextStyle(
                          fontSize: 15,

                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,//Textstyle
                      ), //Text
                      const SizedBox(
                        height: 10,
                      ), //SizedBox
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () async {

                           scanQrCode(this.context);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.green),
                            foregroundColor: MaterialStateProperty.all(Colors.white),),
                            child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.touch_app),
                                Text('Click Scan')
                              ],
                            ),
                          ),
                        ),
                      ) //SizedBox
                    ],
                  ), //Column
                ), //Padding
              ), //SizedBox
            ),
            const SizedBox(
              height: 100,
            ),
            InkWell(
              onTap: () async {
                scanQrCode(this.context);
                /*      var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    ));
                setState(() {
                  if (res is String) {
                    result = res;
                  }
                });

           */
              },
              child: Center(
                child: Container(
                  width: 140,
                  // Adjust the width and height to make it circular
                  height: 140,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.redAccent,
                        width: 10.0,
                      ),
                      color: Colors.red,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100))),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.qr_code_2,
                            color: Colors.white,
                            size: 60,
                          ), // Icon
                          Text(
                            "Scan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Get Package Info ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Press Scan to See the Details of Package ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                ],

              ),

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    showToast(message: "Logging Out");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('Log Out'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
