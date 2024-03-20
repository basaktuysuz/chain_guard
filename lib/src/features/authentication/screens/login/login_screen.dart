import 'package:chain_guard/src/Firebase/auth.dart';
import 'package:chain_guard/src/common_widgets/toast.dart';
import 'package:chain_guard/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:chain_guard/src/features/readbarcode/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  bool _isSigning = false;



  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      showToast(message: "User is successfully signed in");
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const HomePage()),
      );
    } else {
      showToast(message: "some error occured");
    }
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
                              prefixIcon:
                                  Icon(Icons.email_rounded, color: Colors.orange),
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
                            labelStyle: const TextStyle(color: Color(0xFF001BFF)),
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
