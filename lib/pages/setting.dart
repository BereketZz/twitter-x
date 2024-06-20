import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter/providers/user_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController _nameField = TextEditingController();
    LocalUser currentUser = ref.watch(userProvider);
    _nameField.text = currentUser.user.name;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Settings",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GestureDetector(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    // Pick an image.
                    final XFile? imagePicked = await picker.pickImage(
                        source: ImageSource.gallery,
                        requestFullMetadata: false);

                    if (imagePicked != null) {
                      ref
                          .read(userProvider.notifier)
                          .updateImage(File(imagePicked.path));
                    }
                  },
                  child: CircleAvatar(
                    radius: 100,
                    foregroundImage: NetworkImage(currentUser.user.profilePic),
                  )),
              SizedBox(
                height: 10,
              ),
              Center(child: Text("Tap to change image")),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Enter your name",
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blue), // Blue border on focus
                  ),
                  labelStyle: TextStyle(color: Colors.blue),
                ),
                controller: _nameField,
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  ref.read(userProvider.notifier).updateUser(_nameField.text);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Update",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
