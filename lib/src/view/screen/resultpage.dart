import 'package:chain_guard/src/common_widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultPage extends StatelessWidget {
  final String scannedData;

  ResultPage(this.scannedData);

  @override
  Widget build(BuildContext context) {
    //Parsing URl here
    Map<String, String> parsedValues = parseUrl(scannedData);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Scanned QR Code Data:',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    width: double.infinity,
                    // Set Card width to match parent width
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Box ID: ${parsedValues['Box ID']}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),
                        Divider(),
                        Text(
                          'Size: ${parsedValues['Size']}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Content: ${parsedValues['Content']}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Type: ${parsedValues['Type']}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Weight: ${parsedValues['Weight']}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _sendLinktoFirebase(scannedData);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Receive Box',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
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

      // Parse the URL to extract Box, Content, and Weight values
      Map<String, String> parsedValues = parseUrl(url);

      userRef.collection('boxes').add({
        'link': url,
        'timestamp': FieldValue.serverTimestamp(),
        'Box': parsedValues['Box'],
        'Content': parsedValues['Content'],
        'Weight': parsedValues['Weight'],
      }).then((value) {
        print("Link stored successfully in user's boxes collection");
        showToast(
            message: "Link stored successfully in user's boxes collection");
      }).catchError((error) {
        print("Error occurred during data storage: $error");
      });
    } else {
      print("No user logged in.");
    }
  }

  Map<String, String> parseUrl(String url) {
    RegExp regExp = RegExp(
        r"/box/id/([\w-]+)/status/(\w+)/packageSizes/([\w\d]+x[\w\d]+x[\w\d]+)/comment/(\w+)/content/(\w+)/weight/(\d+)");
    ;
    Match? match = regExp.firstMatch(url);

    if (match != null) {
      return {
        'Box ID': match.group(1)!,
        'Status': match.group(2)!,
        'Size': match.group(3)!,
        'Type': match.group(4)!,
        'Content': match.group(5)!,
        'Weight': match.group(6)!
      };
    } else {
      return {};
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
