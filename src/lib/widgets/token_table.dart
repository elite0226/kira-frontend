import 'dart:math';
import 'dart:ui';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:kira_auth/utils/export.dart';
import 'package:kira_auth/models/export.dart';
import 'package:kira_auth/widgets/export.dart';
import 'package:kira_auth/services/export.dart';

class TokenTable extends StatefulWidget {
  final List<Token> tokens;
  final String expandedName;
  final Function onTapRow;
  final Function onRefresh;
  final String address;
  final bool isLoggedIn;

  TokenTable({
    Key key,
    this.tokens,
    this.expandedName,
    this.onTapRow,
    this.onRefresh,
    this.address,
    this.isLoggedIn,
  }) : super();

  @override
  TokenTableState createState() => TokenTableState();
}

class TokenTableState extends State<TokenTable> {
  List<ExpandableController> controllers = List.empty();
  TokenService tokenService = TokenService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    controllers = List.filled(widget.tokens.length, null);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            child: ExpandableTheme(
                data: ExpandableThemeData(
                  iconColor: KiraColors.white,
                  useInkWell: true,
                ),
                child: Column(
                    children: <Widget>[
                      ...widget.tokens
                          .map((token) =>
                          ExpandableNotifier(
                            child: ScrollOnExpand(
                              scrollOnExpand: true,
                              scrollOnCollapse: false,
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                color: KiraColors.kBackgroundColor.withOpacity(0.2),
                                child: ExpandablePanel(
                                  theme: ExpandableThemeData(
                                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                                    tapHeaderToExpand: false,
                                    hasIcon: false,
                                  ),
                                  header: addRowHeader(token),
                                  collapsed: Container(),
                                  expanded: addRowBody(token),
                                ),
                              ),
                            ),
                          )
                      ).toList(),
                    ])
            )));
  }

  Widget addLoadingIndicator() {
    return Container(
        alignment: Alignment.center,
        child: Container(
          width: 20,
          height: 20,
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
          padding: EdgeInsets.all(0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ));
  }

  refreshExpandStatus({String newExpandName = ''}) {
    widget.onTapRow(newExpandName);
    this.setState(() {
      widget.tokens.asMap().forEach((index, token) {
        controllers[index].expanded = token.assetName == newExpandName;
      });
    });
  }

  Widget addRowHeader(Token token) {
    return Builder(
        builder: (context) {
          var controller = ExpandableController.of(context);
          controllers[widget.tokens.indexOf(token)] = controller;

          return InkWell(
              onTap: () {
                var newExpandName = token.assetName != widget.expandedName ? token.assetName : '';
                refreshExpandStatus(newExpandName: newExpandName);
              },
              child: Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(width: 50),
                    Expanded(
                        flex: ResponsiveWidget.isSmallScreen(context) ? 3 : 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.network('https://cors-anywhere.kira.network/' + token.graphicalSymbol,
                                placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
                                width: 32, height: 32),
                            SizedBox(width: 15),
                            Text(token.assetName,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: KiraColors.white.withOpacity(0.8), fontSize: 16),
                            )
                          ],
                        )),
                    Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(token.balance.toString() + " " + token.ticker,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: KiraColors.white.withOpacity(0.8), fontSize: 16),
                          ))),
                    ExpandableIcon(
                      theme: const ExpandableThemeData(
                        expandIcon: Icons.arrow_right,
                        collapseIcon: Icons.arrow_drop_down,
                        iconColor: Colors.white,
                        iconSize: 28,
                        iconRotationAngle: pi / 2,
                        iconPadding: EdgeInsets.only(right: 5),
                        hasIcon: false,
                      ),
                    ),
                  ],
                )),
              );
      }
    );
  }

  Widget addRowBody(Token token) {
    final fieldWidth = ResponsiveWidget.isSmallScreen(context) ? 100.0 : 150.0;

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Column(children: [
          Row(
            children: [
              Container(
                  width: fieldWidth,
                  child: Text("Token Name : ",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: KiraColors.white.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.bold))),
              SizedBox(width: 20),
              Flexible(
                  child: Text(token.assetName,
                      overflow: TextOverflow.fade,
                      style: TextStyle(color: KiraColors.white.withOpacity(0.8), fontSize: 14))),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                  width: fieldWidth,
                  child: Text("Ticker : ",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: KiraColors.white.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.bold))),
              SizedBox(width: 20),
              Flexible(
                  child: Text(token.ticker,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: KiraColors.white.withOpacity(0.8), fontSize: 14))),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                  width: fieldWidth,
                  child: Text("Balance : ",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: KiraColors.white.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.bold))),
              SizedBox(width: 20),
              Text(token.balance.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: KiraColors.white.withOpacity(0.8), fontSize: 14)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                  width: fieldWidth,
                  child: Text("Denomination : ",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: KiraColors.white.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.bold))),
              SizedBox(width: 20),
              Text(token.denomination,
                  overflow: TextOverflow.fade,
                  style: TextStyle(color: KiraColors.white.withOpacity(0.8), fontSize: 14)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                  width: fieldWidth,
                  child: Text("Decimals : ",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: KiraColors.white.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.bold))),
              SizedBox(width: 20),
              Text(token.decimals.toString(),
                  overflow: TextOverflow.fade,
                  style: TextStyle(color: KiraColors.white.withOpacity(0.8), fontSize: 14)),
            ],
          ),
          SizedBox(height: 20),
          widget.isLoggedIn ? Row(
            children: [
              CustomButton(
                key: Key(Strings.faucet),
                text: Strings.faucet,
                width: 90,
                height: 40,
                style: 1,
                fontSize: 15,
                onPressed: () async {
                  if (widget.address.length > 0) {
                    setState(() {
                      isLoading = true;
                    });
                    String result = await tokenService.faucet(widget.address, token.denomination);
                    setState(() {
                      isLoading = false;
                    });
                    showToast(result);
                    widget.onRefresh();
                  }
                },
              ),
              if (isLoading) addLoadingIndicator()
            ],
          ): Container(),
          SizedBox(height: 20),
        ]));
  }
}
