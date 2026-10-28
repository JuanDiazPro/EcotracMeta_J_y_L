# Gestión de estado — EcoTrack Meta

**Equipo:Juan Jose Diaz Barroso y Leonardo Martinez Vazquez**
**Fecha:** 27/10/26

## Tipos de estado en nuestro código

| Dato | Tipo (efímero, compartido, derivado, persistido) | Dónde vive |
|---|---|---|
| Pestaña activa | Efímero: solo le importa a la barra inferior y se pierde sin problema. | `_pestana` en `_PantallasEcoTrackState` (`lib/presentacion/vistas.dart`). |
| Texto del campo de litros | Efímero: nadie más lo necesita hasta que se toca `Guardar`. | `TextEditingController _litros` en `_FormularioRegistroState` (`lib/presentacion/vistas.dart`), liberado en `dispose()`. |
| consumos y meta | Compartido: Registro, Historial y Meta leen el mismo dato. | Campos `_consumos` y `_meta` de `ConsumosViewModel` (`lib/presentacion/consumos_view_model.dart`). |
| total y metaSuperada | Derivado: se calcula de `consumos` y `meta`, nunca se guarda. | Getters `total` y `metaSuperada` de `ConsumosViewModel`; prueba `total, avance y metaSuperada se derivan de consumos y meta` (`test/etapa3_viewmodel_test.dart`). |
| Lo que regresa todos() | Persistido: es la fuente de verdad, el ViewModel solo tiene una copia. | Lista privada `_consumos` de `MemoriaConsumoRepository` (`lib/datos/memoria_consumo_repository.dart`), entregada como `List.unmodifiable`. |

## Criterios

| Criterio | A · ChangeNotifier puro | B · provider |
|---|---|---|
| Dato compartido | Lo guardado en Registro aparece en Historial y Meta porque las tres pestañas escuchan el mismo `_vm`. Prueba `Dato compartido` en `test/etapa4_change_notifier_test.dart`. | Igual, pero las pestañas leen el ViewModel del `ChangeNotifierProvider`. Prueba `Dato compartido` en `test/etapa5_provider_test.dart`. |
| Capas | `vistas.dart` no conoce el ViewModel; el error de `validarLitros` llega a la vista como texto. Prueba `Capas` de la etapa 4 y puntos 2–4 de `verificar_estado.sh`. | Las mismas vistas y el mismo ViewModel sin cambios; solo cambia el adaptador. Prueba `Capas` de la etapa 5. |
| Encaje con el diagrama | Dominio → datos → ViewModel → vistas se respeta; el cableado vive solo en `lib/variantes/a_change_notifier.dart`. | Se respeta igual; el cableado vive solo en `lib/variantes/b_provider.dart`. |
| Constructores que reciben vm | 3: `RegistroCN`, `HistorialCN` y `MetaCN` (`required this.vm`). Cada pantalla nueva suma uno. | 0: `RegistroProvider`, `HistorialProvider` y `MetaProvider` son `const` y usan `context.watch`/`context.read`. |
| Quién libera el ViewModel | Nosotros: `_AppChangeNotifierState.dispose()` llama a `_vm.dispose()`. | `ChangeNotifierProvider`, al salir del árbol; no escribimos `dispose()`. |
| Costo de adoptarla ahora | Cero dependencias: solo Flutter (`ListenableBuilder`). Más código repetido al pasar `vm`. | Un paquete extra (`provider` en `pubspec.yaml`) y aprender `watch`/`read`; menos código en cada pantalla. |
| Sustitución de la fuente de datos | `AppChangeNotifier(repositorio: espia)` funciona sin tocar pantallas. Prueba `Sustitución` de la etapa 4 con `RepositorioEspia`. | `AppProvider(repositorio: espia)` igual. Prueba `Sustitución` de la etapa 5. |

## Elección

Elegimos: B · provider, arrancada desde `lib/main.dart`, porque no hay que pasar `vm` por constructores y el ViewModel se libera solo.
Se mantiene esta pieza del diagrama: `ConsumosViewModel` (`lib/presentacion/consumos_view_model.dart`); entre A y B no cambió ni una línea, igual que `vistas.dart`.
Esta pieza es la que podría sustituirse después: `MemoriaConsumoRepository`, por otra implementación de `ConsumoRepository` (por ejemplo, en la nube), cambiando solo `main.dart`.
