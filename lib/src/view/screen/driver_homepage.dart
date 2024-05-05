import 'dart:math';

import 'package:chain_guard/src/common_widgets/toast.dart';
import 'package:chain_guard/src/view/screen/homepage.dart';
import 'package:chain_guard/src/view/screen/login_screen.dart';
import 'package:chain_guard/src/view/screen/package_detail.dart';
import 'package:chain_guard/src/view/screen/report_issue.dart';
import 'package:chain_guard/src/view/screen/resultpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


class DriverHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  String data = "";


  Future<void> scanQrCode() async {


    FlutterBarcodeScanner.scanBarcode("#000000", "Cancel", true, ScanMode.QR)
        .then((value) {
      if (value != '-1') {
        // QR code scanned successfully, handle the content here
        setState(() {
          data = value;
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4, // Set the height to 50% of screen height
                  child: ResultPage(data),
                ),
              );
            },
          );
        });
        print("QR Code Content: $value");




        // You can do further processing with the QR code content here
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Package Delivery '),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 10),
            InkWell(
              onTap: () {
              },
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Distributor : ",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Ahmet Ö.',
                      style: TextStyle(fontSize: 25,color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            buildCardButton('Scan Code',"Scan to receive packages",'assets/images/scan_code.png', () {
scanQrCode();
            }),SizedBox(height: 20),
            buildCardButton('Packages',"List Package Details",'assets/images/packages.png', () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PackageDetailsPage()),
              );
            }),SizedBox(height: 20),
            buildCardButton('Report an Issue',"Having A problem? Connect Support Center",'assets/images/report_issue.png', () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportIssuePage()),
              );
            }),

            SizedBox(height: 120),
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

  Widget buildCardButton(String label, String label2, String imagePath, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.black12,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      label,
                      style: TextStyle(fontSize: 22 ,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    Image.asset(
                      imagePath,
                      height:30, // Set the height of the image
                      width: 30, // Set the width of the image
                      fit: BoxFit.cover, // Adjust the fit of the image
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  label2,
                  style: TextStyle(fontSize: 16),
                ),// Adjust the spacing between the text and the image

              ],
            ),
          ),
        ),
      ),
    );
  }

}
