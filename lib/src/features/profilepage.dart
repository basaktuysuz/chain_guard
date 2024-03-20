import 'package:chain_guard/src/common_widgets/toast.dart';
import 'package:chain_guard/src/features/avatarpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "";
  String email = "";
  String phoneNo = "";
  String fullname = "";
  String idNumber = "";
  String role = "";
  String url = "https://www.pngarts.com/files/11/Avatar-Free-PNG-Image.png";

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController idNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //getting user info with _fetch method
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: NetworkImage(url),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 30,
                  width: 180,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.amber)),
                    onPressed: () {
                      _navigateAndDisplayAvatars(context);
                    },
                    child: const Text("Change Avatar"),
                  ),
                ),
              ),
              Text('$fullname ',
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 25)),
              Text('$role ',
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('ID Number',
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  _buildEditableField("", idNoController, idNumber, false),
                  const SizedBox(height: 16.0),

                  Text('Email',
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  _buildEditableField("", emailController, email, true),
                  const SizedBox(height: 16.0),

                  Text('Phone ',
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  _buildEditableField("", phoneNoController, phoneNo, true),
                  const SizedBox(height: 32.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      _saveProfileChanges();
                    },
                    icon: const Icon(Icons.published_with_changes),
                    label: const Text('Save Changes'),
                  ),
                  const SizedBox(height: 8.0),
                  //creating buttons
                  _buildButton(
                      context, 'Settings and Security', Icons.settings, () {}),
                  const SizedBox(height: 8.0),
                  _buildButton(
                      context, 'Contact and Support', Icons.headset_mic, () {}),
                  const SizedBox(height: 8.0),
                  _buildButton(
                    context,
                    'Sign Out',
                    Icons.exit_to_app,
                    () {
                      Navigator.of(context).pushNamed('/login');
                      showToast(message: 'Logging out');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      /*   bottomNavigationBar: BottomNavBar(
        selectedIndex: 2,
        onItemTapped: _onItemTapped,
      ),*/
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller,
      String initialValue, bool editable) {
    controller.text = initialValue;
    return TextField(
      controller: controller,
      enabled: editable,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  //getting user doc
  Future<void> _fetch() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      setState(() {
        // Check if 'URL' field exists and is not empty
        url =  userSnapshot.get('URL');
        role = userSnapshot.get('role');
        idNumber = userSnapshot.get('id Number');
        username = userSnapshot.get('fullname');
        email = userSnapshot.get('email');
        fullname = userSnapshot.get('fullname');
        phoneNo = userSnapshot.get('phoneNo');

        usernameController.text = username;
        emailController.text = email;
        fullnameController.text = fullname;
        phoneNoController.text = phoneNo;
      });
    }
  }

  _performSaveAction() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .update({
        'username': usernameController.text,
        'email': emailController.text,
        'fullname': fullnameController.text,
        'phoneNo': phoneNoController.text,
      });

      setState(() {
        username = usernameController.text;
        email = emailController.text;
        fullname = fullnameController.text;
        phoneNo = phoneNoController.text;
      });
    }
  }

  Future<void> _saveProfileChanges() async {
    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Changes'),
          content: const Text('Are you sure you want to save the changes?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                // perdom save if user clicks confirm
                await _performSaveAction();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildButton(BuildContext context, String label, IconData icon,
      VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }

  Future<void> _navigateAndDisplayAvatars(BuildContext context) async {
    final imageUrl = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AvatarPage()),
    );
    updateImage(imageUrl);
  }

  void updateImage(String imageUrl) {
    setState(() {
      url = imageUrl;
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    fullnameController.dispose();
    phoneNoController.dispose();
    super.dispose();
  }
}
