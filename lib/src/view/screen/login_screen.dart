import 'dart:convert';

import 'package:chain_guard/src/Firebase/auth.dart';
import 'package:chain_guard/src/db_helper/constant.dart';
import 'package:chain_guard/src/db_helper/mongo_crud.dart';
import 'package:chain_guard/src/view/screen/avatarpage.dart';
import 'package:chain_guard/src/view/screen/driver_homepage.dart';
import 'package:chain_guard/src/view/screen/homepage.dart';
import 'package:chain_guard/src/view/screen/signup_screen.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:realm/realm.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormState>();
  final Auth _auth = Auth();
  String _selectedValue = 'User';
  bool _isSigning = false;
  MongoDbCrud mongoDbCrud = MongoDbCrud();

  //List<dynamic>? userList;

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    //User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });
    fetchData();
    _loginUser(email, password);
    /*if (user != null) {
      showToast(message: "User is successfully signed in");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      showToast(message: "some error occured");
    }

     */
  }


  Future<void> fetchData() async {
    final String ip = await getIp();
    print("asdasdasdasdsa");
    final response = await http.get(Uri.parse('http://$ip:3000/v1'));

    if (response.statusCode == 200) {
      // Başarılı yanıt
      final data = jsonDecode(response.body);
      debugPrint(data['message']); // "Hello from Node.js!" yazdırmalı
    } else {
      // Hata işleme
     print('İstek başarısız oldu, durum: ${response.statusCode}.');
    }
  }


  Future<String> getIp() async {
    final ipv4 = await Ipify.ipv4();
    print(ipv4);
    return ipv4;
  }

  /*  Future<bool> loginUser(String email, String password) async {
    var db = await M.Db.create(MONGO_CONNECTION_URL); // Assuming you have connection logic
    await db.open();
    final app = App(AppConfiguration('application-0-hzldcca'));
    final user = await app.logIn(Credentials.anonymous());
    var userCollection = db.collection('users');
    var user = await userCollection.findOne({'email': email}); // Find user by email

    if (user == null) {
      showToast(message: "hata");
      return false;

      // User not found
    }else  Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );

    var hashedPassword = password; // Hash entered password
    return hashedPassword == user['password']; // Compare hashed passwords
  }

   */

  Future<void> _loginUser(email, password) async {
    final app = App(AppConfiguration('application-0-hzldcca'));

    var db = await M.Db.create(MONGO_CONNECTION_URL);
    await db.open();

    final user = await app.logIn(Credentials.emailPassword(email, password));

    //  var user = await userCollection.findOne({'email': email});  // Find user by email

    /* var userCollection = db.collection('users');
    // Check if there's a user with the provided email
    bool emailExists = userList.any((user) => user.email == email);

    if () {
      showToast(message: "Email does not exist");
      return; // Exit the function early if the email doesn't exist
    }

   // Check if there's a user with the provided email and password
    UserModel user = userList.firstWhere(
          (user) => user.email == email && user.password == password,
      orElse: () => null,
    );


    if (user != null) {
      showToast(message: "User is successfully signed in");

    } else {
      showToast(message: "Incorrect password");
    }  */


    String collectionName = _getCollectionName();

    if (collectionName == 'drivers') {
      // Redirect to driver home page
      Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => DriverHomePage()) ,);
    } else {
      // if users enters go to user home page
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()) );
    }
  }
  String _getCollectionName() {
    String dropdownValue = '';

    // Get the selected value from the dropdown
    setState(() {
      dropdownValue = _selectedValue; // Admin mi user mı driver mı
    });

    // Determine the collection name based on the selected dropdown value
    String collectionName = 'defaultCollection'; // Default collection name

    if (dropdownValue == 'User' ) {
      collectionName = 'users'; // Collection name for users
    } else if (dropdownValue == 'Driver') {
      collectionName = 'drivers'; // Collection name for admins
    }

    return collectionName;
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/bc_ic.png',
                      height: 200,
                      width: 200,
                      alignment: Alignment.center,
                    ),
                    Text(
                      "Chain Guard",
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black87,
                          fontSize: 55,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Login ",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.black87,
                            fontSize: 35,
                          ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    DropdownButtonFormField<String>(
                      value: 'User',
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedValue = newValue ?? 'User';
                        });
                      },
                      items: <String>['User', 'Driver']
                          .map<DropdownMenuItem<String>>(
                            (String value) =>
                            DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                      )
                          .toList(),
                    ),
                    const SizedBox(height: 10.0),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "You have to enter your email";
                            }
                            return null;
                          },
                          controller: _emailController,
                          style: const TextStyle(
                            color: Colors.black87,
                          ),
                          cursorColor: Colors.black87,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              label: Text("Email"),
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email_rounded,
                                  color: Colors.orange),
                              labelStyle: TextStyle(color: Color(0xFF001BFF)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2.0, color: Color(0xFF001BFF))))),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Form(
                      key: _passKey,
                      child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'You have to enter your password';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Colors.black87,
                          ),
                          cursorColor: Colors.black87,
                          controller: _passwordController,
                          obscureText: !passwordVisible,
                          decoration: InputDecoration(
                            label: const Text("Password"),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.fingerprint_rounded,
                                color: Colors.orange),
                            labelStyle:
                                const TextStyle(color: Color(0xFF001BFF)),
                            suffixIcon: IconButton(
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.orange,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                }),
                            hintText: 'Password',
                            prefixText: ' ',
                            hintStyle: const TextStyle(
                              color: Colors.black87,
                            ),
                            focusColor: Colors.black87,
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2.0, color: Color(0xFF001BFF))),
                          )),
                    ),
                    SizedBox(
                      height: size.height * 0.08,
                    ),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate() &&
                            _passKey.currentState!.validate()) {
                          _signIn();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: const BoxDecoration(
                            color: Colors.orange,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Center(
                              child: Text(
                            "Log In",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 1,
                            width: 75,
                            color: Colors.black87,
                          ),
                          const Text(
                            "Register",
                            style: TextStyle(color: Colors.black87),
                          ),
                          Container(
                            height: 1,
                            width: 75,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
