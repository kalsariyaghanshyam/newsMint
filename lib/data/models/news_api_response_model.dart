// News API Response Data Transfer Object Models

class NewsApiResponseModel {
  final String status;
  final int totalResults;
  final List<NewsArticleModel> articles;

  const NewsApiResponseModel({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsApiResponseModel.fromJson(Map<String, dynamic> json) {
    return NewsApiResponseModel(
      status: json['status'] as String? ?? 'error',
      totalResults: json['totalResults'] as int? ?? 0,
      articles: (json['articles'] as List<dynamic>?)
              ?.map((item) => NewsArticleModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'totalResults': totalResults,
      'articles': articles.map((a) => a.toJson()).toList(),
    };
  }
}

class NewsArticleModel {
  final String? id;
  final String title;
  final String description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;
  final NewsSourceModel source;

  const NewsArticleModel({
    this.id,
    required this.title,
    required this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    required this.source,
  });

  factory NewsArticleModel.fromJson(Map<String, dynamic> json) {
    return NewsArticleModel(
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      url: json['url'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] as String?,
      content: json['content'] as String?,
      source: json['source'] != null
          ? NewsSourceModel.fromJson(json['source'] as Map<String, dynamic>)
          : const NewsSourceModel(name: 'NewsMint'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
      'source': source.toJson(),
    };
  }
}

class NewsSourceModel {
  final String? id;
  final String name;

  const NewsSourceModel({
    this.id,
    required this.name,
  });

  factory NewsSourceModel.fromJson(Map<String, dynamic> json) {
    return NewsSourceModel(
      id: json['id'] as String?,
      name: json['name'] as String? ?? 'NewsMint',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
