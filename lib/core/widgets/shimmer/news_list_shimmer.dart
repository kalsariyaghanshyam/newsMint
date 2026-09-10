import 'package:flutter/material.dart';
import 'news_card_shimmer.dart';

class NewsListShimmer extends StatelessWidget {
  const NewsListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const NewsCardShimmer(),
    );
  }
}
