import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tes_pt_daya_rekadigital/connections/objectAPI.dart';
import 'package:tes_pt_daya_rekadigital/controllers/weatherController.dart';

class WeatherPageView extends StatelessWidget {
  const WeatherPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final WeatherController controller = Get.put(WeatherController());
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          final location = controller.weatherData[0];
          return Column(
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xFF6369F5),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              location.domain,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.white),
                            ),
                            const Padding(
                              padding:  EdgeInsets.all(4),
                              child: Icon(Icons.arrow_circle_down_sharp,color: Colors.white,),
                            )
                          ],
                        ),
                        Text(
                          'Kota ${location.description}',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        const  Text(
                          '27°',
                          style: TextStyle(fontSize: 100, color: Colors.white),
                        ),
                        Text(
                          '${controller.formatwaktuUtama(timestamp: location.waktu, format: 'EEEE, d MMMM HH:mm')}',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        const Text(
                          "Cerah Berawan",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white),
                        ),
                        Image.asset(
                          'assets/berawan.png',
                          height: 200,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 60,
                child: Stack(
                  children: [
                    Container(
                      height: 70,
                      color: Color(0xFF6369F5),
                    ),
                    CustomPaint(
                      painter: WavePainter(),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            controller.akctive.value = 0;
                                            controller.filterData(controller.weatherData[0].perkiraanList, '20');
                                          },
                                          child:const Text(
                                            'Hari Ini',
                                            style: TextStyle(
                                                color: Colors.black, fontSize: 18),
                                          )),
                                      Container(
                                        color: controller.akctive.value == 0
                                            ? Colors.black
                                            : Colors.white,
                                        width: 50,
                                        height: 4,
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            controller.akctive.value = 1;
                                            controller.filterData(controller.weatherData[0].perkiraanList, '21');
                                          },
                                          child: const Text(
                                            'Besok',
                                            style: TextStyle(
                                                color: Colors.black, fontSize: 18),
                                          )),
                                      Container(
                                        color: controller.akctive.value == 1
                                            ? Colors.black
                                            : Colors.white,
                                        width: 50,
                                        height: 4,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Divider(
                              height: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color:Colors.white,
                  height: MediaQuery.of(context).size.height / 3.5,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(controller.cuacaView.length, (i) {
                      final data = controller.cuacaView[i];
                      return Container(
                        color:Colors.white,
                        width: MediaQuery.of(context).size.width / 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                                '${controller.formatwaktuUtama(format: 'HH:mm', timestamp: data.jam)}',
                                style: TextStyle(fontSize: 16)),
                            Padding(
                              padding: const EdgeInsets.only(top: 0, bottom: 0),
                              child: FaIcon(
                                size: 30,
                                color: Colors.grey,
                                data.cuaca == '3'
                                    ? FontAwesomeIcons.cloud
                                    : data.cuaca == '1'
                                        ? FontAwesomeIcons.smog
                                        : FontAwesomeIcons.sun,
                              ),
                            ),
                            Text('${data.suhu}',
                                style: TextStyle(fontSize: 30)),
                          ],
                        ),
                      );
                    }),
                  )),
            ],
          );
        }
      }),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final Path path = Path();
    path.moveTo(0, size.height / 2);

    for (double i = 0; i < size.width; i++) {
      path.lineTo(i, size.height / 50 + 30 * sin(i / 75));
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}