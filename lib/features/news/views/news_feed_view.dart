import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/spacing_extension.dart';
import '../../../core/extensions/typography_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../reusable/stack_page_view.dart';
import '../controllers/news_controller.dart';
import '../models/news_enums.dart';
import '../widgets/category_bar_widget.dart';
import '../widgets/language_selector_widget.dart';
import '../widgets/news_card_widget.dart';
import '../widgets/state_widgets.dart';

class NewsFeedView extends StatefulWidget {
  const NewsFeedView({Key? key}) : super(key: key);

  @override
  State<NewsFeedView> createState() => _NewsFeedViewState();
}

class _NewsFeedViewState extends State<NewsFeedView> {
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
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        titleSpacing: 12,
        title: Row(
          children: [
            const Icon(
              Icons.newspaper_rounded,
              color: AppColors.accentSky,
              size: 24,
            ),
            8.width,
            Text(
              AppStrings.appTitle,
              style: poppins.get18.bold.letterSpace(1.1).white,
            ),
            const Spacer(),
            const LanguageSelectorWidget(),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.categoryBarHeight),
          child: CategoryBarWidget(),
        ),
      ),
      body: Consumer<NewsController>(
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
                color: AppColors.accentSky,
                backgroundColor: AppColors.primaryDark,
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
    );
  }
}
