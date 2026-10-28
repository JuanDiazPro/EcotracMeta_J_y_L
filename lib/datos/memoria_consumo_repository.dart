import '../dominio/consumo.dart';
import 'consumo_repository.dart';

class MemoriaConsumoRepository implements ConsumoRepository {
  final List<Consumo> _consumos = [];

  @override
  Future<void> guardar(Consumo consumo) async {
    _consumos.add(consumo);
  }

  @override
  Future<List<Consumo>> todos() async => List.unmodifiable(_consumos); // copia que nadie modifica
}
