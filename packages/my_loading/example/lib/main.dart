import 'package:flutter/material.dart';
import 'package:myloading/myloading.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Click float button to show loading for 2 second',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onClick,
        tooltip: 'show loading',
        child: Icon(Icons.add),
      ),
    );
  }

  Future onClick()async{
    showLoading(context);
    await Future.delayed(Duration(seconds: 2));
    updateLoading('Start dowload');
    await Future.delayed(Duration(seconds: 2));
    updateLoading('Dowload 1/2');
    await Future.delayed(Duration(seconds: 2));
    updateLoading('Dowload 2/2');
    await Future.delayed(Duration(seconds: 2));
    updateLoading('Finish');
    await Future.delayed(Duration(seconds: 2));
    hideLoading(context);
  }
}
