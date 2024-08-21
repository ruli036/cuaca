import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:tes_pt_daya_rekadigital/connections/apiService.dart';
import 'package:tes_pt_daya_rekadigital/connections/objectAPI.dart';
import 'package:intl/intl.dart';

class WeatherController extends GetxController {
  final ApiService apiService = ApiService();


  var data = {}.obs;
  RxInt akctive = 0.obs;
  var isLoading = true.obs;
  late RxList<WeatherData> weatherData = <WeatherData>[].obs;
  late RxList<PerkiraanView> cuacaView = <PerkiraanView>[].obs;


  String formatwaktuUtama({String timestamp = '202407200000',String format= 'YYYY mm dd'}) {
    final year = int.parse(timestamp.substring(0, 4));
    final month = int.parse(timestamp.substring(4, 6));
    final day = int.parse(timestamp.substring(6, 8));
    final hour = int.parse(timestamp.substring(8, 10));
    final minute = int.parse(timestamp.substring(10, 12));

    final hasSeconds = timestamp.length > 12;
    final second = hasSeconds ? int.parse(timestamp.substring(12, 14)) : 0;

    final dateTime = DateTime(year, month, day, hour, minute, second);

    final formattedDate = DateFormat(format).format(dateTime);

    return formattedDate;
  }


  void filterData(List data,String day){
    final List = data;
    cuacaView.value.clear();
    for (var map in List) {
      if (formatwaktuUtama(format: 'dd', timestamp: map['temperature'].jam) == day) {
            final perkiraanView = PerkiraanView(
              jam: map['temperature'].jam,
              cuaca: map['temperature'].cuaca,
              suhu: map['temperature'].suhu,
            );
            cuacaView.addAll({perkiraanView});
            print(map);
            print(cuacaView.value);
      }
    };

  }
  void fetchData() async {
    isLoading.value = true;
    final response = await apiService.getData('DigitalForecast-DKIJakarta.xml');
    print(response.body);
    if (response.status.hasError) {
      Get.snackbar('Error', 'Failed to fetch data ${response.status.code}');
    } else {
      var parsedData = parseWeatherData(response.body);
      weatherData.value = parsedData.where((data) => data.description == 'Jakarta Barat').toList();
      filterData(weatherData[0].perkiraanList,'20');
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();

  }

}