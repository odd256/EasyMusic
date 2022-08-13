/*
 * @Creator: Odd
 * @Date: 2022-04-13 16:16:30
 * @LastEditTime: 2022-07-27 03:11:03
 * @FilePath: \EasyMusic\lib\pages\search_page.dart
 */
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easymusic/controllers/search_controller.dart';
import 'package:get/get.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchController = Get.find<SearchController>();

    return Scaffold(
        appBar: AppBar(
          title: SearchHeaderWidget(searchController: searchController),
          centerTitle: true,
          // ignore: prefer_const_constructors
        ),
        body: GetBuilder<SearchController>(builder: ((controller) {
          return searchController.withMore.value
              ? EasyRefresh.builder(
                  childBuilder: (context, physics) {
                    return ListView.builder(
                      physics: physics,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title:
                              Text(searchController.searchResult[index].name),
                        );
                      },
                      itemCount: searchController.searchResult.toList().length,
                    );
                  },
                  onLoad: () => searchController.searchByPage(),
                  footer: const ClassicFooter(
                      processingText: '加载中',
                      failedText: '加载失败',
                      readyText: '准备加载中',
                      processedText: '加载完成啦',
                      noMoreText: '不小心到底啦',
                      noMoreIcon:
                          Icon(Icons.sentiment_dissatisfied_rounded)),
                )
              : const Center(child: Text('找点新音乐！'));
        })));
  }
}

class SearchHeaderWidget extends StatelessWidget {
  const SearchHeaderWidget({
    Key? key,
    required this.searchController,
  }) : super(key: key);

  final SearchController searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      height: 36,
      child: Obx(() => TextField(
            controller: searchController.textController,
            maxLines: 1,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            autofocus: true,
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 9, horizontal: 1.0),
                hintText: "请输入搜索内容",
                border: InputBorder.none,
                // ignore: prefer_const_constructors
                suffixIcon: searchController.isBlank.isTrue
                    ? null
                    : IconButton(
                        iconSize: 20,
                        onPressed: () => searchController.searchByKeywords(),
                        icon: const Icon(Icons.search_rounded))),
            textAlignVertical: TextAlignVertical.center,
          )),
    );
  }
}
