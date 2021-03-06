import 'package:flutter/material.dart';
import 'package:the_good_plate/modelos/modelo_pedidos.dart';
import 'package:the_good_plate/rutas/mapa.dart';
import 'package:the_good_plate/auxiliar/diagonal_clipper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:the_good_plate/rutas/perfil.dart';
import 'package:the_good_plate/modelos/modelo_usuarios.dart';
import 'package:the_good_plate/auxiliar/backPedidos.dart';


class GuillotineMenu extends StatefulWidget {
  ModeloUsuario user;
  List<ModeloPedido> _listaPedido = <ModeloPedido>[];
  GuillotineMenu({Key key, @required this.user}) : super(key: key);

  @override
  _GuillotineMenuState createState() => _GuillotineMenuState();
}

double _imageHeight = 256.0;

class _GuillotineMenuState extends State<GuillotineMenu>
    with SingleTickerProviderStateMixin {
  AnimationController animationControllerMenu;
  Animation<double> animationMenu;
  Animation<double> animationTitleFadeInOut;
  Animation<double> animationTitleFadeIn;
  _GuillotineAnimationStatus menuAnimationStatus;
  TextEditingController _controller = TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  bool activo = true;

  double pi = 3.14;

  final List<Map> _menus = <Map>[
    {
      "icon": Icons.add_shopping_cart,
      "title": "Pedidos",
      "color": Colors.white,
    },
    {
      "icon": Icons.favorite,
      "title": "Favoritos",
      "color": Colors.redAccent,
    },
    {
      "icon": Icons.map,
      "title": "Mapa",
      "color": Colors.cyan,
    },
    {
      "icon": Icons.settings,
      "title": "Perfil",
      "color": Colors.white,
    },
    {
      "icon": Icons.account_circle,
      "title": "Cerrar Sesión",
      "color": Colors.white,
    },
    {
      "icon": Icons.mode_comment,
      "title": "Sugerencias",
      "color": Colors.white,
    }
  ];

  List<ModeloPedido> _listaPedido;

  List<ModeloPedido> get listaPedido => _listaPedido;

  set listaPedido(List<ModeloPedido> listaPedido) {
    _listaPedido = listaPedido;
  }

  @override
  void initState() {
    super.initState();
    menuAnimationStatus = _GuillotineAnimationStatus.closed;

//Inicialización del controlador de la animacion
    animationControllerMenu = new AnimationController(
        duration: const Duration(
          milliseconds: 1000,
        ),
        vsync: this)
      ..addListener(() {});

    //Inicialización de la animación de la apariencia del menu
    animationMenu =
        new Tween(begin: -pi / 2.0, end: 0.0).animate(new CurvedAnimation(
      parent: animationControllerMenu,
      curve: Curves.fastLinearToSlowEaseIn,
      reverseCurve: Curves.fastOutSlowIn,
    ))
          ..addListener(() {
            setState(() {
              //*force refresh
            });
          })
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              menuAnimationStatus = _GuillotineAnimationStatus.open;
            } else if (status == AnimationStatus.dismissed) {
              menuAnimationStatus = _GuillotineAnimationStatus.closed;
            } else {
              menuAnimationStatus = _GuillotineAnimationStatus.animating;
            }
          });
    //*Inicializar la animacion in/out del titulo
    animationTitleFadeInOut =
        new Tween(begin: 1.0, end: 0.0).animate(new CurvedAnimation(
      parent: animationControllerMenu,
      curve: new Interval(
        0.0,
        0.5,
        curve: Curves.ease,
      ),
    ));
    animationTitleFadeIn =
        new Tween(begin: 0.0, end: 1.0).animate(new CurvedAnimation(
      parent: animationControllerMenu,
      curve: new Interval(
        0.0,
        0.5,
        curve: Curves.easeIn,
      ),
    ));
  }

  @override
  void dispose() {
    animationControllerMenu.dispose();
    super.dispose();
  }

