import 'package:translator/translator.dart';

final GoogleTranslator _translator = GoogleTranslator();

Future<String> traducirTexto(String texto) async {
  try {
    final translation = await _translator.translate(texto, from: 'en', to: 'es');
    return translation.text;
  } catch (e) {
    print('❌ Error en traducción: $e');
    return texto; // Devuelve el original si falla la traducción
  }
}
