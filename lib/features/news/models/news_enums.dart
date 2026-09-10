enum NewsCategory {
  topStories('Top Stories', 'ટોપ સ્ટોરીઝ', 'टॉप स्टोरीज़'),
  trending('Trending', 'ટ્રેન્ડિંગ', 'ट्रेंडिंग'),
  politics('Politics', 'રાજકારણ', 'राजनीति'),
  india('India', 'ભારત', 'भारत'),
  gujarat('Gujarat', 'ગુજરાત', 'गुजरात'),
  business('Business', 'વેપાર', 'बिजनेस'),
  shareMarket('Share Market', 'શેર બજાર', 'शेयर बाजार'),
  sports('Sports', 'રમતગમત', 'खेल'),
  technology('Technology', 'ટેકનોલોજી', 'टेक'),
  entertainment('Entertainment', 'મનોરંજન', 'मनोरंजन'),
  world('World', 'વિશ્વ', 'दुनिया');

  final String englishLabel;
  final String gujaratiLabel;
  final String hindiLabel;

  const NewsCategory(this.englishLabel, this.gujaratiLabel, this.hindiLabel);

  String getLabel(NewsLanguage lang) {
    switch (lang) {
      case NewsLanguage.gujarati:
        return gujaratiLabel;
      case NewsLanguage.hindi:
        return hindiLabel;
      case NewsLanguage.english:
        return englishLabel;
    }
  }
}

enum NewsLanguage {
  english('English', 'en'),
  hindi('हिंदी', 'hi'),
  gujarati('ગુજરાતી', 'gu');

  final String displayName;
  final String code;

  const NewsLanguage(this.displayName, this.code);
}

enum NewsState {
  initial,
  loading,
  loaded,
  error,
  empty,
}
