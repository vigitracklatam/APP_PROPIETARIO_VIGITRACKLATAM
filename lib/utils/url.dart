import 'dart:convert' as convert;

const header_ = {
  'Content-Type': 'application/json; charset=UTF-8',
  'Accept': 'application/json',
};

final enconding_ = convert.Encoding.getByName('utf-8');

bool isUrlValida(String url) {
  try {
    final uri = Uri.tryParse(url);

    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.hasAuthority &&
        uri.host.isNotEmpty;
  } catch (e) {
    print('Error al analizar la URL: $e');
    return false;
  }
}
