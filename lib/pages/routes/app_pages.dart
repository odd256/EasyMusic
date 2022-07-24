/*
 * @Creator: Odd
 * @Date: 2022-04-12 17:01:31
 * @LastEditTime: 2022-07-25 01:26:11
 * @FilePath: \flutter_easymusic\lib\pages\routes\app_pages.dart
 */
import 'package:flutter_easymusic/controllers/playlist_controller.dart';
import 'package:flutter_easymusic/controllers/playlist_songs_controller.dart';
import 'package:flutter_easymusic/controllers/user_controller.dart';
import 'package:flutter_easymusic/pages/current_song_page.dart';
import 'package:flutter_easymusic/pages/home_page.dart';
import 'package:flutter_easymusic/pages/login_page.dart';
import 'package:flutter_easymusic/pages/playlist_songs_page.dart';
import 'package:flutter_easymusic/pages/routes/app_routes.dart';
import 'package:flutter_easymusic/pages/search_page.dart';
import 'package:flutter_easymusic/pages/splash_page.dart';
import 'package:get/get.dart';

class AppPages {
  static const initPage = AppRoutes.splash;
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomePageBinding(),
    ),
    GetPage(
        name: AppRoutes.search,
        page: () => const SearchPage(),
        binding: SearchBinding()),
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
        name: AppRoutes.login,
        page: () => const LoginPage(),
        binding: LoginPageBinding()),
    GetPage(
        name: AppRoutes.playlistSongs,
        page: () => PlaylistSongsPage(),
        binding: PlaylistSongsPageBinding()),
    GetPage(
        name: AppRoutes.currentSong,
        page: () => const CurrentSongPage(),
        ),
  ];
}

class HomePageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlaylistController());
  }
}

class LoginPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
  }
}

class SearchBinding implements Bindings {
  @override
  void dependencies() {}
}

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<UserController>(() => UserController());
  }
}

class PlaylistSongsPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<PlaylistSongsController>(PlaylistSongsController());
  }
}
