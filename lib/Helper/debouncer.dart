import 'dart:async';
// Creditos
// https://stackoverflow.com/a/52922130/7834829


//es una clase generica, eso significa que va a recibir algun tipo de dato a la hora de crear la instancia
class Debouncer<T> {

  Debouncer({ 
    required this.duration, //cantidad de tiempo que se quiere esperar antes de emitir un valor
    this.onValue //el metodo que se va a disparar cuando ya se tenga un valor 
  });

  final Duration duration;//es una propiedad

  void Function(T value)? onValue;//funcion opcional

  T? _value;//valor de tipo T, lo que se mando al momento de realizar la instancia
  Timer? _timer;//funcion de control que viene de dart
  
  T get value => _value!;

  set value(T val) {//si se recibe un valor, se va a cancelar el timer
    _value = val;
    _timer?.cancel();
    _timer = Timer(duration, () => onValue!(_value!));//y si el timer cumple la duracion que yo especifique, se va a mandar a llamar la funcion del onValue
  }  
}