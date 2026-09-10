# 📰 NewsMint — Modern Short News & Insights App

<div align="center">

![NewsMint Logo](assets/images/logo.png)

**Fast, Concise & Multilingual Short News Platform**  
*Stay informed with real-time news in English, Hindi (हिंदी), and Gujarati (ગુજરાતી).*

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Theme](https://img.shields.io/badge/Theme-Dark%20%26%20Light%20Mode-violet)](#-design-system--aesthetics)

---

</div>

## ✨ Overview

**NewsMint** ek modern, high-performance Flutter mobile application hai jo users ko concise, swipeable short news cards aur rich multilingual RSS feeds delivering karta hai. App mein dynamic Dark/Light theme support, custom vertical swipe feeds, smooth drag-to-dismiss image bottom sheets, aur robust fallback mechanisms built-in hain.

---

## 🔥 Key Features

### 🔀 Vertical Short News Feed (Inshorts Style)
- **Stack PageView Gesture Navigation**: Smooth vertical swiping experience with realistic card elevation & transitions.
- **Save & Share Integration**: Article bookmarking aur quick social sharing action options right on the news card.
- **Full-Screen Image Modal**: Tap on any article image to open a full-page viewer featuring smooth drag-down gesture dismissal.

### 🌐 Multilingual News Support
- **Dynamic Language Switcher**: Real-time language switching between:
  - 🇬🇧 **English** (Hindustan Times, Times of India)
  - 🇮🇳 **Hindi** (ABP Live - 100% verified RSS image & text feeds)
  - 🇮🇳 **Gujarati** (TV9 Gujarati - Full protocol-relative URL normalization)
- **Zero-Loss Image Extraction**: Advanced XML parsing pipeline for `content:encoded`, `media:content`, and `enclosure` tags.

### 🎨 Clean & Modern Design System
- **Centralized Design System**: Centralized `AppColors`, `AppStrings`, `AppConstants`, and clean extension helpers (`edge`, `radius`, `poppins`, `.height`, `.width`).
- **Seamless Theme Switching**: Fully responsive Light and Dark mode UI with cohesive contrast levels.
- **Theme-Aware Skeleton Loader**: Clean static skeleton loading states replacing heavy shimmer wave animations.
- **Unified `AppImage` Widget**: Handles network images, local assets, SVG protocols, and fallback to official **NewsMint** logo.

### 🔍 Unified Search & Discovery Hub
- **Interactive Search & Filter**: Instant search across titles, descriptions, and news sources with zero lag.
- **Quick Category Shortcuts**: Seamless navigation across Top Stories, Trending, Politics, India, Business, Sports, Technology, and World news.
- **Notifications & Insights Feeds**: Single notification tap opens target story, while "View All" launches a full swipeable feed.

---

## 🛠 Tech Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev) (Dart 3)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Networking & RSS**: `http`, `xml`, `html`, `intl`
- **Architecture**: **Clean Architecture / Feature-First Architecture**
  ```text
  lib/
  ├── core/                # Core Design Tokens, Theme, Extensions & Widgets
  │   ├── constants/       # AppStrings, AppConstants
  │   ├── extensions/      # Spacing, Typography, EdgeInsets & Radius
  │   ├── theme/           # AppColors & ThemeData
  │   └── widgets/         # AppImage, Skeleton Loaders
  ├── data/                # Repositories & RSS Data Sources
  │   ├── datasources/     # RssRemoteDataSource & XML Parsers
  │   ├── models/          # RssItemModel
  │   └── repositories/    # NewsRepository Implementation
  ├── features/            # Feature Modules (News, Search, Dashboard, Profile, Feed)
  │   ├── dashboard/       # Dashboard & Navigation Setup
  │   ├── feed/            # Main Feed View
  │   ├── news/            # Controllers, Enums, Models & NewsCard Widgets
  │   ├── profile/         # Profile & Settings View
  │   └── search/          # Search & Explore View
  └── main.dart            # Application Entrypoint & Providers
  ```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.0.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.0.0`)
- Android Studio / VS Code with Flutter Extension

### Installation Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/kalsariyaghanshyam/newsMint.git
   cd newsMint
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run Static Code Analysis**
   ```bash
   flutter analyze
   ```

4. **Launch the Application**
   ```bash
   flutter run
   ```

---

## 📸 Core Screenshots & Flow

| Vertical Feed View | Search & Discovery Hub | Image Modal BottomSheet |
|:---:|:---:|:---:|
| Short Swipe Cards with Save/Share | Instant Search & Quick Categories | Drag-down Dismissal & High Quality View |

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

Crafted with ❤️ by **NewsMint Team**

</div>
