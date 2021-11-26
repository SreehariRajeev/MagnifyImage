import 'package:image_picker/image_picker.dart';

class CameraServices {
  static Future cameraPickImage() {
    ImagePicker _picker = ImagePicker();
    return _picker.pickImage(source: ImageSource.camera);
  }
}
