import 'package:flutter/material.dart';
import 'package:chayil/domain/repositories/user_repository.dart';
import 'package:chayil/domain/models/users/user.dart';
import 'package:chayil/presentation/authentication/request_login_page.dart';
import 'package:chayil/utilities/styles/text_styles.dart';
import 'package:chayil/utilities/styles/colors.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  final _userRepository = UserRepository();
  String _version = '';
  String _build = '';

  @override
  void initState() {
    super.initState();
    _loadVersionInfo();
  }

  Future<void> _loadVersionInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
      _build = info.buildNumber;
    });
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _emailSupport() async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'app@chayilmartialarts.com',
      query: 'subject=Chayil App Support',
    );
    if (!await launchUrl(emailUri)) {
      throw 'Could not open email client';
    }
  }

  Future<void> _logout() async {
    User? user = await _userRepository.loadCachedUser();
    if (user != null && user.role == UserRole.admin) {
      await _userRepository.clearDevice();
    }

    await _userRepository.clearCachedUser();

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const RequestLoginPage()),
        (Route<dynamic> route) => false, // Remove all routes
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Logo
            Image.asset(
              'assets/images/logo.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 16),

            // Version
            Text('Version $_version ($_build)', style: paragraphTextStyle),

            const SizedBox(height: 32),
            const Divider(
              color: separatorColor,
              thickness: 1.0,
              height: 1.0,
            ),
            const SizedBox(height: 32),

            Text(
              'SUPPORT',
              style: boldParagraphTextStyle.copyWith(color: secondaryTextColor),
            ),

            const SizedBox(height: 16),

            // Support Links
            Column(
              children: [
                GestureDetector(
                  onTap: () => _launchUrl('https://chayilmartialarts.com'),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Visit Website',
                          style: paragraphTextStyle.copyWith(
                            color: accentColor,
                            decoration: TextDecoration.underline,
                            decorationColor: accentColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.open_in_new, color: accentColor),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _emailSupport,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Contact Support',
                          style: paragraphTextStyle.copyWith(
                            color: accentColor,
                            decoration: TextDecoration.underline,
                            decorationColor: accentColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.email, color: accentColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
            const Divider(
              color: separatorColor,
              thickness: 1.0,
              height: 1.0,
            ),
            const SizedBox(height: 32),

            // Terms & Privacy
            Text(
              'TERMS & PRIVACY',
              style: boldParagraphTextStyle.copyWith(color: secondaryTextColor),
            ),

            const SizedBox(height: 16),

            Column(
              children: [
                GestureDetector(
                  onTap: () =>
                      _launchUrl('https://chayilmartialarts.com/terms'),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Terms of Use',
                          style: paragraphTextStyle.copyWith(
                            color: accentColor,
                            decoration: TextDecoration.underline,
                            decorationColor: accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () =>
                      _launchUrl('https://chayilmartialarts.com/privacy'),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Privacy Policy',
                          style: paragraphTextStyle.copyWith(
                            color: accentColor,
                            decoration: TextDecoration.underline,
                            decorationColor: accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
            const Divider(
              color: separatorColor,
              thickness: 1.0,
              height: 1.0,
            ),
            const SizedBox(height: 32),

            // Account
            Text(
              'ACCOUNT',
              style: boldParagraphTextStyle.copyWith(color: secondaryTextColor),
            ),

            const SizedBox(height: 16),

            Column(
              children: [
                GestureDetector(
                  onTap: () => _logout(),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Logout',
                          style: paragraphTextStyle.copyWith(
                            color: accentColor,
                            decoration: TextDecoration.underline,
                            decorationColor: accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'The Chayil mobile app retains no personal information.',
                  style: TextStyle(fontSize: 13, color: secondaryTextColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
