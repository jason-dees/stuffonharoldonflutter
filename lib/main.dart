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
  String _imageUrl = '';
  Uint8List _imageBytes = new Uint8List(0);

  Future<void> _nextImage() async {
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

  String setImageUrl(int counter) {
    int width = MediaQuery.of(context).size.width.toInt();
    int height = MediaQuery.of(context).size.height.toInt();
    return HaroldUrlGenerator.GenerateUrl(width, height);
  }

  Future<http.Response> getImageHttpResponse(String imageUrl) async {
    return await http.get(imageUrl);
  }

  Future<Uint8List> getImageBytes(String imageUrl) async {
    final response = await getImageHttpResponse(imageUrl);
    return response.bodyBytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.grey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            HaroldWidget(_imageBytes, _nextImage),//Flashes on next image and it's ugh
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

  Widget build(BuildContext context) {
    Image haroldImage;
    if (haroldImageBytes.length == 0) {
      int width = MediaQuery.of(context).size.width.toInt();
      int height = MediaQuery.of(context).size.height.toInt();
      haroldImage = Image.network(HaroldUrlGenerator.GenerateUrl(width, height));
    } else {
      haroldImage = Image.memory(haroldImageBytes);
    }
    Stack uiStack = new Stack(
        children: <Widget>[
          haroldImage,
          new Positioned(left: 0,
            height: MediaQuery.of(context).size.height,
            width:100,
            child: GestureDetector(
                onTap: onTap,
                child: Container(
                  //color: Colors.indigo,
                  child: Text(''),
                )
            )
          ),
          new Positioned(right: 0,
            height: MediaQuery.of(context).size.height,
            width:100,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                //color: Colors.orange,
                child: Text(''),
              )
            )
          )
        ]
    );
    return Draggable(
      child: uiStack,
      feedback: uiStack,
      childWhenDragging: Container(),
        maxSimultaneousDrags: 1
    );
  }
}


class HaroldUrlGenerator {
  static const String _BaseImageUrl =
      'https://stuffonharold.azurewebsites.net/api/image/random';
  static int counter = 0;

  static String GenerateUrl(int width, int height){
    return '$_BaseImageUrl?width=$width&height=$height&$counter++';
  }
}