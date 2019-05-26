import 'package:flutter_web/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'GochiHand',
      ),
      // home: MyHomePage(title: 'Shopping list'),
      home: ShoppingList(),
    );
  }
}

class Product {
  const Product({this.name});
  final String name;
}

typedef void CartChangedCallback(Product product, bool inCart);

class ShoppingListItem extends StatelessWidget {
  ShoppingListItem({Product product, this.inCart, this.onCartChanged})
      : product = product,
        super(key: ObjectKey(product));

  final Product product;
  final bool inCart;
  final CartChangedCallback onCartChanged;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different parts of the tree
    // can have different themes.  The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return inCart ? Colors.black54 : Theme.of(context).primaryColor;
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (!inCart) return null;

    return TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onCartChanged(product, !inCart);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(product.name[0]),
      ),
      title: Text(product.name, style: _getTextStyle(context)),
    );
  }
}

class ShoppingList extends StatefulWidget {
  ShoppingList({Key key}) : super(key: key);

  // The framework calls createState the first time a widget appears at a given
  // location in the tree. If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework re-uses the State object
  // instead of creating a new State object.

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  Set<Product> _shoppingCart = Set<Product>();
  List<Product> _products = List<Product>();

  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();

    super.dispose();
  }

  void _handleCartChanged(Product product, bool inCart) {
    setState(() {
      // When a user changes what's in the cart, you need to change
      //_shoppingCart inside a setState call to trigger a rebuild.
      // The framework then calls // build, below,
      // which updates the visual appearance of the app.

      if (inCart)
        _shoppingCart.add(product);
      else
        _shoppingCart.remove(product);
    });
  }

  void _addItem() {
    if (myController.text.isEmpty) {
      return;
    }
    setState(() {
      _products.add(Product(name: myController.text));
    });
    myController.value = myController.value.copyWith(
      text: '',
      selection: TextSelection(baseOffset: 0, extentOffset: 0),
      composing: TextRange.empty,
    );
    // FocusScope.of(context).requestFocus(new FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          margin: EdgeInsets.all(12.0),
          padding: EdgeInsets.all(12.0),
          child: Column(
            // Column is also layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (choose the "Toggle Debug Paint" action
            // from the Flutter Inspector in Android Studio, or the "Toggle Debug
            // Paint" command in Visual Studio Code) to see the wireframe for each
            // widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                '~ I need to buy ~',
              ),
              const SizedBox(height: 24.0),
              Row(children: <Widget>[
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Add item',
                    ),
                    controller: myController,
                  ),
                ),
                const SizedBox(width: 12),
                RaisedButton(
                  onPressed: _addItem,
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 20, color: Colors.white)
                  ),
                  color: Theme.of(context).accentColor,
                ),
                ],
              ),
              const SizedBox(height: 24.0),
              new Expanded(
                child: ListView(
                  children: _products.map((Product product) {
                    return ShoppingListItem(
                      product: product,
                      inCart: _shoppingCart.contains(product),
                      onCartChanged: _handleCartChanged,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ), //
    );
  }
}
