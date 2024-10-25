import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fabrica_carros/screens/details.dart';
import 'package:fabrica_carros/services/alocacao_service.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _futureAreas = AlocacaoService.getAreas();
  final _areasList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  final battery = Battery();

  static const Duration _ignoreDuration = Duration(milliseconds: 20);

  AccelerometerEvent? _accelerometerEvent;
  GyroscopeEvent? _gyroscopeEvent;

  late StreamSubscription _accelerometerSubscription;
  late StreamSubscription _gyroscopeSubscription;

  DateTime? _accelerometerUpdateTime;
  DateTime? _gyroscopeUpdateTime;

  int? _accelerometerLastInterval;
  int? _gyroscopeLastInterval;

  int _shakeCount = 0;

  final Duration _sensorInterval = SensorInterval.normalInterval;

  late StreamSubscription connectionSub;

  void checkConnection(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none)) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('No internet'),
          );
        },
      );
    }
  }

  void _checkIfShaking() {
    if (_shakeCount >= 3) {
      showDialog(context: context, builder: (context) {
        return const AlertDialog(
          title: Text('Shaking!'),
          content: Text('Stop shaking it!. I\'m getting dizzy...'),
        );
      });
      setState(() {
        _shakeCount = 0;
      });
      Future.delayed(const Duration(seconds: 3)).then((v) => Navigator.pop(context));
    } else if (_accelerometerEvent!.x > 5) {
      setState(() {
        _shakeCount++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    connectionSub =
        Connectivity().onConnectivityChanged.listen(checkConnection);

    battery.batteryLevel.then((batteryLevel) {
      if (batteryLevel <= 15) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Low battery'),
              content:
                  Text('Your battery is $batteryLevel. Please charge it now!'),
            );
          },
        );
      }
    });

    _accelerometerSubscription = accelerometerEventStream(samplingPeriod: _sensorInterval).listen(
      (AccelerometerEvent event) {
        final now = event.timestamp;
        setState(() {
          _accelerometerEvent = event;
          if (_accelerometerUpdateTime != null) {
            final interval = now.difference(_accelerometerUpdateTime!);
            if (interval > _ignoreDuration) {
              _accelerometerLastInterval = interval.inMilliseconds;
              _checkIfShaking();
            }
          }
        });
        _accelerometerUpdateTime = now;
      },
      onError: (e) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("Sensor Not Found"),
              content: Text(
                "It seems that your device doesn't support Accelerometer Sensor",
              ),
            );
          },
        );
      },
      cancelOnError: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    connectionSub.cancel();
    _accelerometerSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Planta da Fábrica',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _futureAreas,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List areas = snapshot.data!;
            return Center(
              child: CarouselSlider(
                items: _areasList.map((e) {
                  return GestureDetector(
                    onTap: () {
                      if (areas.contains(e)) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(
                              area: e,
                            ),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              title: Text('Atenção'),
                              content: Text(
                                'Essa área não possui veículos.',
                                style: TextStyle(fontSize: 18),
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      color: areas.contains(e)
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.tertiary,
                      child: Center(
                        child: Text(
                          e.toString(),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 500,
                  aspectRatio: 16 / 9,
                  enlargeCenterPage: true,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
