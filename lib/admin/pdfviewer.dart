
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:share_extend/share_extend.dart';

class PdfViewerPage extends StatelessWidget {
  final String path;
  const PdfViewerPage({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
       actions: [
         IconButton(icon: Icon(Icons.share), onPressed: (){
           ShareExtend.share(path,"report.pdf");
         })
       ],
      ),
      path: path,
    );
  }
}