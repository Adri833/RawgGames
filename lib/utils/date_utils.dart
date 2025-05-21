import 'package:intl/intl.dart';

String formatFecha(String? fecha) {
  if (fecha == null || fecha.isEmpty) return 'Desconocida';

  try {
    final date = DateTime.parse(fecha);
    return DateFormat('dd/MM/yyyy', 'es_ES').format(date);
  } catch (e) {
    return 'Desconocida';
  }
}
