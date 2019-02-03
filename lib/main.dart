import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:image/image.dart';

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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  static const String _BaseImageUrl = 'https://stuffonharold.azurewebsites.net/api/image/random';
  String _imageUrl = _BaseImageUrl;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      setImageUrl();
      _imageUrl = '$_imageUrl&$_counter';
    });
  }

  void setImageUrl(){
    int width = MediaQuery.of(context).size.width.toInt();
    int height = MediaQuery.of(context).size.height.toInt();
    _imageUrl = '$_BaseImageUrl?width=$width&height=$height';
  }

  Future<http.Response> getImageHttpResponse() async{
    return await http.get(_imageUrl);
  }

  Future<Image> getFileImage() async{
    final response = await getImageHttpResponse();
    Image image = Image.memory(response.bodyBytes);
    return image;
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
              _imageUrl,
            ),
            Text(
              _imageUrl,
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


}

class HaroldWidget extends StatelessWidget {
  //So i can do like i do with the js and just keep two harold images around and get rid of one when done
  //find someway to only disappear the current harold when the new one is ready
  final String haroldUrl;

  HaroldWidget(this.haroldUrl);

  Widget build(BuildContext context){
    return Image.network(haroldUrl);
  }

}
