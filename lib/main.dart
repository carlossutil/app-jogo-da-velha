import 'package:flutter/material.dart';

void main() {
  runApp(const JogoDaVelha());
}

class JogoDaVelha extends StatelessWidget {
  const JogoDaVelha({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Velha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
         primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: const Tabuleiro(),
    );
  }
}

class Tabuleiro extends StatefulWidget {
  const Tabuleiro({super.key});

  @override
  State<Tabuleiro> createState() => _TabuleiroState();
}

class _TabuleiroState extends State<Tabuleiro> {
  // Variáveis do jogo
  List<String> _jogadas = List.filled(9, '', growable: false);
  bool _jogadorX = true;
  String _vencedor = '';

  // Reinicia o jogo
  void _reiniciar() {
    setState(() {
      _jogadas = List.filled(9, '', growable: false);
      _jogadorX = true;
      _vencedor = '';
    });
  }

  // Faz a jogada
  void _jogar(int index) {
    if (_jogadas[index] == '' && _vencedor == '') {
      setState(() {
        _jogadas[index] = _jogadorX ? 'X' : 'O';
        _jogadorX = !_jogadorX;
        _vencedor = _verificarVencedor();
      });
    }
  }

  // Verifica se há um vencedor
  String _verificarVencedor() {
    const linhasVencedoras = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var linha in linhasVencedoras) {
      final a = _jogadas[linha[0]];
      final b = _jogadas[linha[1]];
      final c = _jogadas[linha[2]];
      if (a != '' && a == b && a == c) {
        return a; // Retorna "X" ou "O"
      }
    }

    if (!_jogadas.contains('')) {
      return 'Empate';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Velha de Carlos'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Exibição do placar ou mensagem
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 0, 0, 0),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  _vencedor.isEmpty
                      ? 'Vez do jogador: ${_jogadorX ? 'X' : 'O'}'
                      : _vencedor == 'Empate'
                          ? 'Empate!'
                          : 'Vencedor: $_vencedor',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 16),

              // Tabuleiro do jogo
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 3, 3, 3),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _jogar(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              _jogadas[index],
                              style: TextStyle(
                                fontSize: size.width * 0.08, // Responsivo
                                fontWeight: FontWeight.bold,
                                color: _jogadas[index] == 'X'
                                    ? const Color.fromARGB(255, 37, 145, 233)
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Botão de reiniciar
              ElevatedButton(
                onPressed: _reiniciar,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Reiniciar Jogo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
