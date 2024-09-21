import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_notes/model/noteModal.dart';
import 'package:my_notes/pages/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Createnote extends StatefulWidget {
  const Createnote({super.key});

  @override
  State<Createnote> createState() => _CreatenoteState();
}

class _CreatenoteState extends State<Createnote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Note> notes = [];

  Future<void> saveNotes() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? notesJsonList = prefs.getStringList('notes');
    if (notesJsonList != null) {
      notes = notesJsonList
          .map((noteJson) => Note.fromMap(jsonDecode(noteJson)))
          .toList();
    }

    String title = titleController.text;
    String content = descriptionController.text;

    if (title.isNotEmpty && content.isNotEmpty) {
      notes.add(Note(
        title: title,
        content: content,
      ));

      List<String> updatedNotesJsonList =
          notes.map((note) => jsonEncode(note.toMap())).toList();

      await prefs.setStringList('notes', updatedNotesJsonList);

      titleController.clear();
      descriptionController.clear();
    }
  }

  void addNote() {
    saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: <Widget>[
            Text(
              "Create Your Note",
              style:
                  GoogleFonts.habibi(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 18,
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                  labelText: "Title",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(153, 255, 255, 255))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: descriptionController,
              maxLines: 10,
              decoration: const InputDecoration(
                  labelText: "Description",
                  hintText: "What's on your mind??",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(153, 255, 255, 255))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const ContinuousRectangleBorder(),
                  padding: const EdgeInsets.all(8)),
              onPressed: () {
                if (titleController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text(
                          "Please Enter the title",
                          style: GoogleFonts.abel(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'OK',
                              style: GoogleFonts.abel(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  addNote();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Successfully Added the Note"),
                      duration: Duration(seconds: 4),
                    ),
                  );
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Homepage()),
                    (route) => false,
                  );
                }
              },
              child: Text(
                "Create",
                style: GoogleFonts.abel(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
