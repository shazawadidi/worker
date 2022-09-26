import 'package:flutter/material.dart';

import 'home_page.dart';

class LoginScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: LoginPage());
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final bool _validate = false;
  bool _credentials = false;
  String USER_NAME = "Supervisor";
  String PASSWORD = "Super@zainsd";
  String? userName;
  String? password;
  bool _isHidden = true;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        color: Colors.teal.withOpacity(0.5),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 350,
              padding: const EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/zain.png",
                    width: 200,
                    height: 100,
                    color: Colors.grey,
                  ),
                  const Text(
                    'zain Attendance App',
                    style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    child: TextField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        filled: true,
                        errorText: _validate ? 'Value Can\'t Be Empty' : null,
                        contentPadding: EdgeInsets.only(top: 3),
                        fillColor: Colors.white,
                        hintText: "user name",
                        hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Icon(
                            Icons.supervised_user_circle,
                            color: Colors.teal,
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          userName = value;
                          print("userNameIS$userName");
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    child: TextField(
                      controller: passwordController,
                      obscureText: _isHidden,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        filled: true,
                        errorText: _validate ? 'Value Can\'t Be Empty' : null,
                        contentPadding: EdgeInsets.only(top: 3),
                        fillColor: Colors.white,
                        hintText: "password",
                        hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Icon(
                            Icons.admin_panel_settings_sharp,
                            color: Colors.teal,
                          ),
                        ),
                        suffix: Padding(
                          padding: const EdgeInsets.only(
                            right: 10.0,
                          ),
                          child: InkWell(
                            onTap: _togglePasswordView,

                            /// This is Magical Function
                            child: Icon(
                              _isHidden
                                  ?

                                  /// CHeck Show & Hide.
                                  Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          password = value;
                          print("passwordIS$password");
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 100,
                    ),
                    key: ValueKey(_credentials),
                    child: _credentials == true
                        ? const Text(
                            'Wrong Login Credentials',
                            style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.redAccent),
                          )
                        : Container(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(18)),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    side: BorderSide(
                                        color: Colors.teal.withOpacity(0.5)))),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.teal),
                      ),
                      onPressed: () {
                        if (userName == USER_NAME) {
                          if (password == PASSWORD) {
                            print("username :${userNameController.value.text}");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            );
                          } else {
                            passwordController.clear();
                            print("credentials : $_credentials");
                            if (!_credentials) {
                              _credentials = true;
                              setState(() {});
                            } else {
                              _credentials = false;
                              setState(() {});
                            }
                          }
                        } else {
                          userNameController.clear();
                          print("credentials : $_credentials");
                          if (!_credentials) {
                            _credentials = true;
                            setState(() {});
                          } else {
                            _credentials = false;
                            setState(() {});
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.login_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              "Login to Attend",
                              style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
