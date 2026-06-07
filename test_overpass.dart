import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final lat = -7.2684;
  final lng = 112.7845;
  final query = '''
    [out:json][timeout:10];
    (
      nwr["amenity"="clinic"](around:5000,$lat,$lng);
      nwr["amenity"="hospital"](around:5000,$lat,$lng);
      nwr["healthcare"="clinic"](around:5000,$lat,$lng);
    );
    out center;
  ''';

  final url = Uri.parse('https://overpass-api.de/api/interpreter');
  try {
    final response = await http.post(
      url, 
      body: {'data': query},
      headers: {
        'User-Agent': 'AuraHealthApp/1.0',
        'Accept': '*/*',
      }
    ).timeout(Duration(seconds: 15));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final elements = data['elements'] as List;
      print('Total elements: ${elements.length}');
      int puskesmasCount = 0;
      for (var el in elements) {
        final tags = el['tags'] ?? {};
        final name = tags['name']?.toString() ?? 'Unnamed';
        if (name.toLowerCase().contains('puskesmas')) {
          print('- $name');
          puskesmasCount++;
        }
      }
      print('Elements with "puskesmas" in name: $puskesmasCount');
    }
  } catch (e) {
    print('Error: $e');
  }
}
