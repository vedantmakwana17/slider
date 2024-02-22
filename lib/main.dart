import 'package:flutter/material.dart';


void main() {
  runApp(
    MaterialApp(
      home: Slider1(),
      debugShowCheckedModeBanner: false,

    ),
  );
}


class Slider1 extends StatefulWidget {
  @override
  _Slider1State createState() => _Slider1State();
}

class _Slider1State extends State<Slider1> {
  List<String> items = [];
  late String? removedItem;
  late int? removedIndex;

  void _addItem(String newItem) {
    setState(() {
      items.add(newItem);
    });
  }

  void _removeItem(int index) {
    setState(() {
      removedItem = items[index];
      removedIndex = index;
      items.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Item dismissed"),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            _undoRemove();
          },
        ),
      ),
    );
  }

  void _undoRemove() {
    setState(() {
      if (removedIndex != null && removedItem != null) {
        items.insert(removedIndex!, removedItem!);
        removedItem = null;
        removedIndex = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Swipe to Delete Demo"),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Dismissible(
            key: Key(item),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: const Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
            onDismissed: (direction) {
              _removeItem(index);
            },
            child: Card(
              color: Colors.yellow,
              child: ListTile(
                title: Text(item),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    String newItem = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Item'),
          content: TextField(
            onChanged: (value) {
              newItem = value;
            },
            decoration: const InputDecoration(
              labelStyle: TextStyle(color: Colors.black),
              prefixIconColor: Colors.black,
              hintText: "Enter Text",
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              filled: true,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addItem(newItem);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
