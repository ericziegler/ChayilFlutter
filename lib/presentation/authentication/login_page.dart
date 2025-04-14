import 'package:chayil/utilities/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:chayil/domain/repositories/user_repository.dart';
import 'package:chayil/domain/models/users/user.dart';
import 'package:chayil/utilities/components/action_button.dart';
import 'package:chayil/utilities/components/app_field.dart';
import 'package:chayil/utilities/components/alert_dialog.dart';
import 'package:chayil/utilities/components/loading_widget.dart';
import 'package:chayil/presentation/main_tab/main_tab_page.dart';
import 'package:chayil/presentation/authentication/register_device_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userRepository = UserRepository();
  String _code = '';
  bool _isLoading = false;
  bool _isActionEnabled = false;

  void _onLoginPressed(BuildContext context) {
    if (!_isLoading) {
      FocusManager.instance.primaryFocus?.unfocus();
      _login(context);
    }
  }

  void _login(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool verificationSuccess = await _userRepository.verifyLoginCode(_code);

      if (!mounted) return; // ✅

      if (verificationSuccess) {
        User? user = await _userRepository.authenticateUser();

        if (!mounted) return; // ✅

        if (user == null) {
          showErrorAlert(
            context,
            "We were unable to log you in. Please make sure your login code is correct.",
          );
        } else {
          if (user.deviceId == null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const RegisterDevicePage()),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MainTabPage()),
            );
          }
        }
      } else {
        showErrorAlert(
          context,
          "We were unable to log you in. Please make sure your login code is correct.",
        );
      }
    } catch (e) {
      if (!mounted) return;
      showErrorAlert(
        context,
        "We were unable to log you in. Please make sure your login code is correct.",
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the height to offset the content
    final double screenHeight = MediaQuery.of(context).size.height;
    final double offsetHeight = screenHeight * 0.05; // 1/4 of the screen height

    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Stack(children: [
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Center(
              child: SizedBox(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: offsetHeight),
                    const Text(
                      'Enter Access Code',
                      style: headerTextStyle,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Check your email for your access code. Enter it here to access the curriculum.',
                      style: paragraphTextStyle,
                    ),
                    const SizedBox(height: 8),
                    AppField(
                      hintText: 'Access code',
                      keyboardType: const TextInputType.numberWithOptions(),
                      onChanged: (value) {
                        setState(() {
                          _code = value;
                          _isActionEnabled = (_code.isNotEmpty);
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ActionButton(
                      text: 'SUBMIT',
                      onPressed: _isActionEnabled
                          ? () => _onLoginPressed(context)
                          : null,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Give 1-3 minutes for code delivery.',
                      style: captionTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading) const LoadingWidget(),
        ]));
  }
}
