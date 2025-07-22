import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/screen/widgets/global.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPage extends HookConsumerWidget {
  const PrivacyPolicyPage({super.key});

  static const String privacyPolicyUrl = 'https://tkwork.tech/privacy-policy-solo/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BulderWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('プライバシーポリシー'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () => context.go('/about'),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Theme.of(context).colorScheme.backgroundGradient,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: Theme.of(context).colorScheme.primaryGradient,
                          ),
                        ),
                        child: Icon(
                          Icons.privacy_tip_rounded,
                          size: 48,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'プライバシーポリシー',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primaryTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'このアプリのプライバシーポリシーを\nご確認いただけます',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondaryTextColor,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _openPrivacyPolicy,
                          icon: const Icon(Icons.open_in_browser_rounded),
                          label: const Text(
                            'プライバシーポリシーを開く',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.accentColor,
                            foregroundColor: Theme.of(context).colorScheme.surface,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'ブラウザで外部サイトが開きます',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openPrivacyPolicy() async {
    final uri = Uri.parse(privacyPolicyUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // フォールバック: URLをクリップボードにコピー
        // または、エラーメッセージを表示
        throw 'Could not launch $privacyPolicyUrl';
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      // エラーハンドリング - 必要に応じてスナックバーなどでユーザーに通知
    }
  }
}