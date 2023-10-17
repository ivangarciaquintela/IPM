// ignore_for_file: unnecessary_new

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:recetas_app/edamam.dart';
import 'package:recetas_app/PageStateless.dart';

class DoubleDetail extends StatefulWidget {
  final String title;
  const DoubleDetail({super.key, required this.title});

  @override
  // ignore: library_private_types_in_public_api
  _DoubleDetailState createState() => _DoubleDetailState();
}

class _DoubleDetailState extends State<DoubleDetail> {
  bool _searchBool = true;
  bool _isLoading = false;
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  String busqueda = "";
  List<Recipe> _recipeList = [];
  final ValueNotifier<Recipe> _receta = ValueNotifier<Recipe>(new Recipe());

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
              _counter.value++;
              if (_recipeList.isNotEmpty && index >= 0) {
                _receta.value = _recipeList[index];
              }
            },
          ));
        });
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
      cursorColor: Colors.white,
      textInputAction: TextInputAction.search,
    );
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
        body: Row(children: <Widget>[
          Flexible(
            flex: 13,
            child: Material(
                elevation: 4.0,
                child: (_recipeList.isEmpty) ? getNoneView() : getListView()),
          ),
          Flexible(
              flex: 27,
              child: AnimatedBuilder(
                  // [AnimatedBuilder] accepts any [Listenable] subtype.
                  animation: _counter,
                  builder: (BuildContext context, Widget? child) {
                    return PageStateles(_receta,
                        key: ObjectKey(_receta.value.label));
                  })),
        ]),
      ),
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
