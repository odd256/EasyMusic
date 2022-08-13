/*
 * @Creator: Odd
 * @Date: 2022-07-26 13:24:21
 * @LastEditTime: 2022-07-27 02:36:12
 * @FilePath: \EasyMusic\lib\controllers\search_controller.dart
 */
import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easymusic/api/song_api.dart';
import 'package:flutter_easymusic/models/album.dart';
import 'package:flutter_easymusic/models/artist.dart';
import 'package:flutter_easymusic/models/song.dart';
import 'package:flutter_easymusic/utils/msg_util.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  SearchController();
  final textController = TextEditingController();
  // final scrollController = ScrollController();
  final isBlank = true.obs;

  List<Song> searchResult = List<Song>.empty();
  final totalCount = 0.obs;
  final pageNum = 0.obs;
  final withMore = false.obs; //是否是分页查询

  @override
  void onInit() {
    textController.addListener(() {
      if (textController.text.isEmpty) {
        isBlank.value = true;
      } else {
        isBlank.value = false;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  //按下搜索按钮，通过关键词搜索歌曲
  Future<void> searchByKeywords({int limit = 30}) async {
    //初始化参数
    pageNum.value = 0;

    //请求数据
    var data = await SongApi.searchSongsWithPage(
        textController.text, limit, limit * pageNum.value);
    if (data['code'] == 200) {
      //接收成功

      //如果没有，内容直接返回
      if (data['result']['songCount'] == 0) {
        MsgUtil.warn('你搜索的歌爷没找到！');
        return;
      }

      withMore.value = true;
      //获取搜索结果
      searchResult = data['result']['songs'].map<Song>((e) {
        final ar = e['ar'].map<Artist>((v) => Artist.fromJson(v)).toList();
        final al = Album.fromJson(e['al']);
        final s = Song.fromJson(e, ar, al);
        return s;
      }).toList();

      //获取数据总量
      totalCount.value = data['result']['songCount'];

      //为了List<Song>手动更新
      update();
    } else {
      MsgUtil.warn('请求失败，code:${data['code']}');
    }
  }

  //实现分页
  searchByPage({int limit = 30}) async {
    //初始化参数
    pageNum.value = pageNum.value + 1;

    //如果数据到头了直接返回
    if (limit * pageNum.value >= totalCount.value) {
      return IndicatorResult.noMore;
    }

    //请求分页数据
    var data = await SongApi.searchSongsWithPage(
        textController.text, limit, limit * pageNum.value);

    List<Song> r = data['result']['songs'].map<Song>((e) {
      final ar = e['ar'].map<Artist>((v) => Artist.fromJson(v)).toList();
      final al = Album.fromJson(e['al']);
      final s = Song.fromJson(e, ar, al);
      return s;
    }).toList();
    searchResult.addAll(r);
    //为了List<Song>手动更新
    update();
  }
}
