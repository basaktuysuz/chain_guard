import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultPage extends StatelessWidget {
  final String scannedData;

  ResultPage(this.scannedData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Scanned QR Code Data:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              scannedData,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _sendLinktoFirebase(scannedData);
              },
              child: Text('Receive Box'),
            ),
            ElevatedButton(
              onPressed: () {
                _launchURL(scannedData);
              },
              child: Text('Open Link'),
            ),
          ],
        ),
      ),
    );
  }


  void _sendLinktoFirebase(String url) async {
    String? userId = await getCurrentUserKey(); // Kullanıcı kimliğini al
    if (userId != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference usersCollection = firestore.collection("users");
      DocumentReference userRef = usersCollection.doc(userId);

      userRef.collection('boxes').add({
        'link': url,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((value) {
        print("Link stored successfully in user's boxes collection");
      }).catchError((error) {
        print("Error occurred during data storage: $error");
      });
    } else {
      print("No user logged in.");
    }
  }
/*
  Future<String?> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      // Oturum açmış kullanıcı yoksa null döndür
      return null;
    }
  }

 */

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<String?> getCurrentUserKey() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      }
    }
    return null;
  }
}
