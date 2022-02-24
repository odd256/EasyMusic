import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player/models/user.dart';
import 'package:flutter_music_player/utils/http_manager.dart';
import 'package:flutter_music_player/utils/msg_util.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _upassController = TextEditingController();
  final HttpManager _httpManager = HttpManager.getInstance();
  bool _sendButtonStatus = true;
  late Timer _timer;
  int _timeCounter = 60;

  _buildTextField(title, icon, type, controller) {
    return TextField(
      decoration: InputDecoration(labelText: title, suffixIcon: icon),
      keyboardType: type,
      controller: controller,
    );
  }

  _sendCode2Network() async {
    //向网络发送请求，请求获取验证码
    var data = await _httpManager.get('/captcha/sent?phone=${_unameController.text}');
    if (data['code'] == 400) {
      MsgUtil.warn(data['message']);
    }
    setState(() {
      _sendButtonStatus = false;
    });
  }

  @override
  void initState() {
    super.initState();
    print('hello');
    _timer = Timer(const Duration(milliseconds: 1000), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          height: 300,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              const Text(
                '我的音乐',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              _buildTextField(
                '手机号',
                const Icon(Icons.phone_android_rounded),
                TextInputType.phone,
                _unameController,
              ),
              _buildTextField(
                  '验证码',
                  _sendButtonStatus == true
                      ? IconButton(
                          onPressed: () {
                            //重置按钮状态 并开启倒数
                            _timer = Timer.periodic(
                                const Duration(milliseconds: 1000), (timer) {
                              setState(() {
                                _timeCounter -= 1;
                              });
                              if (_timeCounter == 0) {
                                _timer.cancel();
                                _timeCounter = 60;
                                setState(() {
                                  _sendButtonStatus = true;
                                });
                              }
                            });
                            _sendCode2Network();
                          },
                          icon: const Icon(Icons.schedule_send_rounded),
                        )
                      : SizedBox(
                          height: 10,
                          child: OutlinedButton(
                            onPressed: null,
                            child: Text(
                              '${_timeCounter}s',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                  TextInputType.visiblePassword,
                  _upassController),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 返回上一界面
                    Navigator.of(context).pop(); // 返回上一界面
                    context.read<User>().loginWithCode(_httpManager,
                        _unameController.text, _upassController.text);
                  },
                  child: const Text('登录'))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}
