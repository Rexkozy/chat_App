import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImage extends StatefulWidget {
  UserImage(this.imagePickFn);

  final void Function(File pickedImage) imagePickFn;

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  File? _pickedImage;

  Future _pickimage() async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImageFile == null) {
      return;
    }
    final imageTemporary = File(pickedImageFile.path);
    setState(() {
      _pickedImage = imageTemporary;
    });
    widget.imagePickFn(imageTemporary);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        TextButton.icon(
          onPressed: _pickimage,
          icon: Icon(Icons.add_a_photo),
          label: const Text("Add Image"),
        )
      ],
    );
  }
}
