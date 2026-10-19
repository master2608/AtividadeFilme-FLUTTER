
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/filme.dart';
import '../viewmodels/filme_viewmodel.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  final TextEditingController _controller =
      TextEditingController();

  Future<void> _adicionarFilme() async {
    final viewModel = context.read<FilmeViewModel>();

    final sucesso = await viewModel.adicionarFilme(
      _controller.text,
    );

    if (!mounted) return;

    if (sucesso) {
      _controller.clear();
      FocusScope.of(context).unfocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewModel.erro ?? 'Não foi possível adicionar.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Lista de Filmes'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nome do filme',
                hintText: 'Digite o nome do filme',
                prefixIcon: Icon(Icons.movie),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _adicionarFilme(),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _adicionarFilme,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar'),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(),

            Expanded(
              child: Consumer<FilmeViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.carregando &&
                      viewModel.filmes.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (viewModel.erro != null &&
                      viewModel.filmes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(viewModel.erro!),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed:
                                viewModel.carregarFilmes,
                            child: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (viewModel.filmes.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum filme cadastrado.\n'
                        'Adicione seu primeiro filme!',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: viewModel.filmes.length,
                    itemBuilder: (context, index) {
                      final Filme filme =
                          viewModel.filmes[index];

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text(
                            filme.titulo,
                            style: TextStyle(
                              decoration: filme.assistido
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: filme.assistido
                                  ? Colors.grey
                                  : null,
                            ),
                          ),
                          trailing: Checkbox(
                            value: filme.assistido,
                            onChanged: (valor) {
                              if (valor == null) return;

                              context
                                  .read<FilmeViewModel>()
                                  .alterarStatus(
                                    filme,
                                    valor,
                                  );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
