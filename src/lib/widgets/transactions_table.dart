import 'dart:math';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:kira_auth/models/transaction.dart';
import 'package:kira_auth/utils/export.dart';

class TransactionsTable extends StatefulWidget {
  final List<Transaction> transactions;
  final String expandedHash;
  final Function onTapRow;
  final bool isDeposit;

  TransactionsTable({
    Key key,
    this.transactions,
    this.expandedHash,
    this.onTapRow,
    this.isDeposit,
  }) : super();

  @override
  _TransactionsTableState createState() => _TransactionsTableState();
}

class _TransactionsTableState extends State<TransactionsTable> {
  List<ExpandableController> controllers = List.empty();

  @override
  void initState() {
    super.initState();

    controllers = List.filled(widget.transactions.length, null);
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
                      ...widget.transactions
                          .map((transaction) =>
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
                                  header: addRowHeader(transaction),
                                  collapsed: Container(),
                                  expanded: addRowBody(transaction),
                                ),
                              ),
                            ),
                          )
                      ).toList(),
                    ])
            )));
  }

  refreshExpandStatus({String newExpandHash = ''}) {
    widget.onTapRow(newExpandHash);
    this.setState(() {
      widget.transactions.asMap().forEach((index, transaction) {
        controllers[index].expanded = transaction.hash == newExpandHash;
      });
    });
  }

  Widget addRowHeader(Transaction transaction) {
    return Builder(
        builder: (context) {
          var controller = ExpandableController.of(context);
          controllers[widget.transactions.indexOf(transaction)] = controller;

          return InkWell(
              onTap: () {
                var newExpandHash = transaction.hash != widget.expandedHash ? transaction.hash : '';
                refreshExpandStatus(newExpandHash: newExpandHash);
              },
              child: Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Align(
                            child: InkWell(
                              onTap: () {
                                copyText(transaction.hash);
                                showToast(Strings.txHashCopied);
                              },
                              child: Text(transaction.getReducedHash,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: KiraColors.white.withOpacity(0.8), fontSize: 16)
                              ),
                            )
                        )
                    ),
                    Expanded(
                        flex: 2,
                        child: Align(
                            child: InkWell(
                              onTap: () {
                                copyText(transaction.sender);
                                showToast(Strings.senderAddressCopied);
                              },
                              child: Text(
                                  widget.isDeposit ? transaction.getReducedSender : transaction.getReducedRecipient,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: KiraColors.white
                                      .withOpacity(0.8), fontSize: 16)
                              ),
                            )
                        )
                    ),
                    Expanded(
                        flex: 1,
                        child: Text(transaction.getAmount,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: KiraColors.white.withOpacity(0.8), fontSize: 16),
                        )
                    ),
                    Expanded(
                        flex: 1,
                        child: Text(transaction.getTimeString,
                          textAlign: TextAlign.center, style: TextStyle(color: KiraColors.white.withOpacity(0.8), fontSize: 16))
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: transaction.getStatusColor().withOpacity(
                                    0.5),
                                width: 2,
                              ),
                            ),
                            child: InkWell(
                              child: Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Icon(Icons.circle, size: 12.0,
                                    color: transaction.getStatusColor()),
                              ),
                            ))
                    ),
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
                ),
              )
          );
        }
    );
  }

  Widget addRowBody(Transaction transaction) {
    final fieldWidth = ResponsiveWidget.isSmallScreen(context) ? 100.0 : 150.0;

    return Container(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          Row(
            children: [
              Container(
                  width: fieldWidth,
                  child: Text(
                      "Memo",
                      textAlign: TextAlign.right,
                      style: TextStyle(color: KiraColors.white.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.bold)
                  )
              ),
              SizedBox(width: 20),
              Flexible(child: Text(
                  transaction.memo,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: KiraColors.white.withOpacity(0.8), fontSize: 14))
              ),
            ],
          ),
        ]));
  }
}
