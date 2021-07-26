import 'dart:io';
import 'package:images_picker/images_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  Future<List<String>> uploadImages(List<File> images) async {
    List<String> downloadUrls = [];
    await Future.forEach(images, (File image) async {
      String storagePath = 'crime/images/' + Path.basename(image.path);

      Reference storageReference = FirebaseStorage.instance.ref().child(storagePath);
      UploadTask storageUploadTask = storageReference.putFile(image);
      await storageUploadTask.whenComplete(
        () => {
          print('upload complete'),
        },
      );

      String url = await storageReference.getDownloadURL();
      downloadUrls.add(url);
    });
    return downloadUrls;
  }

  List<File> convertMediaToFile(List<Media> medias) {
    List<File> files = [];
    medias.forEach((media) {
      File file = File(media.path);
      files.add(file);
    });

    return files;
  }
}