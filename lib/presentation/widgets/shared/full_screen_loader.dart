import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages() {
    final List<String> messages = [
      'Cargando películas',
      'Comprando palomitas de maíz',
      'Cargando populares',
      'Llamando a mi puta',
      'Ya mero...',
      'Esto está tardando más de lo esperado. :(',
    ];

    return Stream.periodic(
      const Duration(milliseconds: 200),
      (step) => messages[step],
    ).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Espere por favor'),
          const SizedBox(height: 10),
          const CircularProgressIndicator(strokeWidth: 2),
          const SizedBox(height: 10),
          StreamBuilder(
            stream: getLoadingMessages(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) return const Text('Cargando');

              return Text(snapshot.data!);
            },
          )
        ],
      ),
    );
  }
}
