import 'package:Projetao3/infrastructure/cartaServico.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import './database_integration.dart';

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

      return await task.whenComplete(() async {
        imageURL = await this.getImageURL(uid, tipo, datetime);
        print(imageURL);
      }).then((value) {
        return imageURL;
      });
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

    final usuarioController = UsuarioController();
    bool usuarioIsInDatabase = await usuarioController.usuarioIsInDatabase(uid);

    if (usuarioIsInDatabase) {
      try {
        CartaServicos cartaServicos =
            await usuarioController.getUsuarioCartaServicos(uid);
        Servico servico = cartaServicos.getServico(tipo);
        images = servico.imagens;
        return images;
      } catch (e) {
        print(e);
        print("Foi encontrado um erro e nenhuma imagem foi encontrada.");
        return images;
      }
    }
    print("Nenhuma imagem foi encontrada");
    return images;

    // Reference storagereference =
    //     FirebaseStorage.instance.ref('Servicos').child(uid).child(tipo);

    // ListResult listResult = await storagereference.listAll();
    // listResult.items.forEach((imgReference) async {
    //   String imgURL = await imgReference.getDownloadURL();
    //   images.add(imgURL);
    // });

    // return images;
  }
}
