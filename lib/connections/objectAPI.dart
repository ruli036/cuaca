import 'package:xml/xml.dart' as xml;

class WeatherData {
  final String waktu;
  final List<Map<String, dynamic>> perkiraanList;
  final String domain;
  final String description;

  WeatherData({
    required this.waktu,
    required this.perkiraanList,
    required this.domain,
    required this.description,
  });

  WeatherData copyWith({
    String? waktu,
    List<Map<String, dynamic>>? perkiraanList,
    String? domain,
    String? description,
  }) {
    return WeatherData(
      waktu: waktu ?? this.waktu,
      perkiraanList: perkiraanList ?? this.perkiraanList,
      domain: domain ?? this.domain,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'Waktu: $waktu, PerkiraanList: $perkiraanList, Domain: $domain, Description: $description';
  }
}

class Perkiraan {
  final String jam;
  final String cuaca;
  final String suhu;

  Perkiraan({
    required this.jam,
    required this.cuaca,
    required this.suhu,
  });

  @override
  String toString() {
    return 'Jam: $jam, Cuaca: $cuaca, Suhu: $suhu';
  }
}

class PerkiraanView {
  final String jam;
  final String cuaca;
  final String suhu;

  PerkiraanView({
    required this.jam,
    required this.cuaca,
    required this.suhu,
  });

  @override
  String toString() {
    return 'Jam: $jam, Cuaca: $cuaca, Suhu: $suhu';
  }
}


List<WeatherData> parseWeatherData(String xmlString) {
  final document = xml.XmlDocument.parse(xmlString);
  final List<WeatherData> weatherDataList = [];

  final areas = document.findAllElements('area').toList();

  if (areas.isEmpty) {
    throw Exception('No elements found in XML');
  }

  final issueElements = document.findAllElements('issue').toList();
  final timestamp = issueElements.isNotEmpty ? issueElements.first.findElements('timestamp').first.text : 'kosong';

  for (var area in areas) {
    final domain = area.getAttribute('domain') ?? '';
    final description = area.getAttribute('description') ?? '';

    final hourlyParameters = area.findElements('parameter').where((element) => element.getAttribute('type') == 'hourly');

    final List<Map<String, dynamic>> perkiraanList = [];

    for (var parameter in hourlyParameters) {
      final parameterId = parameter.getAttribute('id');
      String datetime = '';
      String tempC = '';
      String icon = '';

      if (parameterId == 't') {
        for (var timeRange in parameter.findElements('timerange')) {
          datetime = timeRange.getAttribute('datetime') ?? '';
          final tempCLits = timeRange.findElements('value').toList();

          for (var temp in tempCLits) {
            if (temp.getAttribute('unit') == 'C') {
              tempC = temp.text;
            }
          }

          final existingPerkiraan = {
            'temperature': Perkiraan(
              suhu: '$tempC°',
              jam: datetime,
              cuaca: icon,
            )
          };

          perkiraanList.add(existingPerkiraan);
        }
      } else if (parameterId == 'weather') {
        for (var timeRange in parameter.findElements('timerange')) {
          datetime = timeRange.getAttribute('datetime') ?? '';
          icon = timeRange.findElements('value').isNotEmpty ? timeRange.findElements('value').first.text : '';

          // Cari perkiraan yang sudah ada dengan datetime yang sama
          final existingIndex = perkiraanList.indexWhere((map) =>
          map['temperature']?.jam == datetime); // Cari berdasarkan 'jam'

          if (existingIndex != -1) {
            // Jika ditemukan, perbarui cuaca
            perkiraanList[existingIndex]['temperature'] = Perkiraan(
              suhu: perkiraanList[existingIndex]['temperature']!.suhu,
              jam: datetime,
              cuaca: icon,
            );
          } else {
            // Jika tidak ditemukan, tambahkan sebagai entri baru
            final existingPerkiraan = {
              'temperature': Perkiraan(
                suhu: '$tempC°',
                jam: datetime,
                cuaca: icon,
              )
            };

            perkiraanList.add(existingPerkiraan);
          }
        }
      }


      // Ensure datetime is not null before using
      // if (datetime != null) {
      //   final existingPerkiraan = {
      //     'temperature': Perkiraan(
      //       suhu: '$tempC°C',
      //       jam: datetime!,
      //       cuaca: icon,
      //     )
      //   };
      //
      //   perkiraanList.add(existingPerkiraan);
      // }
    }

    weatherDataList.add(WeatherData(
      waktu: timestamp,
      perkiraanList: perkiraanList,
      domain: domain,
      description: description,
    ));
  }

  return weatherDataList;
}





