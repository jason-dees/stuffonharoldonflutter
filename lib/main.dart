import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stuff On Harold',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Stuff On Harold Randomizer'),
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
  int _counter = 0;
  static const String _BaseImageUrl = 'https://stuffonharold.azurewebsites.net/api/image/random';
  String _imageUrl = _BaseImageUrl;
  Uint8List _imageBytes = new Uint8List(0);

  Future<void> _incrementCounter() async {
    _imageUrl = setImageUrl(_counter++);
    Uint8List imageBytes = await getImageBytes(_imageUrl);
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _imageBytes = imageBytes;
    });
  }

  String setImageUrl(int counter){
    int width = MediaQuery.of(context).size.width.toInt();
    int height = MediaQuery.of(context).size.height.toInt();
    return '$_BaseImageUrl?width=$width&height=$height&$counter';
  }

  Future<http.Response> getImageHttpResponse(String imageUrl) async{
    return await http.get(imageUrl);
  }

  Future<Uint8List> getImageBytes(String imageUrl) async{
    final response = await getImageHttpResponse(imageUrl);
    return response.bodyBytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            HaroldWidget(
                _imageBytes,
                _incrementCounter
            ),
          ],
        ),
      ),
    );
  }
}

class HaroldWidget extends StatelessWidget {
  final Uint8List haroldImageBytes;
  final GestureTapCallback onTap;

  HaroldWidget(this.haroldImageBytes, this.onTap);

  Widget build(BuildContext context){
    Image haroldImage;
    if(haroldImageBytes.length == 0){//To account for initial load
      haroldImage = Image.asset('assets/iguazu.jpg');
    }
    else {
      haroldImage = Image.memory(haroldImageBytes);
    }
    return GestureDetector(
      onTap: (){
        onTap();
        },
      child: haroldImage
    );
  }

}
