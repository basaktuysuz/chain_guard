import 'package:chain_guard/src/db_helper/authservice.dart';
import 'package:chain_guard/src/db_helper/constant.dart';
import 'package:chain_guard/src/db_helper/mongo_crud.dart';
import 'package:chain_guard/src/view/screen/signup_screen.dart';
import 'package:flutter/material.dart';
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

  String _selectedValue = 'User';
  bool _isSigning = false;
  MongoDbCrud mongoDbCrud = MongoDbCrud();
  String _responseMessage = '';

  //List<dynamic>? userList;

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    setState(() {
      _isSigning = false;
    });
    // fetchData();
    bool isLoginSuccessful = false;

    final app = App(AppConfiguration('application-0-hzldcca'));

    var db = await M.Db.create(MONGO_CONNECTION_URL);
    await db.open();

    var userCollection = db.collection('users');

    String collectionName = _getCollectionName();
    print(collectionName);

    app.currentUser?.id;
    var currentUser = await userCollection.findOne({'email': email});
    AuthService().login(context, email, password, collectionName);

    //_loginUser(email, password);
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
    /*  final app = App(AppConfiguration('application-0-hzldcca'));

    var db = await M.Db.create(MONGO_CONNECTION_URL);
    await db.open();

    final user = await app.logIn(Credentials.emailPassword(email, password));
    var userCollection = db.collection('users');
     var user = await userCollection.findOne({'email': email});  // Find user by email


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
  }

  String _getCollectionName() {
    String dropdownValue = '';

    // Determine the collection name based on the selected dropdown value
    String collectionName = _selectedValue; // Default collection name

    if (dropdownValue == 'User') {
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
                    // Initialize with a default value

                    DropdownButtonFormField<String>(
                      value: _selectedValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedValue = newValue ?? 'User';
                          _getCollectionName();
                          // Update _selectedValue
                        });
                      },
                      items: <String>['User', 'Driver']
                          .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
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
