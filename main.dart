import "dart:html";

import 'package:h5compress/h5Compress.dart';

void main() {
  FileUploadInputElement fileInput = FileUploadInputElement();
  fileInput
    ..onChange.listen((Event ev) async {
      FileUploadInputElement el = ev.target as FileUploadInputElement;
      File f = el.files[0];
      Blob blob = await compress(f); //COMPRESSING
      print("finished");
    });

  document.body.children.add(fileInput);
}
