import 'package:flutter/material.dart';
import 'package:happen_link/home_page.dart';
import 'package:happen_link/services/api.dart';
import 'package:happen_link/widgets/password_field.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'consts.dart' as Consts;

class LoginPage extends StatefulWidget {
  static const routeName = '/loginpage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController ctrlEmail = TextEditingController();
  final TextEditingController ctrlPwd = TextEditingController();
  bool _saving = false;

  void loginClicked() async {
    setState(() {
      this._saving = true;
    });

    var res = await API.of(context).login(ctrlEmail.text, ctrlPwd.text);
    if (res == ELoginResult.OK) {
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    } else if (res == ELoginResult.LOGIN_INVALID) {
      final snackBar = SnackBar(
        content: Text('Usuário ou senha inválidos.'),
        duration: Duration(milliseconds: 2000),
      );
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else if (res == ELoginResult.ERROR) {
      final snackBar = SnackBar(
        content: Text('Não foi possível completar esta ação.'),
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
                      controller: ctrlEmail,
                      decoration: InputDecoration(
                        hintText: 'E-mail',
                      ),
                      keyboardType: TextInputType.emailAddress,
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
