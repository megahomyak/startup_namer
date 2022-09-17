import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Startup Name Generator';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: const Center(
          child: RandomWords(),
        ),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
    const RandomWords({super.key});

    @override
    State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
    final _suggestions = <WordPair>[];
    final _biggerFont = const TextStyle(fontSize: 18);
    final _saved = <WordPair>{};

    @override
    Widget build(BuildContext context) {
        return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, i) {
                if (i.isOdd) {
                    return SizedBox(height: 10);
                }
                i = i ~/ 2;
                if (i >= _suggestions.length) {
                    _suggestions.addAll(generateWordPairs().take(10));
                }
                final alreadySaved = _saved.contains(_suggestions[i]);
                return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: ListTile(
                        title: Text(
                            _suggestions[i].asPascalCase,
                            style: _biggerFont,
                        ),
                        trailing: Icon(
                            alreadySaved ? Icons.favorite : Icons.favorite_border,
                            color: alreadySaved ? Colors.red : null,
                            semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
                        ),
                        onTap: () {
                            setState(() {
                                if (alreadySaved) {
                                    _saved.remove(_suggestions[i]);
                                } else {
                                    _saved.add(_suggestions[i]);
                                }
                            });
                        }
                    ),
                    elevation: 10,
                );
            }
        );
    }
}
