import 'dart:core';

import 'package:feetback/screens/jumpHistory/widgets/jump_graph.dart';
import 'package:flutter/material.dart';

import 'package:feetback/models/jump.dart';
import 'package:feetback/widgets/feetback_app_bar.dart';
import 'package:feetback/screens/jumpHistory/widgets/feetback_list.dart';
import 'package:feetback/screens/jumpHistory/enums/sort_state.dart';
import 'package:feetback/screens/jumpHistory/widgets/jump_history_popup.dart';
import 'package:feetback/services/database_service.dart';



class JumpHistoryPage extends StatefulWidget {
  @override
  _JumpHistoryPageState createState() => _JumpHistoryPageState();
}

class _JumpHistoryPageState extends State<JumpHistoryPage> {
  List<Jump> jumps;
  final DatabaseService databaseService = new DatabaseService();
  SortState _selection = SortState.date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FeetbackAppBar(
        title: Text("Jump history"),
        height: 92,
        contentAlignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16, right: 16),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          JumpHistoryPopup(
            onSelected: (SortState selected) => {
              this.setState(() {
                _selection = selected;
              })
            }
          )
        ],
      ),

      body: FutureBuilder<List<Jump>>(
        future: databaseService.getAllJumps(),
        builder: (BuildContext context, AsyncSnapshot<List<Jump>> snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _graph(snapshot.data),
                Expanded(
                  child: FeetbackList(
                    currentSortState: _selection,
                    jumpItems: snapshot.data, 
                    onFavorite: (Jump jump) {
                      databaseService.toggleFavorite(jump.jid);
                      setState(() => jump.favorite = !jump.favorite);
                    }
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("Error while getting your data.");
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget _graph(List<Jump> jumps) {
    return JumpGraph(jumpItems: jumps,);
    //return Image.asset('assets/chart.png');
  }
}  