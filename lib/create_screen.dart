import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:notes/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Second extends StatefulWidget {
  final int index;

  const Second(this.index, {super.key});
  @override
  State<Second> createState() => _SecondState();
}

bool favouriteCheck = false;
List favNotesList = [];
List allNotesList = [];
String desc = "";
String title = "";

class _SecondState extends State<Second> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              if (widget.index == -1) {
                if (title.isNotEmpty || desc.isNotEmpty) {
                  addNote();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                  setState(() {});
                }
              } else {
                editNotes(widget.index);
              }
            },
            icon: const Icon(
              Icons.done,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
        toolbarHeight: 80,
        title: const Text(
          "Write your Notes here...",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: title,
              maxLines: null,
              onChanged: (value) {
                setState(() {});
                title = value;
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: ("Title"),
                labelStyle: TextStyle(color: Colors.grey, fontSize: 25),
              ),
            ),
            TextFormField(
              initialValue: desc,
              maxLines: null,
              onChanged: (value) {
                setState(() {});
                desc = value;
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: ("Description"),
                labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  addNote() async {
    final prefs = await SharedPreferences.getInstance();
    allNotesList = jsonDecode(prefs.getString('finalData')!);
    Map<String, String> listMaps = {'title': title, 'desc': desc};
    if (allNotesList.isEmpty) {
      allNotesList.add(listMaps);
      await prefs.setString('finalData', jsonEncode(allNotesList));
    } else {
      allNotesList.insert(allNotesList.length, listMaps);
      await prefs.setString('finalData', jsonEncode(allNotesList));
    }
  }

  editNotes(value) async {
    final prefs = await SharedPreferences.getInstance();
    allNotesList = jsonDecode(prefs.getString('finalData')!);
    Map<String, String> listMaps = {'title': title, 'desc': desc};
    allNotesList.removeWhere((element) => element == allNotesList[value]);
    allNotesList.insert(0, listMaps);
    await prefs.setString('finalData', jsonEncode(allNotesList));

    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (Route<dynamic> route) => false,
    );
    setState(() {});
  }
}
