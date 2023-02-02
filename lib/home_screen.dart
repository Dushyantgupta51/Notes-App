// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:notes/create_screen.dart';
import 'package:notes/favourites_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    checkListIsEmptyOrNot();
  }

  List allNotesList = [];
  List createdNotesList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(Icons.settings),
          )
        ],
        elevation: 0,
        toolbarHeight: 80,
        backgroundColor: Colors.yellow[800],
        title: const Text(
          "All Notes",
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 35,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.yellow[800],
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                        child: Text(
                          "All Notes",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      {
                        if (favNotesList.isNotEmpty) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Favourites(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                          setState(() {});
                        }
                      }
                    },
                    child: Container(
                      height: 35,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.yellow[800],
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                        child: Text(
                          "Favourites",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(child: renderGridView()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          title = "";
          desc = "";
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Second(-1),
            ),
          );
        },
        backgroundColor: Colors.yellow[800],
        child: const Icon(Icons.add),
      ),
    );
  }

  checkListIsEmptyOrNot() async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.getString('allNotesData');
    if (result == null) {
      prefs.setString('allNotesData', jsonEncode([]));
    }
    createdNotesList = jsonDecode(result!);
    setState(() {});
  }
  
  Widget renderGridView() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: ((context, index) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              createdNotesList = jsonDecode(prefs.getString('allNotesData')!);
              if (title.isNotEmpty) {
                title = createdNotesList[index]['title'];
                desc = createdNotesList[index]['desc'];
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Second(index),
                  ),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            TextSpan(
                              text: createdNotesList[index]['title'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Text.rich(
                            overflow: TextOverflow.ellipsis,
                            TextSpan(text: ('\n')),
                          ),
                          Text.rich(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            TextSpan(
                              text: createdNotesList[index]['desc'],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            deleteNote(index);
                          },
                          icon: const Icon(
                            Icons.delete,
                            size: 23,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            addInFavourite(index);
                          },
                          icon: const Icon(
                            Icons.thumb_up_alt_outlined,
                            size: 23,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
      itemCount: createdNotesList.length,
    );
  }

  addInFavourite(index) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    allNotesList = jsonDecode(sharedPreferences.getString('allNotesData')!);
    if (favNotesList.isEmpty) {
      favNotesList.add(allNotesList[index]);
      await sharedPreferences.setString(
          'favNotesData', jsonEncode(favNotesList));
    } else {
      favNotesList.insert(favNotesList.length, allNotesList[index]);
      await sharedPreferences.setString(
          'favNotesData', jsonEncode(favNotesList));
    }
    setState(() {});
  }

  deleteNote(index) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    allNotesList = jsonDecode(sharedPreferences.getString('allNotesData')!);
    allNotesList.removeWhere((element) => element == allNotesList[index]);
    await sharedPreferences.setString('allNotesData', jsonEncode(allNotesList));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (Route<dynamic> route) => false,
    );
    setState(() {});
  }
}
