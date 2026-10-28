import 'package:flutter/material.dart';

import 'datos/memoria_consumo_repository.dart';
import 'variantes/b_provider.dart';

// Arranque de la variante B: aquí se elige la fuente de datos.
void main() {
  runApp(AppProvider(repositorio: MemoriaConsumoRepository()));
}
