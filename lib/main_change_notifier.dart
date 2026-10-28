import 'package:flutter/material.dart';

import 'datos/memoria_consumo_repository.dart';
import 'variantes/a_change_notifier.dart';

// Arranque de la variante A: aquí se elige la fuente de datos.
void main() {
  runApp(AppChangeNotifier(repositorio: MemoriaConsumoRepository()));
}
