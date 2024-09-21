import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_notes/model/noteModal.dart';
import 'package:my_notes/pages/createNote.dart';
import 'package:my_notes/utils/notes_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Note> notes = [];
  void deletefunction(int index) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  setState(() {
    notes.removeAt(index);
  });

  List<String> updatedNotesJsonList = notes.map((note) => jsonEncode(note.toMap())).toList();
  await prefs.setStringList('notes', updatedNotesJsonList);
  print("Note at index $index deleted.");
}

  Future<void> loadNotes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? notesJsonList = prefs.getStringList('notes');

    if (notesJsonList != null) {
      setState(() {
        notes = notesJsonList
            .map((noteJson) => Note.fromMap(jsonDecode(noteJson)))
            .toList();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            "Notes",
            style: GoogleFonts.abel(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Create a note",
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Createnote()));
          },
          child: const Icon(Icons.add),
        ),
        body: notes.isEmpty?
        const Center(
                child: Text("Create your first Note"),
              )
        : ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            print(notes.length);
            return NotesTile(
              title: notes[index].title,
              content: notes[index].content,
              deletefunction: (p0) => deletefunction(index),
            );
          },
        ));
  }
}
