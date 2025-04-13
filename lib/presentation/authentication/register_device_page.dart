import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:chayil/utilities/styles/colors.dart';
import 'package:chayil/utilities/styles/text_styles.dart';
import 'package:chayil/domain/repositories/user_repository.dart';
import 'package:chayil/domain/models/users/user.dart';
import 'package:chayil/utilities/components/action_button.dart';
import 'package:chayil/utilities/components/alert_dialog.dart';
import 'package:chayil/utilities/components/loading_widget.dart';
import 'package:chayil/presentation/main_tab/main_tab_page.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterDevicePage extends StatefulWidget {
  const RegisterDevicePage({Key? key}) : super(key: key);

  @override
  State<RegisterDevicePage> createState() => _RegisterDevicePage();
}

class _RegisterDevicePage extends State<RegisterDevicePage> {
  final _userRepository = UserRepository();
  bool _isLoading = false;

  void _onRegisterPressed(BuildContext context) {
    if (!_isLoading) {
      FocusManager.instance.primaryFocus?.unfocus();
      _registerDevice(context);
    }
  }

  void _registerDevice(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final email = await _userRepository.loadSecureEmail() ?? '';
    User? user = await _userRepository.registerDevice(email);

    if (!mounted) return; // ✅

    if (user == null) {
      showErrorAlert(
        context,
        "We were unable to log you in. Please make sure your login code is correct.",
      );
    } else {
      if (user.deviceId == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const RegisterDevicePage()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainTabPage()),
        );
      }
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {}
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the height to offset the content
    final double screenHeight = MediaQuery.of(context).size.height;
    final double offsetHeight = screenHeight * 0.05; // 1/4 of the screen height

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Device"),
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
                    'Register Your Device',
                    style: headerTextStyle,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'ATTENTION!',
                    style: warningTextStyle,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You are only able to register ONE device. Once you register this device, you will not be able to access the Chayil Mobile app on any other device.',
                    style: paragraphTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: captionTextStyle,
                      children: [
                        const TextSpan(
                            text:
                                'By clicking REGISTER DEVICE, you agree to our '),
                        TextSpan(
                          text: 'Terms of Use',
                          style: captionTextStyle.copyWith(
                            decoration: TextDecoration.underline,
                            color: accentColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchUrl(
                                  'https://chayilmartialarts.com/mobile-terms.html');
                            },
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: captionTextStyle.copyWith(
                            decoration: TextDecoration.underline,
                            color: accentColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchUrl(
                                  'https://chayilmartialarts.com/mobile-privacy.html');
                            },
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading) const LoadingWidget(),
      ]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: ActionButton(
            text: 'REGISTER DEVICE',
            onPressed: () => _onRegisterPressed(context),
          ),
        ),
      ),
    );
  }
}
