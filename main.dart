
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/pagina_inicial.dart';
import 'services/filme_service.dart';
import 'viewmodels/filme_viewmodel.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FilmeViewModel(
        FilmeService(),
      )..carregarFilmes(),
      child: const MeuAplicativo(),
    ),
  );
}

class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha Lista de Filmes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const PaginaInicial(),
    );
  }
}
