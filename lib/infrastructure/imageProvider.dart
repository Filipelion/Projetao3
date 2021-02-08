import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class OiaImageProvider {
  Future<File> getImage(ImageSource source) async {
    final imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile == null) return null;
    return imageFile;
  }

  Future<String> sendImage(ImageSource source, String tipo, String uid) async {
    File imageFile = await this.getImage(source);

    String datetime = DateTime.now().millisecondsSinceEpoch.toString();

    if (imageFile != null) {
      String imageURL = "";

      UploadTask task = FirebaseStorage.instance
          .ref("Servicos")
          .child(uid)
          .child(tipo)
          .child(datetime)
          .putFile(imageFile);

      task.whenComplete(
          () async => imageURL = await this.getImageURL(uid, tipo, datetime));
      return imageURL;
    }
    return null;
  }

  Future<String> getImageURL(String uid, String tipo, String datetime) async {
    /* Método responsável por recuperar o link da imagem */
    String downloadURL = await FirebaseStorage.instance
        .ref('Servicos')
        .child(uid)
        .child(tipo)
        .child("$datetime")
        .getDownloadURL();

    return downloadURL;
  }

  Future<List> getAllImagesOfAService(String uid, String tipo) async {
    List images = [];

    Reference storagereference =
        FirebaseStorage.instance.ref('Servicos').child(uid).child(tipo);

    ListResult listResult = await storagereference.listAll();
    listResult.items.forEach((imgReference) async {
      String imgURL = await imgReference.getDownloadURL();
      images.add(imgURL);
    });

    return images;
  }
}
