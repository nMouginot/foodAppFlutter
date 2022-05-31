import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class DisplayPDF extends StatelessWidget {
  const DisplayPDF({Key? key, required this.filePath, required this.fileName})
      : super(key: key);

  final String filePath;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => {Navigator.pop(context)},
              ),
              title: Text(fileName),
            ),
            backgroundColor: Colors.grey,
            body: PdfViewer.openFile(filePath)));
  }
}
