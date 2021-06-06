import 'package:flutter/material.dart';
import 'package:happen_link/home_page.dart';
import 'package:happen_link/services/api.dart';
import 'package:happen_link/widgets/password_field.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'consts.dart' as Consts;

class LoginPage extends StatefulWidget {
  static const routeName = '/login-list';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController ctrlEmail = TextEditingController(text: 'ramon@misoftware.com.br');
  final TextEditingController ctrlPwd = TextEditingController(text: 'SEnha123');
  bool _saving = false;

  void loginClicked() async {
    setState(() {
      this._saving = true;
    });

    try {
      await API.login(ctrlEmail.text, ctrlPwd.text);
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    } catch (e) {
      final snackBar = SnackBar(
        content: Text('Falha no login'),
        duration: Duration(milliseconds: 2000),
      );
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

    setState(() {
      this._saving = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        isLoading: _saving,
        color: Consts.LOADING_OVERLAY_COLOR,
        progressIndicator: Consts.LOADING_INDICATOR,
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/loginbg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image(
                      image: AssetImage('assets/logo.png'),
                      width: 300,
                      height: 120,
                    ),
                  ),
                  Container(
                    height: 43,
                    child: TextField(
                      autofocus: true,
                      controller: ctrlEmail,
                      decoration: InputDecoration(
                        hintText: 'E-mail',
                      ),
                    ),
                  ),
                  Container(
                    height: 43,
                    child: PasswordField(ctrlPwd),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ButtonTheme(
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: loginClicked,
                          child: Text(
                            "LOGIN",
                          ),
                        ),
                      ),
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
