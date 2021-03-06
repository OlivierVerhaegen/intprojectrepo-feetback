import 'package:flutter/material.dart';

import 'package:feetback/models/jump.dart';

import 'package:feetback/widgets/feetback_app_bar.dart';

import 'package:feetback/services/database_service.dart';
import 'package:feetback/services/service_locator.dart';
import 'package:feetback/services/bluetooth_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseService _dbs = locator<DatabaseService>();

  final BluetoothService _bluetoothService = locator<BluetoothService>();
  @override
  void initState() {
    super.initState();

    if (!_bluetoothService.isConnected) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => Navigator.pushNamed(context, "/notconnected"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: FeetbackAppBar(
          title: const Text("Home"),
          height: 92,
          contentAlignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 16, right: 16),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                      child: Image(
                          image:
                              AssetImage("lib/images/jump-illustration.png"))),
                  Row(
                    children: <Widget>[
                      Image(
                          image: AssetImage(
                              "lib/images/Icon-material-history.png")),
                      SizedBox(width: 16),
                      FutureBuilder<Jump>(
                        future: _dbs.getHighestJump(),
                        builder: (BuildContext context,
                            AsyncSnapshot<Jump> snapshot) {
                          String highestJump;

                          if (snapshot.hasData) {
                            highestJump = snapshot.data.height.toString() + " cm";
                          } else {
                            highestJump = "--";
                          }

                          return Text(highestJump,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(fontWeight: FontWeight.bold));
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Text('Instructions',
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Text('1. Stand on the mat, align your feet to the pads',
                      style: Theme.of(context).textTheme.subtitle1),
                  SizedBox(height: 32),
                  Text(
                      '2. When you press JUMP we will start counting down form 3, jump on GO.',
                      style: Theme.of(context).textTheme.subtitle1),
                  SizedBox(height: 32),
                  Text('3. Try to land with both feet on the pads.',
                      style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: _bluetoothService.isConnected ? jumpButton() : connectButton(),
      ),
    );
  }

  FloatingActionButton jumpButton() {
    return FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, "/standonmat");
              
        },
        label: Text("Jump"),
        backgroundColor: Colors.red);
  }

  FloatingActionButton connectButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.pushNamed(context, "/connect");
      },
      label: const Text('Connect to a jump mat'),
      backgroundColor: Theme.of(context).primaryColor,
    
    );
  }
}
