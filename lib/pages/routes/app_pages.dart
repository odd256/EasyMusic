/*
 * @Creator: Odd
 * @Date: 2022-04-12 17:01:31
 * @LastEditTime: 2022-08-14 01:20:35
 * @FilePath: \EasyMusic\lib\pages\routes\app_pages.dart
 */
import 'package:flutter_easymusic/controllers/playlist_controller.dart';
import 'package:flutter_easymusic/controllers/playlist_songs_controller.dart';
import 'package:flutter_easymusic/controllers/qrcode_controller.dart';
import 'package:flutter_easymusic/controllers/search_controller.dart';
import 'package:flutter_easymusic/controllers/user_controller.dart';
import 'package:flutter_easymusic/pages/home/home_page.dart';
import 'package:flutter_easymusic/pages/login/login_choose_page.dart';
import 'package:flutter_easymusic/pages/login/login_qrcode_page.dart';
import 'package:flutter_easymusic/pages/play_now/current_song_page.dart';
import 'package:flutter_easymusic/pages/login/login_phone_page.dart';
import 'package:flutter_easymusic/pages/playlist/playlist_songs_page.dart';
import 'package:flutter_easymusic/pages/routes/app_routes.dart';
import 'package:flutter_easymusic/pages/search/search_page.dart';
import 'package:flutter_easymusic/pages/splash/splash_page.dart';
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
        page: () => const LoginChoosePage(),
        binding: LoginPageBinding()),
    GetPage(
        name: AppRoutes.loginPhone,
        page: () => const LoginPhonePage(),
        binding: LoginPageBinding()),
    GetPage(
        name: AppRoutes.loginQRCode,
        page: () => const LoginQRCodePage(),
        binding: LoginQRCodePageBinding()),
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
    Get.lazyPut(() => UserController());
  }
}

class LoginPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
  }
}

class LoginQRCodePageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QRCodeController>(() => QRCodeController());
  }
}

class SearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchController>(() => SearchController());
  }
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
