import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

Future<Blob> compress(dynamic f, {int scale: 4, num quality: 0.4}) {
  Completer<Blob> completer = new Completer<Blob>();

  FileReader reader = new FileReader();
  reader.readAsDataUrl(f as File);

  reader.onLoadEnd.listen((ProgressEvent ev) {
    ImageElement img = Element.img();
    img.src = reader.result;
    img.onLoad.listen((Event ev) {
      CanvasElement canvas = Element.canvas();
      canvas.width = img.width ~/ scale;
      canvas.height = img.height ~/ scale;
      CanvasRenderingContext2D context = canvas.getContext("2d");
      context.drawImageToRect(img, Rectangle(0, 0, canvas.width, canvas.height),
          sourceRect: Rectangle(0, 0, img.width, img.height));
      String dataUrl = canvas.toDataUrl("image/jpeg", quality);

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
