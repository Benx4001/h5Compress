import 'dart:async';
import "dart:html";

import 'dart:typed_data';

void main() {
  FileUploadInputElement fileInput = FileUploadInputElement();
  fileInput
    ..onChange.listen((Event ev) async {
      FileUploadInputElement el = ev.target as FileUploadInputElement;
      File f = el.files[0];
      Blob blob = await compress(f);
      print("finished");
    });

  document.body.children.add(fileInput);
}

Future<Blob> compress(File f) {
  Completer<Blob> completer = new Completer<Blob>();

  FileReader reader = new FileReader();
  reader.readAsDataUrl(f);

  reader.onLoadEnd.listen((ProgressEvent ev) {
    ImageElement img = Element.img();
    img.src = reader.result;
    img.onLoad.listen((Event ev) {
      CanvasElement canvas = Element.canvas();
      canvas.width = img.width ~/ 4;
      canvas.height = img.height ~/ 4;
      CanvasRenderingContext2D context = canvas.getContext("2d");
      context.drawImageToRect(img, Rectangle(0, 0, canvas.width, canvas.height),
          sourceRect: Rectangle(0, 0, img.width, img.height));
      String dataUrl = canvas.toDataUrl("image/jpeg", 0.4);

      return completer.complete(dataURItoBlob(dataUrl));
    });
  });

  return completer.future;
}

Blob dataURItoBlob(String base64) {
  List<String> arr = base64.split(",");
  RegExp exp = new RegExp(r":(.*?);");

  String mime = exp.allMatches(arr[0]).elementAt(0).group(1);
  String bstr = window.atob(arr[1]);
  int n = bstr.length;
  Uint8List u8arr = Uint8List(n);

  while (n-- > 0) u8arr[n] = bstr.codeUnitAt(n);

  return new Blob([u8arr], mime);
}

// dynamic compress()
