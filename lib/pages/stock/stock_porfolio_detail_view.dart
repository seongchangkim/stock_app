import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stock_app/api/stock_portfolio_api.dart';
import 'package:stock_app/appbar/text_center_appbar.dart';
import 'package:stock_app/dialog/confirm_dialog.dart';
import 'package:stock_app/widgets/stocks/stock_indicator.dart';
import 'package:stock_app/widgets/stocks/stock_pie_chart_section.dart';

class StockPorfolioDetailView extends StatefulWidget {
  final int portIndex;

  const StockPorfolioDetailView({super.key, required this.portIndex});

  @override
  State<StockPorfolioDetailView> createState() =>
      _StockPorfolioDetailViewState();
}

class _StockPorfolioDetailViewState extends State<StockPorfolioDetailView> {
  int touchedIndex = -1;
  var info = {};
  var ratio = {};
  late Future myFuture;
  int portStockCount = 0;
  List<Map<String, int>> stockSymbolList = [];

  @override
  void initState() {
    myFuture = _getStockPortfolio();
    super.initState();
  }

  Future<bool> _getStockPortfolio() async {
    var res = await getPortfolioInfo(widget.portIndex);

    var result = json.decode(res);

    setState(() {
      info = result['portInfo'];
      ratio = result['portInfo']['Ratio'];

      // print("info : ${info['stock2']}");
      // print("ratio : ${ratio['stock2_ratio']}");
      for (int i = 1; i <= 10; i++) {
        if (info['stock$i'].isEmpty) return;

        stockSymbolList.add({'${info['stock$i']}': ratio['stock${i}_ratio']});

        ++portStockCount;
      }
    });

    log("stockSymbolList : $stockSymbolList");

    print("info : $info");
    print("portStockCount : $portStockCount");
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double _width = size.width;
    double _height = size.height;
    List pieChartColorList = [
      const Color.fromRGBO(2, 147, 238, 1),
      const Color.fromRGBO(248, 178, 80, 1),
      const Color.fromRGBO(132, 91, 239, 1),
      const Color.fromRGBO(116, 187, 251, 1),
      const Color.fromRGBO(0, 63, 92, 1),
      const Color.fromRGBO(188, 80, 144, 1),
      const Color.fromRGBO(134, 134, 134, 1),
      const Color.fromRGBO(255, 99, 97, 1),
      const Color.fromRGBO(255, 166, 0, 1),
      const Color.fromRGBO(31, 117, 254, 1),
    ];

    return Scaffold(
      appBar: TextCenterAppBar(
        title: info['title'] ?? "",
        appBar: AppBar(),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: FutureBuilder(
        future: myFuture,
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            List<PieChartSectionData> showingSections() {
              return List.generate(portStockCount, (i) {
                switch (i) {
                  case 0:
                    return StockPieChartSection(
                        0,
                        double.parse(
                            '${stockSymbolList[0]['${info['stock1']}']}'),
                        pieChartColorList[0]);
                  case 1:
                    return StockPieChartSection(
                        1,
                        double.parse(
                            '${stockSymbolList[1]['${info['stock2']}']}'),
                        pieChartColorList[1]);
                  case 2:
                    return StockPieChartSection(
                        2,
                        double.parse(
                            '${stockSymbolList[2]['${info['stock3']}']}'),
                        pieChartColorList[2]);
                  case 3:
                    return StockPieChartSection(
                        3,
                        double.parse(
                            '${stockSymbolList[3]['${info['stock4']}']}'),
                        pieChartColorList[3]);
                  case 4:
                    return StockPieChartSection(
                        4,
                        double.parse(
                            '${stockSymbolList[4]['${info['stock5']}']}'),
                        pieChartColorList[4]);
                  case 5:
                    return StockPieChartSection(
                        5,
                        double.parse(
                            '${stockSymbolList[5]['${info['stock6']}']}'),
                        pieChartColorList[5]);
                  case 6:
                    return StockPieChartSection(
                        6,
                        double.parse(
                            '${stockSymbolList[6]['${info['stock7']}']}'),
                        pieChartColorList[6]);
                  case 7:
                    return StockPieChartSection(
                        7,
                        double.parse(
                            '${stockSymbolList[7]['${info['stock8']}']}'),
                        pieChartColorList[7]);
                  case 8:
                    return StockPieChartSection(
                        8,
                        double.parse(
                            '${stockSymbolList[8]['${info['stock9']}']}'),
                        pieChartColorList[8]);
                  case 9:
                    return StockPieChartSection(
                        9,
                        double.parse(
                            '${stockSymbolList[9]['${info['stock10']}']}'),
                        pieChartColorList[9]);
                  default:
                    throw Error();
                }
              });
            }

            return Container(
              width: _width,
              height: _height * 1.2,
              margin: EdgeInsets.symmetric(horizontal: _width * 0.05),
              child: Stack(
                children: [
                  Positioned(
                      top: _height * 0.20,
                      left: _width * 0.3,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: const Text(
                              "총 비용 : ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            // margin: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              "${info["initial_price"]}만원",
                              style: TextStyle(fontSize: 28),
                            ),
                          )
                        ],
                      )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: _width * 0.18),
                          height: _height * 0.5,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              AspectRatio(
                                aspectRatio: 0.5,
                                child: PieChart(
                                  PieChartData(
                                    pieTouchData: PieTouchData(
                                      touchCallback: (FlTouchEvent event,
                                          pieTouchResponse) {
                                        setState(() {
                                          if (!event
                                                  .isInterestedForInteractions ||
                                              pieTouchResponse == null ||
                                              pieTouchResponse.touchedSection ==
                                                  null) {
                                            touchedIndex = -1;
                                            return;
                                          }
                                          touchedIndex = pieTouchResponse
                                              .touchedSection!
                                              .touchedSectionIndex;
                                        });
                                      },
                                    ),
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 90,
                                    sections: showingSections(),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Container(
                          height: _height * 0.06 * portStockCount,
                          child: ListView.builder(
                            itemCount: portStockCount,
                            itemBuilder: ((context, index) {
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: StockIndicator(
                                            color: pieChartColorList[index],
                                            text: info['stock${index + 1}'],
                                            isSquare: true,
                                          ),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                '${ratio['stock${index + 1}_ratio']}.00%',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                  ]);
                            }),
                          )),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () async {
                                bool result = await Navigator.pushNamed(
                                    context, '/stockPortfolioEditPage',
                                    arguments: {
                                      'symbolRatioList': stockSymbolList,
                                      'info': info,
                                    }) as bool;

                                if (result) {
                                  showDialog(
                                      context: context,
                                      builder: ((context) {
                                        return ConfirmDialog(
                                          title: "자산 포트폴리오 수정",
                                          content: "자산 포트폴리오를 수정되었습니다.",
                                          func: () => Navigator.pop(context),
                                        );
                                      }));

                                  setState(() {
                                    info.clear();
                                    ratio.clear();
                                    stockSymbolList.clear();
                                    portStockCount = 0;

                                    myFuture = _getStockPortfolio();
                                  });
                                }
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                margin: const EdgeInsets.only(right: 10.0),
                                child: const Center(
                                  child: Text(
                                    '수정',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () async {
                                var params = {
                                  "portIndex": info['port_index'].toString()
                                };
                                var res = await deletePortfolio(params);

                                var result = json.decode(res);

                                if (result["success"]) {
                                  int count = 0;
                                  Navigator.pop(context, true);
                                }
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                child: const Center(
                                  child: Text(
                                    '삭제',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            );
          }
        }),
      ))),
    );
  }
}
