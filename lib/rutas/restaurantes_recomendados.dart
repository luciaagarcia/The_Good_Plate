import "package:flutter/material.dart";
import 'package:the_good_plate/rutas/lista_restaurantes.dart';

class RestaurantesRecomendados extends StatefulWidget {
  @override
  _RestaurantesRecomendadosState createState() =>
      new _RestaurantesRecomendadosState();
}

class _RestaurantesRecomendadosState extends State<RestaurantesRecomendados> {
  TextEditingController _controller = TextEditingController();
  final items = List<String>.generate(10000, (i) => "Item $i");
  final globalKey = new GlobalKey<ScaffoldState>();
  List<dynamic> _list;
  bool _isSearching;
  String _searchText = "";
  List searchresult = new List();
  @override
  void initState() {
    super.initState();
    _isSearching = false;
    values();
  }
   void values() {
    _list = List();
    _list.add("Indian rupee");
    _list.add("United States dollar");
    _list.add("Australian dollar");
    _list.add("Euro");
    _list.add("British pound");
    _list.add("Yemeni rial");
    _list.add("Japanese yen");
    _list.add("Hong Kong dollar");
  }

  Widget appBarTitle = new Text(
    "Search Example",
    style: new TextStyle(color: Colors.white),
  );
  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  RestaurantesRecomendados() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        appBar: buildAppBar(context),
        body: new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Flexible(
                  child: searchresult.length != 0 || _controller.text.isNotEmpty
                      ? new ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchresult.length,
                          itemBuilder: (BuildContext context, int index) {
                            String listData = searchresult[index];
                            return new ListTile(
                              title: new Text(listData.toString()),
                            );
                          },
                        )
                      : new ListView.builder(
                          shrinkWrap: true,
                          itemCount: _list.length,
                          itemBuilder: (BuildContext context, int index) {
                            String listData = _list[index];
                            return new ListTile(
                              title: new Text(listData.toString()),
                            );
                          },
                        ))
            ],
          ),
        ));
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
      new IconButton(
        icon: icon,
        onPressed: () {
          setState(() {
            if (this.icon.icon == Icons.search) {
              this.icon = new Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = new TextField(
                controller: _controller,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.white)),
                onChanged: searchOperation,
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          });
        },
      ),
    ]);
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Search Sample",
        style: new TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _controller.clear();
    });
  }

  void searchOperation(String searchText) {
    searchresult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < _list.length; i++) {
        String data = _list[i];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchresult.add(data);
        }
      }
    }
  TextEditingController editingController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 35, 10, 0),
                child: Ink(
                  decoration: ShapeDecoration(
                    color: Color.fromRGBO(100, 230, 235, 100),
                    shape: CircleBorder()
                  ),
                  child: IconButton(
                    iconSize: 35,
                    icon: new Icon(Icons.menu),
                    onPressed: () {},
                  ),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(65, 30, 10, 0),
              child: TextField(
                  controller: editingController,
                  decoration: InputDecoration(
                      labelText: "Buscar...",
                      hintText: "Buscar...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0))))),
            )
          ],
        ),
        Expanded(
            child: SingleChildScrollView(
                child: Center(
                    child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset('images/Restaurante.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset('images/Restaurante.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset('images/Restaurante.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset('images/Restaurante.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset('images/Restaurante.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset('images/Restaurante.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              //child: new ListaRestaurantes()
            ),
          ],
        ))))
      ],
    ));
  }
}
