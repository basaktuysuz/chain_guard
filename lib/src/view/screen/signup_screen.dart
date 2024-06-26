import 'package:chain_guard/src/common_widgets/toast.dart';
import 'package:chain_guard/src/db_helper/authservice.dart';
import 'package:chain_guard/src/db_helper/constant.dart';
import 'package:chain_guard/src/db_helper/mongo_crud.dart';
import 'package:chain_guard/src/view/model/user_model.dart';
import 'package:chain_guard/src/view/screen/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:realm/realm.dart' as R;
import 'package:realm/realm.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();

  String _selectedValue = 'User';
  MongoDbCrud mongoDbCrud = MongoDbCrud();
  List<dynamic>? userList;
  final _formKey = GlobalKey<FormState>();

  bool passwordVisible = false;

  final _userNameKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _passKey_1 = GlobalKey<FormState>();
  final _phonenoKey_2 = GlobalKey<FormState>();

  Future<void> _submitForm() async {

/*    final app = App(AppConfiguration('application-0-hzldcca'));

    var db = await M.Db.create(MONGO_CONNECTION_URL);
    await db.open();
    try {
      R.Credentials userCredentials = R.Credentials.emailPassword(
          _emailController.text,
          _passwordController.text);
    /*  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(

      );

     */
      EmailPasswordAuthProvider authProvider = EmailPasswordAuthProvider(app);
      await authProvider.registerUser( _emailController.text,  _passwordController.text, _passwordController.text);

      // If user creation is successful, proceed to store additional user information in Firestore
      _storeUserData(userCredentials);
    } catch (e) {
      // Handle any errors that occur during user creation
      print("Error occurred during user creation: $e");
    }
*/

  String collectionName = _getCollectionName();
  print(collectionName);
    AuthService().addUser(_emailController.text, _passwordController.text,_nameController.text,_phoneNoController.text ,collectionName.toString(),_idController.text);


   // _storeUserData();
  }

  Future<void> _storeUserData() async {
    final app = App(AppConfiguration('application-0-hzldcca'));

    await mongoDbCrud.insertItem(
        'users',
        UserModel(
            fullname: _nameController.text.toString(),
            email: _emailController.text.toString(),
            role: _selectedValue,
            phoneNo: int.parse(_phoneNoController.text),
            password: _passwordController.text.toString(),
            id: int.parse(_idController.text),
            url: "https://www.pngarts.com/files/11/Avatar-Free-PNG-Image.png")
            .toJson());

    final user = app.currentUser!;
    final updatedTimestamp = DateTime.now().millisecondsSinceEpoch;
    final updatedCustomUserData = {
      "fullname": _nameController.text.toString(),
      "email": _emailController.text.toString(),
      "role": _selectedValue,
      "phoneNo": int.parse(_phoneNoController.text),
      "password": _passwordController.text.toString(),
      "id": int.parse(_idController.text),
      "url": "https://www.pngarts.com/files/11/Avatar-Free-PNG-Image.png"
    };
    await user.functions.call("writeCustomUserData", [updatedCustomUserData]);


    // Contains the `updatedCustomUserData` object just added

// in the above Atlas Function call
    final customUserData = await user.refreshCustomData();
    userList = await mongoDbCrud.getList('users');
    setState(() {});

    //* Clearing TextFields
    _nameController.clear();
    _emailController.clear();
    _idController.clear();
    _idController.clear();
    _idController.clear();
/*// firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String collectionName = _getCollectionName();

    CollectionReference collection = firestore.collection(collectionName);

    collection.doc(_idController.text).set({
      'url': 'https://www.pngarts.com/files/11/Avatar-Free-PNG-Image.png',
      'fullname': _nameController.text,
      'email': _emailController.text,
      'phoneNo': _phoneNoController.text,
      'password': _passwordController.text,
      'id Number': _idController.text,
      'role': _selectedValue,
    }).then((value) {
      // If data storage is successful, navigate to the next screen or perform any other actions
      showToast(
          message: "User is successfully created \n Use login page to log in");
      print("User data stored successfully");
    }).catchError((error) {
      // Handle any errors that occur during data storage
      print("Error occurred during data storage: $error");
    });

 */
  }

  String _getCollectionName() {
    String dropdownValue = ''; // Initialize with an empty string

    // Get the selected value from the dropdown
    setState(() {
      dropdownValue = _selectedValue; // Admin mi user mı driver mı
    });

    // Determine the collection name based on the selected dropdown value
    String collectionName = 'defaultCollection'; // Default collection name

    if (dropdownValue == 'User' || dropdownValue == 'Driver') {
      collectionName = 'users'; // Collection name for users
    } else if (dropdownValue == 'Admin') {
      collectionName = 'admins'; // Collection name for admins
    }

    return collectionName;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/bc_ic.png',
                    height: 200,
                    width: 200,
                    alignment: Alignment.center,
                  ),
                  Text(
                    "Chain Guard",
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(
                        color: Colors.black87,
                        fontSize: 55,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Sign up ",
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                      color: Colors.black87,
                      fontSize: 35,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: "Fullname",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_outline_rounded,
                                color: Colors.orange),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your fullname';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          controller: _idController,
                          decoration: const InputDecoration(
                            labelText: "ID Number",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.security_rounded,
                                color: Colors.orange),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your ID Number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(),
                            prefixIcon:
                            Icon(Icons.email_rounded, color: Colors.orange),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          controller: _phoneNoController,
                          decoration: const InputDecoration(
                            labelText: "Phone No",
                            border: OutlineInputBorder(),
                            prefixIcon:
                            Icon(Icons.phone_rounded, color: Colors.orange),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(),
                            prefixIcon:
                            Icon(Icons.lock_rounded, color: Colors.orange),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        InkWell(
                          onTap: () {
                            // Trigger validation for all input fields
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, submit it
                              _submitForm();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Center(
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
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
                                "Already Have an Account?",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
