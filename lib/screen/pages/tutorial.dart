import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solo/screen/colors.dart';
import 'package:solo/screen/router.dart';
import 'package:solo/screen/states/settings_state.dart';

class TutorialPage extends HookConsumerWidget {
  const TutorialPage({super.key, this.isFromMenu = false});

  final bool isFromMenu;

  Widget _buildImageWithErrorHandling(
      BuildContext context, int index, TutorialStep step) {
    if (index == 0) {
      // Welcome screen - show logo
      return Image.asset(
        'assets/icon/logo.png',
        width: 200,
        height: 200,
        cacheWidth: 200,
        cacheHeight: 200,
        errorBuilder: (context, error, stackTrace) =>
            _buildErrorFallback(context),
      );
    } else if (step.imagePlaceholder.endsWith('.png')) {
      // Other screens - show specified images
      return Image.asset(
        'assets/icon/tutorial/${step.imagePlaceholder}',
        height: 280,
        cacheHeight: 280,
        fit: step.imagePlaceholder == 'todoList.png'
            ? BoxFit.cover
            : BoxFit.fitHeight,
        errorBuilder: (context, error, stackTrace) =>
            _buildErrorFallback(context),
      );
    } else {
      // Fallback for placeholder text
      return _buildTextFallback(context, step);
    }
  }

  Widget _buildErrorFallback(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .mutedTextColor
              .withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.mutedTextColor,
          ),
          const SizedBox(height: 8),
          Text(
            '画像を読み込めませんでした',
            style: TextStyle(
              color: Theme.of(context).colorScheme.mutedTextColor,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTextFallback(BuildContext context, TutorialStep step) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          step.imagePlaceholder,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.mutedTextColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final currentPage = useState(0);
    final settingsController = ref.read(settingsStateProvider.notifier);

    final tutorialSteps = [
      const TutorialStep(
        title: 'Solo Todoへようこそ！',
        description: 'このアプリは、あなたの生産性を向上させるための\nTodo管理とタイマー機能を提供します。',
        imagePlaceholder: 'アプリのメイン画面の画像を追加',
      ),
      const TutorialStep(
        title: 'Todoの追加',
        description: 'Todo画面の新しいTodoを追加ボタンをタップして\n新しいTodoを追加できます。',
        imagePlaceholder: 'todoAdd.png',
      ),
      const TutorialStep(
        title: 'Todoの管理',
        description: 'カレンダーの日付をタップして\nその日のTodoを確認・編集できます。',
        imagePlaceholder: 'todoCalendar.png',
      ),
      const TutorialStep(
        title: 'Todoの確認',
        description: 'Todoのカードをタップして詳細を確認。\n完了したTodoはチェックで完了にできます。',
        imagePlaceholder: 'todoList.png',
      ),
      const TutorialStep(
        title: 'タイマー',
        description: '設定画面やTodoで設定したタイマーに基づいて\nポモドーロ、カウントアップタイマーが使用できます。',
        imagePlaceholder: 'timer.png',
      ),
    ];

    void handlePageChanged(int page) {
      currentPage.value = page;
    }

    void handleSkip() {
      if (isFromMenu) {
        // メニューから開いた場合は前の画面に戻る
        context.pop();
      } else {
        // 初回起動時はチュートリアル完了フラグを更新してホーム画面へ
        settingsController.updateHasCompletedTutorial(true);
        context.go(RouterDefinition.root.path);
      }
    }

    void handleNext() {
      if (currentPage.value < tutorialSteps.length - 1) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        handleSkip();
      }
    }

    void handlePrevious() {
      if (currentPage.value > 0) {
        pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }

    Widget buildTutorialImage(
        BuildContext context, int index, TutorialStep step) {
      return _buildImageWithErrorHandling(context, index, step);
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: Theme.of(context).colorScheme.backgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: handleSkip,
                    child: Text(
                      isFromMenu ? '閉じる' : 'スキップ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              // Tutorial content
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: handlePageChanged,
                  itemCount: tutorialSteps.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: buildTutorialImage(
                                  context, index, tutorialSteps[index]),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Title
                          Text(
                            tutorialSteps[index].title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Description
                          Flexible(
                            child: Text(
                              tutorialSteps[index].description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryTextColor,
                                height: 1.5,
                              ),
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Navigation
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        tutorialSteps.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: currentPage.value == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: currentPage.value == index
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Navigation buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Previous button
                        SizedBox(
                          width: 100,
                          child: currentPage.value > 0
                              ? TextButton(
                                  onPressed: handlePrevious,
                                  child: Text(
                                    '戻る',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryTextColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ),

                        // Next/Complete button
                        ElevatedButton(
                          onPressed: handleNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            currentPage.value < tutorialSteps.length - 1
                                ? '次へ'
                                : '始める',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TutorialStep {
  final String title;
  final String description;
  final String imagePlaceholder;

  const TutorialStep({
    required this.title,
    required this.description,
    required this.imagePlaceholder,
  });
}
