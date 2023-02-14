import 'package:flutter/material.dart';
import 'package:stock_app/api/twelve_data_api.dart';

class StockInputSearchForm extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final String inputType;
  final bool readOnly;
  final bool isAssetInput;
  final int index;

  const StockInputSearchForm(
      {super.key,
      this.labelText = "",
      required this.controller,
      required this.inputType,
      this.readOnly = false,
      this.isAssetInput = false,
      this.index = 0});

  @override
  State<StockInputSearchForm> createState() => _StockInputSearchFormState();
}

class _StockInputSearchFormState extends State<StockInputSearchForm> {
  List<List<String>> searchList = [];
  List<String> selectStock = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // double _width = size.width;
    double _height = size.height;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Stack(
        clipBehavior: Clip.none,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            readOnly: widget.readOnly,
            controller: widget.controller,
            decoration: const InputDecoration(
                isDense: true,
                // labelText: widget.labelText,
                contentPadding: const EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(148, 163, 184, 1)))),
            validator: (text) {
                return (text!.trim().isEmpty)
                    ? '주식 및 ETF를 입력하세요.'
                    : null;
            },
            onChanged: ((keyWord) async {
              selectStock = [];

              print(keyWord);

              if (searchList.isNotEmpty) {
                searchList.clear();
              }

              List dataList =
                  await searchAmericaStockList(keyWord);

              setState(() {
                dataList.forEach((stock) => searchList.add(
                    [stock['symbol'], stock['instrument_name']]));
              });
              // print("change searchList : ${searchList.toList()}");
            }),
          ),
          if (searchList.isNotEmpty &&
            widget.inputType == "stock" &&
            selectStock.isEmpty)
            Positioned(
              child: Container(
                height: 80,
                margin: const EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(148, 163, 184, 1)),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.white),
                    child: ListView.builder(
                      itemCount: searchList.length,
                      itemBuilder: (context, index) {
                        List<String> searchStock = searchList[index];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectStock = searchStock;
                              widget.controller.text = selectStock[0];
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            height: 25,
                            child: Text(
                              "${searchStock[0]}(${searchStock[1]})",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        );
                      },
                ),
            ))
        ])
      );
  }
}
