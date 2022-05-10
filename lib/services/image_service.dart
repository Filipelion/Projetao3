import 'dart:async';

import 'package:Projetao3/core/locator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:Projetao3/models/professional_skill.dart';
import 'package:Projetao3/models/professional_skills_list.dart';
import 'dart:io';

import 'package:Projetao3/repository/shared/tables_name.dart';
import 'package:Projetao3/repository/user_repository.dart';

class ImageService {
  final String _skillsTable = TablesName.Skills;
  final UserRepository _userRepository = locator<UserRepository>();
  final ImagePicker _picker = ImagePicker();

  Future<File?> getImage(ImageSource source) async {
    final imageFile = await _picker.pickImage(source: source);

    if (imageFile != null) {
      return File(imageFile.path);
    }
  }

  Future<String?> sendImage(ImageSource source, String tipo, String uid) async {
    File? imageFile = await this.getImage(source);
    String dateTime = DateTime.now().millisecondsSinceEpoch.toString();

    if (imageFile != null) {
      String imageURL = "";

      UploadTask task = FirebaseStorage.instance
          .ref(_skillsTable)
          .child(uid)
          .child(tipo)
          .child(dateTime)
          .putFile(imageFile);

      return await task.whenComplete(() async {
        imageURL = await this.getImageURL(uid, tipo, dateTime);
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
        .ref(_skillsTable)
        .child(uid)
        .child(tipo)
        .child("$datetime")
        .getDownloadURL();

    return downloadURL;
  }

  FutureOr<List> getServiceImages(String uid, String tipo) async {
    late List images;

    bool exists = await _userRepository.userExists(uid);

    if (exists) {
      try {
        ProfessionalSkillsList skillsData =
            await _userRepository.getUserSkillsList(uid);

        ProfessionalSkill servico = skillsData.list.firstWhere(
          (skill) => skill.name == tipo,
        );

        images = servico.images ?? [];

        return images;
      } catch (e) {
        print(e);
        print("Foi encontrado um erro e nenhuma imagem foi encontrada.");
        return images;
      }
    }
    print("Nenhuma imagem foi encontrada");
    return [];

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
