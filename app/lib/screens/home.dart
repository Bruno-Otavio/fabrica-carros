import 'package:carousel_slider/carousel_slider.dart';
import 'package:fabrica_carros/screens/details.dart';
import 'package:fabrica_carros/services/alocacao_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _futureAreas = AlocacaoService.getAreas();
  final _areasList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

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
