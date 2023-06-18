import 'package:flutter/material.dart';
import 'package:stock_app/api/twelve_data_api.dart';

class StockInputForm extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final String inputType;
  final bool readOnly;
  final bool isAssetInput; 

  const StockInputForm(
      {super.key,
      this.labelText = "",
      required this.controller,
      required this.inputType,
      this.readOnly = false,
      this.isAssetInput = false});

  @override
  State<StockInputForm> createState() => _StockInputFormState();
}

class _StockInputFormState extends State<StockInputForm> {
  List<List<String>> searchList = [];
  List<String> selectStock = [];

  @override
  Widget build(BuildContext context) {

    return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(widget.labelText.isNotEmpty)
                  Container(margin: const EdgeInsets.only(bottom: 10.0), child: Text(widget.labelText, style: const TextStyle(fontWeight: FontWeight.w600),),),
                
                TextFormField(
                  readOnly: widget.readOnly,
                  controller: widget.controller,
                  decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(148, 163, 184, 1)))),
                  validator: (text) {
                    return (text!.trim().isEmpty) ? '주식 및 ETF를 입력하세요.' : null;
                  },
                  onChanged: widget.inputType == "stock"
                      ? ((keyWord) async {
                          selectStock = [];

                          if (searchList.isNotEmpty) {
                            searchList.clear();
                          }

                          List dataList = await searchAmericaStockList(keyWord);

                          setState(() {
                            dataList.forEach(
                                (stock) => searchList.add([stock['symbol'], stock['instrument_name']]));
                          });
                          print("change searchList : ${searchList.toList()}");
                        })
                      : null,
                ),
              ],)
            
          ),

          if (searchList.isNotEmpty &&
              widget.inputType == "stock" &&
              selectStock.isEmpty)
              Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromRGBO(148,163,184,1)),
                    borderRadius: const BorderRadius.all(Radius.circular(10))
                  ),
                  child: ListView.builder(
                    itemCount: searchList.length,
                    itemBuilder: (context, index) {
                      // print("count : ${searchList.length}");
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
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              )
        ],
      );
  }
}
