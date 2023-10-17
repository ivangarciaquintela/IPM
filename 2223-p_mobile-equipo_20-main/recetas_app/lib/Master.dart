import 'package:flutter/material.dart';
import 'package:recetas_app/edamam.dart';
import 'package:recetas_app/PageStateless.dart';
import 'package:recetas_app/DoubleDetail.dart';

const int breakPoint = 600;

class Master extends StatelessWidget {
  final String title;
  Master({required this.title});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      bool chooseMasterAndDetail =
          (constraints.smallest.longestSide > breakPoint &&
              MediaQuery.of(context).orientation == Orientation.landscape);
      return chooseMasterAndDetail
          ? DoubleDetail(title: title)
          : MasterDetail(title: title);
    });
  }
}

class MasterDetail extends StatefulWidget {
  final String title;
  const MasterDetail({super.key, required this.title});

  @override
  // ignore: library_private_types_in_public_api
  _MasterDetailState createState() => _MasterDetailState();
}

class _MasterDetailState extends State<MasterDetail> {
  bool _searchBool = true;
  bool _isLoading = false;
  String busqueda = "";
  List<Recipe> _recipeList = [];

  void getList(String? s) {
    Future<RecipeBlock?> l = search_recipes(s as String);
    setState(() {
      _isLoading = true;
    });
    l.then((result) {
      try {
        _recipeList = result?.recipes ?? [];
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  Widget getListView() {
    return ListView.builder(
        itemCount: _recipeList.length,
        itemBuilder: (context, index) {
          String label = _recipeList[index].label ?? "";
          String image = _recipeList[index].image ?? "";

          return Card(
              child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(image),
              radius: 70,
            ),
            title: Text(label),
            onTap: () {
              if (_recipeList.isNotEmpty && index >= 0) {
                Recipe receta = _recipeList[index];
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PageStateles(
                          new ValueNotifier<Recipe>(receta),
                          key: ObjectKey(receta.label)),
                    ));
              }
            },
          ));
        });
  }

  Widget getNoneView() {
    return Center(
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: const SizedBox(
          width: 300,
          height: 100,
          child: Center(child: Text('No hay resultados para su búsqueda')),
        ),
      ),
    );
  }

  Widget _searchTextField() {
    //add
    return TextField(
      onChanged: (String s) {
        setState(() {
          busqueda = s;
        });
      },
      autofocus: true,
      cursorColor: Colors.green,
      textInputAction: TextInputAction.search,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
          appBar: AppBar(
              title: !_searchBool ? Text(widget.title) : _searchTextField(),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (!_searchBool) busqueda = "";
                        if (busqueda != "") getList(busqueda);
                        _searchBool = !_searchBool;
                      });
                    },
                    icon: const Icon(Icons.search))
              ]),
          body: (_recipeList.isEmpty) ? getNoneView() : getListView()),
      if (_isLoading)
        const Opacity(
          opacity: 0.8,
          child: ModalBarrier(dismissible: false, color: Colors.black),
        ),
      if (_isLoading)
        const Center(
          child: CircularProgressIndicator(),
        ),
    ]);
  }
}
