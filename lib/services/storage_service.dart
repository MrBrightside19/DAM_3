import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  var storageReference = FirebaseStorage.instance;
  Future putUserImage(image, uid) async {
    var ref = storageReference.ref().child('profiles/$uid');
    var uploadTask = ref.child('profile.jpg').putFile(image);
    return uploadTask;
  }

  Future<String> getUserUrl(uid) async {
    return storageReference.ref('profiles/$uid/profile.jpg').getDownloadURL();
  }

  Future<void> writeImage(imagen, uid) async {
    await FirebaseStorage.instance
        .ref('profiles/$uid/profile.jpg')
        .writeToFile(imagen);
  }
}
