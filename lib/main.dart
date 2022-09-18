import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
    runApp(const MyApp());
}

const title = 'Startup Name Generator';

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: title,
            home: const RandomWords(),
            theme: ThemeData(
                appBarTheme: const AppBarTheme(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                )
            )
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
        return Scaffold(
            appBar: AppBar(
                title: const Text(title),
                actions: [
                    IconButton(
                        icon: const Icon(Icons.list),
                        onPressed: _pushSaved,
                        tooltip: "Saved Suggestions",
                    )
                ]
            ),
            body: ListView.builder(
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
                            trailing: IconButton(
                                icon: Icon(
                                    alreadySaved ? Icons.favorite : Icons.favorite_border,
                                    color: alreadySaved ? Colors.red : null,
                                    semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
                                ),
                                onPressed: () {
                                    setState(() {
                                        if (alreadySaved) {
                                            _saved.remove(_suggestions[i]);
                                        } else {
                                            _saved.add(_suggestions[i]);
                                        }
                                    });
                                }
                            )
                        ),
                        elevation: 10,
                    );
                }
            )
        );
    }

    void _pushSaved() {
        Navigator.of(context).push(
            MaterialPageRoute<void>(
                builder: (context) {
                    final tiles = _saved.map(
                        (pair) {
                            return ListTile(
                                title: Text(
                                    pair.asPascalCase,
                                    style: _biggerFont,
                                )
                            );
                        }
                    );
                    final divided = tiles.isNotEmpty
                        ? ListTile.divideTiles(
                              context: context,
                              tiles: tiles,
                          ).toList()
                        : <Widget>[];
                    return Scaffold(
                        appBar: AppBar(
                            title: const Text("Saved Suggestions")
                        ),
                        body: ListView(children: divided)
                    );
                }
            )
        );
    }
}
