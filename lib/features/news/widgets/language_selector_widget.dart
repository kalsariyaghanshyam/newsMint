import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/border_radius_extension.dart';
import '../../../core/extensions/edge_insets_extension.dart';
import '../../../core/extensions/typography_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/news_controller.dart';
import '../models/news_enums.dart';

class LanguageSelectorWidget extends StatelessWidget {
  const LanguageSelectorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsController>(
      builder: (context, controller, child) {
        return Container(
          padding: edge.v4h8,
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: radius.all16,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<NewsLanguage>(
              value: controller.selectedLanguage,
              dropdownColor: AppColors.surfaceDark,
              icon: const Icon(Icons.language, color: AppColors.white, size: 18),
              isDense: true,
              style: poppins.get12.bold.white,
              onChanged: (NewsLanguage? newLang) {
                if (newLang != null) {
                  controller.selectLanguage(newLang);
                }
              },
              items: NewsLanguage.values.map((NewsLanguage lang) {
                return DropdownMenuItem<NewsLanguage>(
                  value: lang,
                  child: Padding(
                    padding: edge.l4.copyWith(right: 6),
                    child: Text(
                      lang.displayName,
                      style: poppins.get13.regular.white,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
