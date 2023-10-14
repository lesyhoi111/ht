import 'package:flutter/material.dart';
import 'package:hiptech_app/home.dart';
import 'package:hiptech_app/model/userProfile.dart';
import 'package:hiptech_app/networkApi/networkRequest.dart';
import 'package:hiptech_app/provider/userProfile_Provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isShowPass = false;
  String stringErrorPass = '';
  String stringErrorUsername = '';
  String password = '';
  String username = '';
  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  void HandleLogin(BuildContext ctxt) async {
    Map<String, String> params = {
      "username": username,
      "password": password,
      "client_id": "notification",
      "client_secret": "ox1XZ6GhGVxBoaBBDWuCUCteQVZOB91L",
      "grant_type": "password",
      "Accept": "*/*",
      "Accept-Encoding": "gzip,deflate,br",
      "Connection": "keep-alive"
    };
    bool access = await NetworkRequest.getKeyLogin(params);
    if (access) {
      handlePutTokenFCM();
      Provider.of<UserProfileProvider>(context, listen: false).fetchProfile();
      Navigator.pushAndRemoveUntil(
        ctxt,
        MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
        (Route<dynamic> route) => false, // Xoá tất cả các lịch sử điều hướng
      );
      // Navigator.pushNamed(context, '/home');
    } else {
      setState(() {
        stringErrorPass = "Login Failed!";
      });
    }
  }

  Future handlePutTokenFCM() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    UserProfile userProfile = await NetworkRequest.getRole();
    String? id = userProfile.id;
    Map<String, dynamic> params = {"id": id, "fcmToken": fcmToken};
    bool result = await NetworkRequest.postFCM(params, id);
    if (result) {
      print(fcmToken);
    }
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets safeAreaInsets = MediaQuery.of(context).padding;
    return MaterialApp(
        title: 'Login',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          useMaterial3: true,
        ),
        home: Scaffold(
            body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                top: safeAreaInsets.top,
                left: safeAreaInsets.left,
                right: safeAreaInsets.right,
                bottom: safeAreaInsets.bottom),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Loginscreen.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.47,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20, top: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        // const Icon(
                        //   Icons.arrow_back_ios,
                        //   size: 35,
                        //   color: Colors.white,
                        // ),
                        Image.asset('assets/HiptechLogo.png')
                      ]),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome to Noti",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 35,
                                  color: Color.fromRGBO(39, 79, 107, 42),
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Manage your notifications easier",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(39, 79, 107, 42),
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.33,
                width: MediaQuery.of(context).size.width,
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 14),
                    child: Column(
                      children: [
                        TextFormField(
                          style: const TextStyle(color: Colors.black),
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(.08),
                            prefixIcon: const Icon(Icons.person),
                            prefixIconColor: Colors.grey,
                            labelText: 'Username',
                            labelStyle: const TextStyle(color: Colors.grey),
                            // hintText: 'Enter your user',
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    const BorderSide(color: Colors.red)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    const BorderSide(color: Colors.red)),
                            errorText: stringErrorUsername.isEmpty
                                ? null
                                : stringErrorUsername,
                          ),
                          onChanged: (value) {
                            setState(() {
                              username = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        TextFormField(
                          style: const TextStyle(color: Colors.black),
                          cursorColor: Colors.grey,
                          obscureText: !isShowPass,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(.08),
                            prefixIcon: const Icon(Icons.lock),
                            prefixIconColor: Colors.grey,
                            suffixIconColor: Colors.grey,
                            suffixIcon: IconButton(
                              icon: !isShowPass
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.remove_red_eye),
                              onPressed: () {
                                setState(() {
                                  isShowPass = !isShowPass;
                                });
                              },
                            ),
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    const BorderSide(color: Colors.red)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    const BorderSide(color: Colors.red)),
                            errorText: stringErrorPass.isEmpty
                                ? null
                                : stringErrorPass,
                          ),
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromRGBO(0, 210, 255, 1),
                              Color.fromRGBO(58, 123, 213, 0.84),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            stringErrorPass = (password == ''
                                ? 'Password is empty'
                                :
                                // (validateStructure(password))
                                //     ?
                                '');
                            // : 'Error password')

                            stringErrorUsername =
                                username.isEmpty ? 'Username is empty' : '';
                          });

                          if (password != '' &&
                              // validateStructure(password) &&
                              username != '') {
                            HandleLogin(context);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 29,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        )));
  }
}
