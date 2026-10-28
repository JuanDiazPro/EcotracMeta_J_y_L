import 'package:flutter/foundation.dart';

import '../datos/consumo_repository.dart';
import '../dominio/consumo.dart';
import '../dominio/meta.dart';

class ConsumosViewModel extends ChangeNotifier {
  ConsumosViewModel(this._repo); // recibe el contrato, nunca crea uno

  final ConsumoRepository _repo;

  // Estado compartido
  List<Consumo> _consumos = const [];
  String? _error;
  bool _guardando = false;
  double _meta = metaInicial;

  List<Consumo> get consumos => _consumos;
  String? get error => _error;
  bool get guardando => _guardando;
  double get meta => _meta;

  // Derivados: se calculan, no se guardan
  double get total => _consumos.fold(0.0, (suma, c) => suma + c.litros);
  double get avance => avanceDeMeta(total: total, meta: _meta);
  bool get metaSuperada => total > _meta;

  Future<void> cargar() async {
    _consumos = await _repo.todos();
    notifyListeners();
  }

  Future<bool> guardar(String laboratorio, String litrosTexto) async {
    final litros = double.tryParse(litrosTexto.trim().replaceAll(',', '.'));

    final mensaje = validarLitros(litros);
    if (mensaje != null) {
      _error = mensaje;
      notifyListeners();
      return false;
    }

    _guardando = true;
    _error = null;
    notifyListeners();

    await _repo.guardar(Consumo(laboratorio: laboratorio, litros: litros!));
    _consumos = await _repo.todos();

    _guardando = false;
    notifyListeners();
    return true;
  }

  void subirMeta() {
    _meta = ajustarMeta(_meta, pasoMeta);
    notifyListeners();
  }

  void bajarMeta() {
    _meta = ajustarMeta(_meta, -pasoMeta);
    notifyListeners();
  }
}
