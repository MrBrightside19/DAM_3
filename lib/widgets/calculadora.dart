import 'dart:developer';

class Calculadora {
  final List<dynamic> _registroDeNotas;
  final int min, cantNotas, nota, pond;
  final bool pondExist;

  Calculadora(this._registroDeNotas, this.min, this.cantNotas, this.pondExist,
      this.nota, this.pond);

  double func(sum) {
    var nfinal = sum.toDouble();
    for (var i = 0; i < _registroDeNotas.length; i++) {
      if (_registroDeNotas[i][0] != "") {
        nfinal = nfinal + double.parse(_registroDeNotas[i][0]);
      }
    }
    return nfinal;
  }

  List<dynamic> calculo() {
    double sum = 0;
    for (var i = 0; i < _registroDeNotas.length; i++) {
      if (pondExist) {
        if (pond > 0) {
          return [-1]; //"Debe ingresar todas las ponderaciones";
        } else if (_registroDeNotas[i][0] != "") {
          _registroDeNotas[i][0] = (int.parse(_registroDeNotas[i][0]) *
                  double.parse(_registroDeNotas[i][1]) /
                  100)
              .toStringAsFixed(0);
        }
      } else {
        var min2 = (min * cantNotas) - func(sum);
        if (nota > 0) {
          min2 = (min2 / nota);
          return [
            min2.toString()
          ]; //"Necesita $nota $min2 para pasar el ramo.";
        } else {
          min2 = (func(sum) / cantNotas);
          return [min2]; //"Nota final es: $min2";
        }
      }
    }
    if (nota == 0 && pondExist) {
      return [func(sum)]; //"Su promedio es: ${func(sum)}";
    } else if (nota > 0 && pondExist) {
      var numPond = 0;
      double difNotas = 0;
      for (var i = 0; i < _registroDeNotas.length; i++) {
        if (_registroDeNotas[i][0] != "") {
          difNotas = difNotas + double.parse(_registroDeNotas[i][0]);
        } else {
          sum = sum + int.parse(_registroDeNotas[i][1]) / 100;
          numPond++; //total_notas.count("")
        }
      }
      var prom = double.parse(((min - difNotas) / sum).toStringAsFixed(2));
      sum = (sum / numPond);
      // var nota = "";
      for (var i = 0; i < _registroDeNotas.length; i++) {
        if (_registroDeNotas[i][0] == "") {
          var dif = (double.parse(_registroDeNotas[i][1]) / 100) - sum;
          _registroDeNotas[i].add(
              ((prom * double.parse(dif.toStringAsFixed(3)) + prom).round())
                  .toString());
        }
      }
      List<String> notasNecesarias = [];
      for (var i = 0; i < _registroDeNotas.length; i++) {
        if (_registroDeNotas[i][0] == "") {
          notasNecesarias.add(_registroDeNotas[i][2]);
        }
      }
      return notasNecesarias; //"En orden, la(s) nota(s) minima(s) para pasar  el ramo es(son): $nota";
    }
    return [0];
  }
}
