import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/repositories/news_repository.dart';
import '../../../data/repositories/news_repository_impl.dart';
import '../../../services/preferences_service.dart';
import '../models/news_enums.dart';
import '../models/news_item.dart';

class NewsController extends ChangeNotifier {
  final NewsRepository _newsRepository;
  final Map<String, NewsItem> _bookmarkedMap = {};

  NewsController({NewsRepository? newsRepository})
      : _newsRepository = newsRepository ?? NewsRepositoryImpl() {
    _selectedLanguage = PreferencesService.getSavedLanguage();
    _loadSavedBookmarks();
  }

  NewsState _state = NewsState.initial;
  NewsCategory _selectedCategory = NewsCategory.topStories;
  NewsLanguage _selectedLanguage = NewsLanguage.english;

  List<NewsItem> _items = [];
  int _currentIndex = 0;
  String? _errorMessage;

  // Getters
  NewsState get state => _state;
  NewsCategory get selectedCategory => _selectedCategory;
  NewsLanguage get selectedLanguage => _selectedLanguage;
  List<NewsItem> get items => List.unmodifiable(_items);
  List<NewsItem> get bookmarkedItems => List.unmodifiable(_bookmarkedMap.values.toList().reversed);
  int get currentIndex => _currentIndex;
  String? get errorMessage => _errorMessage;
  int get totalCount => _items.length;

  NewsItem? get currentItem =>
      _items.isNotEmpty && _currentIndex < _items.length
          ? _items[_currentIndex]
          : null;

  void _loadSavedBookmarks() {
    final saved = PreferencesService.getSavedBookmarks();
    for (final item in saved) {
      item.isBookmarked = true;
      final key = _getItemKey(item);
      _bookmarkedMap[key] = item;
    }
  }

  String _getItemKey(NewsItem item) {
    return item.id.isNotEmpty ? item.id : item.link;
  }

  /// Check if a specific news item is currently bookmarked
  bool isBookmarked(NewsItem item) {
    final key = _getItemKey(item);
    return _bookmarkedMap.containsKey(key) || item.isBookmarked;
  }

  /// Initial load action
  Future<void> init() async {
    _selectedLanguage = PreferencesService.getSavedLanguage();
    _loadSavedBookmarks();
    await fetchNews();
  }

  /// Category change action
  Future<void> selectCategory(NewsCategory category) async {
    if (_selectedCategory == category && _state == NewsState.loaded) return;
    _selectedCategory = category;
    _currentIndex = 0;
    notifyListeners();
    await fetchNews();
  }

  /// Language change action
  Future<void> selectLanguage(NewsLanguage language) async {
    if (_selectedLanguage == language && _state == NewsState.loaded) return;
    _selectedLanguage = language;
    await PreferencesService.saveLanguage(language);
    _currentIndex = 0;
    notifyListeners();
    await fetchNews();
  }

  /// Fetch news data from repository
  Future<void> fetchNews() async {
    _state = NewsState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final news = await _newsRepository.fetchNews(
        language: _selectedLanguage,
        category: _selectedCategory,
      );

      if (news.isEmpty) {
        _items = [];
        _state = NewsState.empty;
      } else {
        _items = news;
        // Sync bookmark state for fetched items
        for (final item in _items) {
          final key = _getItemKey(item);
          if (_bookmarkedMap.containsKey(key)) {
            item.isBookmarked = true;
          }
        }
        _currentIndex = 0;
        _state = NewsState.loaded;
      }
    } catch (e) {
      _items = [];
      _errorMessage = 'Failed to load RSS feed. Please check your connection.';
      _state = NewsState.error;
    }

    notifyListeners();
  }

  /// Pull to refresh action
  Future<void> refreshNews() async {
    await fetchNews();
  }

  /// Page index update
  void setCurrentIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  /// Toggle bookmark for any news item
  void toggleBookmark(NewsItem item) {
    final key = _getItemKey(item);
    if (_bookmarkedMap.containsKey(key)) {
      _bookmarkedMap.remove(key);
      item.isBookmarked = false;
    } else {
      item.isBookmarked = true;
      _bookmarkedMap[key] = item;
    }

    // Also update in active list if present
    final index = _items.indexWhere((element) => _getItemKey(element) == key);
    if (index != -1) {
      _items[index].isBookmarked = item.isBookmarked;
    }

    PreferencesService.saveBookmarks(_bookmarkedMap.values.toList());
    notifyListeners();
  }

  /// Open web URL action
  Future<void> openArticleUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        debugPrint('Could not launch URL: $url');
      }
    }
  }
}
