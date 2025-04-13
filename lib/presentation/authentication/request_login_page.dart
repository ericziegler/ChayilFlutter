import 'package:chayil/utilities/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:chayil/domain/repositories/user_repository.dart';
import 'package:chayil/utilities/components/action_button.dart';
import 'package:chayil/utilities/components/app_field.dart';
import 'package:chayil/utilities/components/alert_dialog.dart';
import 'package:chayil/utilities/components/loading_widget.dart';
import 'package:chayil/presentation/authentication/login_page.dart';

class RequestLoginPage extends StatefulWidget {
  const RequestLoginPage({Key? key}) : super(key: key);

  @override
  State<RequestLoginPage> createState() => _RequestLoginPageState();
}

class _RequestLoginPageState extends State<RequestLoginPage> {
  final _userRepository = UserRepository();
  String _email = '';
  bool _isLoading = false;
  bool _isActionEnabled = false;

  void _onRequestLoginPressed(BuildContext context) {
    if (!_isLoading) {
      FocusManager.instance.primaryFocus?.unfocus();
      _requestLoginCode(context);
    }
  }

  void _requestLoginCode(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _userRepository.requestLoginCode(_email);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LoginPage()));
    } catch (e) {
      if (!mounted) return;
      showErrorAlert(context,
          "We were unable to generate a code for your email address at this time.");
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
          title: const Text('Welcome'),
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
                    SizedBox(
                      width: 150,
                      child: Image.asset('assets/images/logo.png'),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Request Login Code',
                      style: headerTextStyle,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Enter your email address to have an access code sent to you.',
                      style: paragraphTextStyle,
                    ),
                    const SizedBox(height: 8),
                    AppField(
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                          _isActionEnabled = (_email.isNotEmpty);
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ActionButton(
                      text: 'REQUEST CODE',
                      onPressed: _isActionEnabled
                          ? () => _onRequestLoginPressed(context)
                          : null,
                    )
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading) const LoadingWidget(),
        ]));
  }
}
