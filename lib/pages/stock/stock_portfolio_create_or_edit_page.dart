import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:stock_app/api/stock_portfolio_api.dart';
import 'package:stock_app/appbar/text_center_appbar.dart';
import 'package:stock_app/dialog/confirm_dialog.dart';
import 'package:stock_app/store/user_store.dart';
import 'package:stock_app/widgets/stocks/stock_input_form.dart';

class StockPortfolioCreateOrEditPage extends StatefulWidget {
  final List<Map<String, int>> symbolRatioList;
  final dynamic info;
  final bool isEditPortfolio;
  const StockPortfolioCreateOrEditPage(
      {super.key,
      this.symbolRatioList = const [],
      this.info = const {},
      this.isEditPortfolio = false});

  @override
  State<StockPortfolioCreateOrEditPage> createState() =>
      _StockPortfolioCreateOrEditPageState();
}

class _StockPortfolioCreateOrEditPageState
    extends State<StockPortfolioCreateOrEditPage> {
  int _count = 0;
  List stockList = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _writerController = TextEditingController();
  final TextEditingController _initialPriceController = TextEditingController();
  final List<TextEditingController> _stockControllerList = [];
  final List<TextEditingController> _ratioControllerList = [];
  final _stockFormKey = GlobalKey<FormState>();
  final _controller = Get.put(UserStore());
  String userId = "";

  @override
  void initState() {
    if (widget.isEditPortfolio) {
      _setPortfolioInfo();
    } else {
      _setUserInfo();
    }
    super.initState();
  }

  void _setUserInfo() {
    userId = _controller.user["id"];
    _writerController.text = _controller.user["name"];

    _count = 1;
    _stockControllerList.add(TextEditingController());
    _ratioControllerList.add(TextEditingController());
  }

  void _setPortfolioInfo() {
    _titleController.text = widget.info['title'];
    _writerController.text = widget.info['writer'];
    _initialPriceController.text = widget.info['initial_price'].toString();

    for (int i = 0; i < widget.symbolRatioList.length; i++) {
      if (widget.symbolRatioList[i]['${widget.info['stock${i + 1}']}'] == 0) {
        return;
      }

      _stockControllerList.add(TextEditingController());
      _ratioControllerList.add(TextEditingController());

      _stockControllerList[i].text = widget.info['stock${i + 1}'];
      _ratioControllerList[i].text = widget.symbolRatioList[i]
              ['${widget.info['stock${i + 1}']}']
          .toString();

      ++_count;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double _width = size.width;
    double _height = size.height;

    return Scaffold(
      appBar: TextCenterAppBar(
        title: widget.isEditPortfolio ? "자산 포트폴리오 수정" : "자산 포트폴리오 생성",
        appBar: AppBar(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _stockControllerList.add(TextEditingController());
            _ratioControllerList.add(TextEditingController());
            _count += 1;
          });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Stack(
        children: [
          Container(
            width: _width,
            height: _height,
            margin: EdgeInsets.fromLTRB(_width * 0.1, 10, _width * 0.1, 0),
            child: Column(children: [
              Form(
                  key: _stockFormKey,
                  child: Container(
                    width: _width,
                    height: _height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StockInputForm(
                            labelText: "제목",
                            controller: _titleController,
                            inputType: "title"),
                        StockInputForm(
                          labelText: "작성자",
                          controller: _writerController,
                          inputType: "writer",
                          readOnly: true,
                        ),
                        StockInputForm(
                            labelText: "초기비용(만)",
                            controller: _initialPriceController,
                            inputType: "price"),
                        const SizedBox(height: 20),
                        const Text(
                          "자산 비율 입력",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: _height * 0.3,
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          child: ListView.builder(
                            itemCount: _count,
                            itemBuilder: (context, index) {
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        "자산${index + 1}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 5,
                                              child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  child: StockInputForm(
                                                      controller:
                                                          _stockControllerList[
                                                              index],
                                                      inputType: "stock"))),
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                              child: StockInputForm(
                                                  controller:
                                                      _ratioControllerList[
                                                          index],
                                                  inputType: "percent")),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                                height: 60,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _stockControllerList
                                                          .removeAt(index);
                                                      _ratioControllerList
                                                          .removeAt(index);
                                                      --_count;
                                                    });
                                                  },
                                                  child: const Icon(
                                                      FontAwesomeIcons.xmark,
                                                      size: 16),
                                                )))
                                      ])),
                                ]);
                            },
                          ),
                        ),
                        GestureDetector(
                            onTap: () async {
                              if (_stockFormKey.currentState!.validate()) {
                                int sum = 0;
                                _ratioControllerList.forEach((ratio) {
                                  sum += int.parse(ratio.text);
                                });

                                if (sum != 100) {
                                  showDialog(
                                      context: context,
                                      builder: ((context) {
                                        return const ConfirmDialog(
                                            title: "경고",
                                            content: "자산 비율 총합이 100%이어야 합니다.",
                                            func: null);
                                      }));
                                  return;
                                }

                                List<String> regStockList = List.filled(10, '');
                                List<int> regRatioList = List.filled(10, 0);

                                for (int i = 0;
                                    i < _stockControllerList.length;
                                    i++) {
                                  regStockList[i] =
                                      _stockControllerList[i].text;
                                  regRatioList[i] =
                                      int.parse(_ratioControllerList[i].text);
                                }

                                var params = {
                                  "initialPrice": _initialPriceController.text,
                                  "userId": userId,
                                  "title": _titleController.text,
                                  "stock": regStockList.toString(),
                                  "ratio": regRatioList.toString(),
                                  "writer": _writerController.text
                                };

                                if (widget.isEditPortfolio) {
                                  params = {
                                    "initialPrice":
                                        _initialPriceController.text,
                                    "title": _titleController.text,
                                    "stock": regStockList.toString(),
                                    "ratio": regRatioList.toString(),
                                    "portIndex":
                                        widget.info['port_index'].toString()
                                  };
                                }

                                var res = widget.isEditPortfolio
                                    ? await editPortfolio(params)
                                    : await createPortfolio(params);

                                var data = json.decode(res);

                                if (data['success']) {
                                  int count = 1;
                                  Navigator.pop(context, true);
                                }
                              }
                            },
                            child: Container(
                                width: _width,
                                height: 50,
                                decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Center(
                                  child: Text(
                                    widget.isEditPortfolio ? "수정" : "생성",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                )))
                      ],
                    ),
                  ))
            ]),
          )
        ],
      ))),
    );
  }
}
