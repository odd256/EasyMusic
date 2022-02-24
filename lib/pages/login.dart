import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_music_player/models/user.dart';
import 'package:flutter_music_player/utils/http_manager.dart';
import 'package:flutter_music_player/utils/msg_util.dart';
import 'package:sp_util/sp_util.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Timer _timer;
  int _timeCounter = 60;
  bool hasSend = false; // 是否发送
  bool readySend = false; // 倒计时是否结束

  final _httpManager = HttpManager.getInstance();

  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  //发送验证码
  onSendCode() async {
    //对输入的手机号进行验证
    if (!RegExp(r"^1([38][0-9]|4[579]|5[0-3,5-9]|6[6]|7[0135678]|9[89])\d{8}$")
        .hasMatch(_phoneController.text)) {
      MsgUtil.warn('手机号错误！');
      return;
    }

    setState(() {
      hasSend = true;
    });

    //重置按钮状态 并开启倒数
    setState(() {
      readySend = false;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        _timeCounter -= 1;
      });
      if (_timeCounter == 0) {
        _timer.cancel();
        _timeCounter = 60;
        setState(() {
          readySend = true;
        });
      }
    });

    //向网络发送请求，请求获取验证码
    var data = await _httpManager.get(
        '/captcha/sent?phone=${_phoneController.text}',
        withLoading: false);
    if (data['code'] == 400) {
      MsgUtil.warn(data['message']);
    }
  }

  //登录
  onLogin() async {
    //先检验验证码的有效性
    if (!RegExp(r'^\d{4,}$').hasMatch(_codeController.text)) {
      MsgUtil.warn('验证码错误！');
      return;
    }

    //使用验证码登录
    try {
      var data = await _httpManager.get(
          '/login/cellphone?phone=${_phoneController.text}&captcha=${_codeController.text}');
      if (data['code'] == 200) {
        User user = User.fromJson(data);
        context.read<User>().updateUser(user); //更新user信息
        SpUtil.putObject('user', user);
        Navigator.of(context).pop(); // 返回上一界面
        Navigator.of(context).pop(); // 返回上一界面
      } else {
        if (data['message'] != null) {
          MsgUtil.warn(data['message']);
        }
      }
    } catch (e) {
      MsgUtil.primary("登录失败");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1000), () {});
  }

  @override
  Widget build(BuildContext context) {
    Widget phoneWidget = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          child: Container(
            margin: const EdgeInsets.only(left: 8),
            child: const Text(
              '登录体验更多内容',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          alignment: Alignment.topLeft,
        ),
        const SizedBox(
          height: 15,
        ),
        Align(
          child: Container(
              margin: const EdgeInsets.only(left: 8),
              child: const Text('目前仅支持手机登录，后续将开放更多的登录方式，主要是api的适配没有太多精力')),
          alignment: Alignment.topLeft,
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone_android), labelText: '手机号'),
          keyboardType: TextInputType.phone,
          controller: _phoneController,
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            width: double.infinity,
            child: ElevatedButton(
                onPressed: onSendCode, child: const Text('发送验证码')))
      ],
    );
    Widget codeWidget = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          child: Container(
            margin: const EdgeInsets.only(left: 8),
            child: const Text(
              '请输入验证码',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          alignment: Alignment.topLeft,
        ),
        const SizedBox(
          height: 15,
        ),
        Align(
          child: Container(
              margin: const EdgeInsets.only(left: 8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                            '已发送至+86 ${_phoneController.text.replaceRange(_phoneController.text.length < 3 ? _phoneController.text.length : 3, _phoneController.text.length < 7 ? _phoneController.text.length : 7, '****')}'),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                hasSend = false;
                              });
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 16,
                            )),
                      ],
                    ),
                    TextButton(
                        onPressed: readySend ? onSendCode : null,
                        child:
                            Text(readySend ? '重新发送' : _timeCounter.toString()))
                  ])),
          alignment: Alignment.topLeft,
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.check_circle), labelText: '验证码'),
          keyboardType: TextInputType.number,
          controller: _codeController,
        ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            width: double.infinity,
            child: ElevatedButton(onPressed: onLogin, child: const Text('登录')))
      ],
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '手机号登录',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: hasSend ? codeWidget : phoneWidget,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }
}
