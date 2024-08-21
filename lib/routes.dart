import 'package:get/get.dart';
import 'package:tes_pt_daya_rekadigital/bindings.dart';
import 'package:tes_pt_daya_rekadigital/pages/weather/main.dart';


final List<GetPage<dynamic>> route = [
  GetPage(
      name: '/cuaca',
      page: () => const WeatherPageView(),
      binding: WeatherBinding()),
];
