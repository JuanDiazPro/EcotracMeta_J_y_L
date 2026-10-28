const metaInicial = 100.0;
const pasoMeta = 10.0;
const metaMinima = 10.0;

double ajustarMeta(double actual, double cambio) {
  final nueva = actual + cambio;
  return nueva < metaMinima ? metaMinima : nueva;
}

double avanceDeMeta({required double total, required double meta}) {
  if (meta <= 0) return 0; 
  return (total / meta).clamp(0, 1).toDouble();
}