//*Empezar la animacion dependiendo del estado de menu
  void _playAnimation() {
    try {
      if (menuAnimationStatus == _GuillotineAnimationStatus.animating) {
        //*Durante la animaciion, no hacer nada
      } else if (menuAnimationStatus == _GuillotineAnimationStatus.closed) {
        animationControllerMenu.forward().orCancel;
        activo = false;
      } else {
        animationControllerMenu.reverse().orCancel;
        activo = true;
      }
    } on TickerCanceled {
      //*La animacion es canccelada
    }
  }

  void switchUser(String opc) {
    if (opc == "Pedidos") {
      Navigator.push(context, buildMaterialPagePedido());
    } else if (opc == "Favoritos") {
      Fluttertoast.showToast(msg: "No disponible ");
    } else if (opc == "Mapa") {
      Navigator.push(context, buildMaterialPageMaps());
    } else if (opc == "Perfil") {
      Navigator.push(context, buildMaterialPagePerfil());
    } else if (opc == "Cerrar Sesión") {
      canPop(context);
    } else if (opc == "Sugerencias") {
      Fluttertoast.showToast(msg: "No disponible ");
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    double angle = animationMenu.value;

    return new Transform.rotate(
        angle: angle,
        origin: new Offset(40.0, 56.0),
        alignment: Alignment.topLeft,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: screenWidth,
            height: screenHeight,
            color: Colors.grey[800],
            child: new Stack(
              children: <Widget>[
                //*Contenido menu
                new Padding(
                  padding: EdgeInsets.all(8.0),
                  child: new Opacity(
                    opacity: animationTitleFadeIn.value,
                    child: new Scaffold(
                      body: new Stack(
                        children: <Widget>[
                          FittedBox(child: _buildImage(context)),
                          FittedBox(
                            child: new Padding(
                              padding: const EdgeInsets.only(
                                  left: 64.0, top: 256.0 / 2.5),
                              child: new Row(
                                children: <Widget>[
                                  new CircleAvatar(
                                    minRadius: 28.0,
                                    maxRadius: 28.0,
                                    backgroundImage:
                                        NetworkImage(widget.user.avatar),
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          (widget.user.usuario).toString(),
                                          style: new TextStyle(
                                              fontSize: 26.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //*Titulo menu
                new Positioned.fill(
                  top: 70.0,
                  left: 63.0,
                  child: new Transform.rotate(
                      alignment: Alignment.topLeft,
                      origin: Offset.zero,
                      angle: pi / 2.0,
                      child: new Center(
                        child: new Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: new Opacity(
                            opacity: animationTitleFadeInOut.value,
                            child: TextField(
                                enabled: activo,
                                controller: _controller,
                                style: TextStyle(
                                    fontFamily: 'Montserrat', fontSize: 18.0),
                                decoration: InputDecoration(
                                    labelText: "Buscar...",
                                    hintText: "Buscar...",
                                    prefixIcon: Icon(Icons.search),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0))))),
                          ),
                        ),
                      )),
                ),

                //*Icono Hamburguesa
                new Positioned(
                  top: 20.0,
                  left: 10.0,
                  child: new IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: _playAnimation,
                  ),
                ),

                new Padding(
                  padding: EdgeInsets.only(top: _imageHeight),
                  child: new Opacity(
                    opacity: animationTitleFadeIn.value,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _menus.map((menuItem) {
                        return new ListTile(
                          leading: new Icon(
                            menuItem["icon"],
                            color: menuItem["color"],
                          ),
                          title: RaisedButton(
                            color: Color(0xFF333333),
                            splashColor: Color.fromRGBO(100, 230, 235, 100),
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              switchUser(menuItem["title"]);
                              _playAnimation();
                            },
                            child: new Text(menuItem["title"], style: style),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  MaterialPageRoute buildMaterialPagePedido() {
    return MaterialPageRoute(
        builder: ((BuildContext context) => TabsPedidos(widget._listaPedido,user: widget.user,)));
  }

  MaterialPageRoute buildMaterialPageMaps() {
    return MaterialPageRoute(
        builder: ((BuildContext context) => MapsActivity(user: widget.user)));
  }

  MaterialPageRoute buildMaterialPagePerfil() {
    return MaterialPageRoute(
        builder: ((BuildContext context) => PerfilActivity(user: widget.user)));
  }
}

/*MaterialPageRoute buildMaterialPageLogin() {
  return MaterialPageRoute(
      builder: ((BuildContext context) => LoginActivity(user: widget.user)));
}*/

Widget _buildImage(context) {
  MediaQueryData mediaQueryData = MediaQuery.of(context);
  return new ClipPath(
    clipper: new DiagonalClipper(),
    child: new Image.network(
      "https://i.imgur.com/hbGXLre.jpg",
      fit: BoxFit.fitHeight,
      height: _imageHeight,
      width: mediaQueryData.size.width,
      colorBlendMode: BlendMode.srcOver,
      color: new Color.fromARGB(120, 20, 10, 40),
    ),
  );
}

canPop(BuildContext context) {
  while (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}

enum _GuillotineAnimationStatus { closed, open, animating }
