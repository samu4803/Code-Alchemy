// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:camera/camera.dart';
import 'package:codealchemy/backend/backend.dart';
import 'package:codealchemy/essentials/altsnackbar.dart';
import 'package:codealchemy/essentials/backgrounddecorations.dart';
import 'package:codealchemy/essentials/loadinganimation.dart';
import 'package:codealchemy/essentials/nativecamera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? profile;
  String? newName;
  bool submitted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BackgroundDecoration(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.transparent,
                  backgroundImage: profile == null
                      ? Image.network(InitialData.instance.userInfo!["profile"])
                          .image
                      : Image.file(profile!).image,
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        title: Text(
                          "Confirm Delete",
                          style: Theme.of(context).textTheme.titleSmall!,
                        ),
                        content: Text(
                          "on pressing confirm you will permanently delete your profile photo",
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Cancel",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    fontSize: 15,
                                  ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final byteData = await rootBundle
                                  .load('assets/defaultProfile.png');
                              final file = File(
                                  '${(await getTemporaryDirectory()).path}/defaultProfile.png');
                              await file.create(recursive: true);
                              await file.writeAsBytes(byteData.buffer
                                  .asUint8List(byteData.offsetInBytes,
                                      byteData.lengthInBytes));
                              profile = file;
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            child: Text(
                              "Confirm",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    fontSize: 15,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      final XFile? temp = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const NativeCamera(),
                        ),
                      );
                      if (temp != null) {
                        profile = File(temp.path);
                        setState(() {});
                      }
                    },
                    icon: const Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final temp = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        type: FileType.custom,
                        allowedExtensions: [
                          "jpg",
                        ],
                      );
                      if (temp != null) {
                        profile = File(temp.xFiles.first.path);
                        setState(() {});
                      }
                    },
                    icon: const Icon(
                      Icons.add_photo_alternate,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
                vertical: MediaQuery.of(context).size.height * 0.03,
              ),
              child: TextField(
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
                decoration: InputDecoration(
                  label: Text(
                    "New Name",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
                onChanged: (value) {
                  newName = value;
                },
              ),
            ),
            submitted == true
                ? const LoadingAnimation()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() => submitted = true);
                      await editProfile(
                        profile: profile,
                        name: newName,
                      );
                      if (mounted) {
                        altSnackBar(
                          context: context,
                          contentType: ContentType.success,
                          message: "updated profile successfully",
                        );
                      }
                      setState(() => submitted = false);
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "Submit",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
