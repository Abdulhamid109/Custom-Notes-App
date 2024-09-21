import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesTile extends StatefulWidget {
  final String title;
  final String content;
  final Function(BuildContext) deletefunction;
  const NotesTile(
      {super.key,
      required this.title,
      required this.content,
      required this.deletefunction});

  @override
  State<NotesTile> createState() => _NotesTileState();
}

class _NotesTileState extends State<NotesTile> {
  bool toggleCheckboxx = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Slidable(
        endActionPane: ActionPane(motion: StretchMotion(), children: [
          SlidableAction(
            onPressed: widget.deletefunction,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(8),
            icon: Icons.delete,
          )
        ]),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4,
          shadowColor: Colors.grey.withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: toggleCheckboxx
                      ? GoogleFonts.abhayaLibre(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,
                        )
                      : GoogleFonts.abhayaLibre(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.content,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.abhayaLibre(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[700],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Checkbox(
                    value: toggleCheckboxx,
                    onChanged: (value) {
                      setState(() {
                        toggleCheckboxx = value ?? false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
