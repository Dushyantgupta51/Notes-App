// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:notes/create_screen.dart';
import 'package:notes/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  void initState() {
    super.initState();
    decodeFav();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        elevation: 0,
        toolbarHeight: 80,
        title: const Text(
          "Favourite Notes",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                          (Route<dynamic> route) => false,
                        );
                        setState(() {});
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
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                          (Route<dynamic> route) => false,
                        );
                        setState(() {});
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
                          "Unfavourites",
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
            Expanded(
              child: renderGridView(),
            ),
          ],
        ),
      ),
    );
  }

  decodeFav() async {
    final prefs = await SharedPreferences.getInstance();
    final result = prefs.getString('favNotesData');
    if (result == null) {
      prefs.setString('favNotesData', jsonEncode([]));
    }
    favNotesList = jsonDecode(result!);
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
              favNotesList = jsonDecode(prefs.getString('favListData')!);
              if (title.isNotEmpty) {
                title = favNotesList[index]['title'];
                desc = favNotesList[index]['desc'];
                
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
                              text: favNotesList[index]['title'],
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
                              text: favNotesList[index]['desc'],
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
                            deleteFavNote(index);
                          },
                          icon: const Icon(
                            Icons.thumb_down_alt_outlined,
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
      itemCount: favNotesList.length,
    );
  }

  deleteFavNote(index) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    favNotesList = jsonDecode(sharedPreferences.getString('favNotesData')!);
    favNotesList.removeWhere((element) => element == favNotesList[index]);
    await sharedPreferences.setString('favNotesData', jsonEncode(favNotesList));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Favourites()),
      (Route<dynamic> route) => false,
    );
    setState(() {});
  }
}
