import 'package:flutter/material.dart';
import 'package:recetas_app/edamam.dart';

class PageStateles extends StatelessWidget {
  final ValueNotifier<Recipe> receta;
  const PageStateles(this.receta, {required Key key}) : super(key: key);

  String getIngredientes() {
    String resultado = "";

    receta.value.ingredients?.forEach((element) {
      resultado = "$resultado$element\n";
    });
    return resultado;
  }

  String getHealthLabels() {
    String resultado = "";
    if (receta.value.healthLabels != null) {
      receta.value.healthLabels?.forEach((element) {
        resultado = (resultado.isEmpty ? resultado : "$resultado • ") + element;
      });
    }
    return resultado;
  }

  String getDietLabels() {
    String resultado = "";

    receta.value.dietLabels?.forEach((element) {
      resultado = (resultado.isEmpty ? resultado : "$resultado • ") + element;
    });
    return resultado;
  }

  String getPropiedades() {
    String resultado = "";
    List<String> propiedades1 = ["Fat", "Energy", "Carbs"];
    receta.value.totalNutrients?.forEach((element) {
      if (propiedades1.contains(element.label)) {
        resultado =
            "${resultado.isEmpty ? resultado : "$resultado\n"}${element.label} : ${element.value.toStringAsFixed(2)} g.";
      }
    });
    return resultado;
  }

  String getCalories() {
    String resultado = "0";
    resultado = receta.value.calories?.toStringAsFixed(2) ?? "";
    return "$resultado kcal";
  }

  String getNutrients() {
    String resultado = "";

    List<String> propiedades = ["Sugars", "Protein", "Cholesterol", "Fiber"];

    receta.value.totalNutrients?.forEach((element) {
      if (propiedades.contains(element.label)) {
        resultado =
            "${resultado.isEmpty ? resultado : "$resultado\n"}${element.label} : ${element.value.toStringAsFixed(2)} mg.";
      }
    });
    return "$resultado\n";
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    //print(key);
    return Scaffold(
      key: ObjectKey(receta.value.label),
      appBar: AppBar(
        title: Text(receta.value.label ?? ""),
      ),
      body: (receta.value.label != null)
          ? Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              margin: const EdgeInsets.all(15),
              elevation: 10,
              child: AnimatedBuilder(
                  // [AnimatedBuilder] accepts any [Listenable] subtype.
                  animation: receta,
                  builder: (BuildContext context, Widget? child) {
                    return SingleChildScrollView(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      // EL widget hijo que será recortado segun la propiedad anterior
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 150,
                            width: width,
                            child: // Usamos el widget Image para mostrar una imagen
                                FadeInImage(
                              // Como queremos traer una imagen desde un url usamos NetworkImage
                              image: NetworkImage(receta.value.image ?? ""),
                              placeholder:
                                  const AssetImage('images/loading.gif'),

                              // En esta propiedad colocamos mediante el objeto BoxFit
                              // la forma de acoplar la imagen en su contenedor
                              fit: BoxFit.fitWidth,

                              // En esta propiedad colocamos el alto de nuestra imagen
                            ),
                          ),

                          // Usamos Container para el contenedor de la descripción
                          Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(children: [
                                    const SizedBox(width: 50),
                                    Flexible(
                                      child: Text(
                                          "${receta.value.servings?.toStringAsFixed(0) ?? ""} servings",
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(width: 50)
                                  ]),
                                  Row(children: [
                                    const SizedBox(width: 50),
                                    Flexible(
                                      child: Text(getCalories(),
                                          // ignore: prefer_const_constructors
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(width: 50)
                                  ]),
                                  Row(children: [
                                    const SizedBox(width: 50),
                                    Flexible(
                                      child: Text(
                                          "\n\n Ingredientes : \n${getIngredientes()}",
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 15)),
                                    ),
                                    const SizedBox(width: 50)
                                  ]),
                                  Row(children: [
                                    const SizedBox(width: 50),
                                    Flexible(
                                      child: Text(
                                          "DietLabels : \n${getDietLabels()}",
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 15,
                                              color: Colors.blueGrey)),
                                    ),
                                    const SizedBox(width: 50)
                                  ]),
                                  Row(children: <Widget>[
                                    const SizedBox(width: 50),
                                    Flexible(
                                      child: Text("\n${getPropiedades()}",
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 15,
                                              color: Colors.deepPurpleAccent)),
                                    ),
                                    const SizedBox(width: 50)
                                  ]),
                                  Row(children: <Widget>[
                                    const SizedBox(width: 50),
                                    Flexible(
                                      child: Text("\n${getNutrients()}",
                                          style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 15,
                                              color: Colors.lightGreen)),
                                    ),
                                    const SizedBox(width: 50)
                                  ]),
                                ],
                              )),
                        ],
                      ),
                    ));
                  }))
          : const Card(),
    );
  }
}
