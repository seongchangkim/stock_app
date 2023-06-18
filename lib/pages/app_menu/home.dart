import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stock_app/api/stock_portfolio_api.dart';
import 'package:stock_app/appBar/menu_select_appbar.dart';
import 'package:stock_app/dialog/confirm_dialog.dart';
import 'package:stock_app/store/user_store.dart';
import 'package:skeletons/skeletons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin{
  final _controller = Get.put(UserStore());
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final ScrollController _scrollController = ScrollController();
  var dropdownValue = {};
  List portList = [];
  late Future stockFuture;
  int page = 1;
  var _user = {};
  late int totalPage;

  @override
  void initState() {
    stockFuture = _getUserStockPorforioList();
    _user = _controller.user;
    super.initState();
  }

  Future<bool> _getUserStockPorforioList() async {
    var data = await getPortfolioList(page);

    data.forEach((port) {
      portList.add(port);
    });

    return true;
  }

  Future<void> _onRefresh() async {
    portList.clear();
    page = 1;

    setState(() {
      stockFuture = _getUserStockPorforioList();
    });

    _refreshController.refreshCompleted();
  }

  Future<void> _onLoad() async {
    page += 1;

    await Future.delayed(const Duration(seconds: 1),
        () async => await _getUserStockPorforioList());

    setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double _width = size.width;
    double _height = size.height;

    return Scaffold(
        appBar: AppMenuAppBar(
            title: "MY 포트폴리오 목록",
            appBar: AppBar(),
            color: const Color.fromRGBO(233, 233, 233, 1)),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool? result =
                await Navigator.pushNamed(context, '/stockPortfolioCreatePage')
                    as bool?;

            if (result != null && result) {
              showDialog(
                  context: context,
                  builder: ((context) {
                    return ConfirmDialog(
                      title: "자산 포트폴리오 생성",
                      content: "자산 포트폴리오를 생성되었습니다.",
                      func: () => Navigator.pop(context),
                    );
                  }));
              _onRefresh();
            }
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
              width: _width,
              height: _height,
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(233, 233, 233, 1)),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Stack(children: [
                Container(
                    width: _width,
                    height: _height,
                    margin: EdgeInsets.only(top: 10, bottom: _height * 0.2),
                    child: FutureBuilder(
                        future: stockFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData == false) {
                            return const SizedBox();
                          } else {
                            if (portList.isEmpty) {
                              return Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                width: _width,
                                height: _height,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      child: Image.asset(
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.fill,
                                          'assets/icons-stocks-100.png'),
                                    ),
                                    Container(
                                      child: const Center(
                                          child: Text(
                                        "생성된 자산 포트폴리오가 없습니다.",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    )
                                  ],
                                ),
                              );
                            } else {
                              return SmartRefresher(
                                  enablePullUp: true,
                                  enablePullDown: true,
                                  controller: _refreshController,
                                  onLoading: _onLoad,
                                  onRefresh: _onRefresh,
                                  header: CustomHeader(builder:
                                      (BuildContext context,
                                          RefreshStatus? status) {
                                    Widget body;
                                    if (status == RefreshStatus.idle ||
                                        status == RefreshStatus.refreshing) {
                                      body = const CircularProgressIndicator();
                                    } else {
                                      body = const CircularProgressIndicator();
                                    }
                                    return Container(
                                      height: 55.0,
                                      child: Center(
                                        child: body,
                                      ),
                                    );
                                  }),
                                  footer: CustomFooter(builder:
                                      (BuildContext context,
                                          LoadStatus? status) {
                                    Widget body;
                                    if (status == LoadStatus.idle ||
                                        status == LoadStatus.loading) {
                                      body = const CircularProgressIndicator();
                                    } else if (status == LoadStatus.failed) {
                                      body = const Text("데이터 가져오는데 실패하였습니다");
                                    } else {
                                      body = const Text("더 이상 로딩할 데이터가 없습니다.");
                                    }
                                    return Container(
                                      height: 55.0,
                                      child: Center(
                                        child: body,
                                      ),
                                    );
                                  }),
                                  child: ListView.builder(
                                      itemCount: portList.length,
                                      itemBuilder: (context, index) {
                                        final port = portList[index];

                                        return GestureDetector(
                                            onTap: () async {
                                              bool result =
                                                  await Navigator.pushNamed(
                                                      context,
                                                      '/stockPortfolioDetailPage',
                                                      arguments: {
                                                    "portIndex":
                                                        port['port_index']
                                                  }) as bool;

                                              if (result) {
                                                showDialog(
                                                    context: context,
                                                    builder: ((context) {
                                                      return ConfirmDialog(
                                                        title: "자산 포트폴리오 삭제",
                                                        content:
                                                            "자산 포트폴리오를 삭제되었습니다.",
                                                        func: () =>
                                                            Navigator.pop(
                                                                context),
                                                      );
                                                    }));
                                                _onRefresh();
                                              }
                                            },
                                            child: Container(
                                                width: _width,
                                                height: _height * 0.1,
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0)),
                                                    color: Colors.white),
                                                child: Container(
                                                  margin: const EdgeInsets.all(
                                                      10.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: ClipOval(
                                                            child: _user["profile_image"] == null
                                                                ? Image.asset(
                                                                    width: 30,
                                                                    height: 30,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    'assets/default-user-profile.png')
                                                                : Image.network(
                                                                    _user["profile_image"],
                                                                    width: 30,
                                                                    height: 30,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    loadingBuilder: (BuildContext context,
                                                                        Widget
                                                                            child,
                                                                        ImageChunkEvent?
                                                                            loadingProgress) {
                                                                      
                                                                      if (loadingProgress ==
                                                                          null)
                                                                        return child;

                                                                      
                                                                      return const Center(
                                                                          child: SkeletonAvatar(
                                                                            style: SkeletonAvatarStyle(
                                                                                height: 30,
                                                                                width: 30,
                                                                                shape: BoxShape.circle),
                                                                          ));
                                                                    },
                                                                  )),
                                                      ),
                                                      Expanded(
                                                          flex: 10,
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 15.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '${port['title']}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        _height *
                                                                            0.01),
                                                                Text(
                                                                    '${port['writer']}',
                                                                    style: const TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            148,
                                                                            163,
                                                                            184,
                                                                            1)))
                                                              ],
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                )));
                                      }));
                            }
                          }
                        })),
              ])),
        )));
  }

  @override
  bool get wantKeepAlive => true;
}
