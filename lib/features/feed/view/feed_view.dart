import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../../reusable/stack_page_view.dart';
import '../../news/controllers/news_controller.dart';
import '../../news/models/news_enums.dart';
import '../../news/widgets/category_bar_widget.dart';
import '../../news/widgets/news_card_widget.dart';
import '../../news/widgets/state_widgets.dart';

class FeedView extends StatefulWidget {
  const FeedView({Key? key}) : super(key: key);

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsController>().init();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryAccent = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top minimal categories bar matching Image 1
            const CategoryBarWidget(),

            // Main swipe feed body
            Expanded(
              child: Consumer<NewsController>(
                builder: (context, controller, child) {
                  switch (controller.state) {
                    case NewsState.initial:
                    case NewsState.loading:
                      return const LoadingView();

                    case NewsState.error:
                      return ErrorView(
                        message: controller.errorMessage ?? AppStrings.defaultErrorMsg,
                        onRetry: () => controller.fetchNews(),
                      );

                    case NewsState.empty:
                      return EmptyView(
                        onRefresh: () => controller.fetchNews(),
                      );

                    case NewsState.loaded:
                      return RefreshIndicator(
                        onRefresh: () => controller.refreshNews(),
                        color: primaryAccent,
                        backgroundColor: theme.cardColor,
                        child: PageView.builder(
                          scrollDirection: Axis.vertical,
                          controller: _pageController,
                          itemCount: controller.items.length,
                          onPageChanged: (index) {
                            controller.setCurrentIndex(index);
                          },
                          itemBuilder: (context, index) {
                            final item = controller.items[index];
                            return StackPageView(
                              controller: _pageController,
                              index: index,
                              child: NewsCardWidget(
                                newsItem: item,
                                currentIndex: index,
                                totalCount: controller.items.length,
                              ),
                            );
                          },
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
