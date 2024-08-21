import 'dart:developer';

import 'package:get/get.dart';
import 'package:tes_pt_daya_rekadigital/controllers/weatherController.dart';


class WeatherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WeatherController());
  }
}