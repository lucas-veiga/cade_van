import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/default_padding.dart';
import '../../widgets/fade_in.dart';

class ChildDetailPage extends StatefulWidget {
  final int index;
  final List<CameraDescription> cameras;

  ChildDetailPage(this.index, this.cameras);

  @override
  _ChildDetailPageState createState() => _ChildDetailPageState();
}

class _ChildDetailPageState extends State<ChildDetailPage> {
  final bool startToAnimate = true;
  CameraController controller;
  String imagePath;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void activateCamera() {
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  child: Hero(
                    tag: 'child_avatar_${widget.index}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(500),
                      child: CircleAvatar(
                        backgroundColor: imagePath != null ? Colors.transparent : null,
                        child: imagePath != null ? Image.file(File(imagePath)) : null,
                        radius: 100,
                      ),
                    ),
                  ),
                  onTap: activateCamera,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 210,
                  left: DefaultPadding.horizontal,
                  right: DefaultPadding.horizontal),
              child: ListView(
                children: <Widget>[
                  FadeIn(
                    delay: 1,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Nome da Crianca',
                      ),
                    ),
                  ),
                  FadeIn(
                    delay: 2,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Escola',
                      ),
                    ),
                  ),
                  FadeIn(
                    delay: 2.5,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Periodo',
                      ),
                    ),
                  ),
                  FadeIn(
                    delay: 3,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Nome da Crianca',
                      ),
                    ),
                  ),
                  FadeIn(
                    delay: 3.5,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Idade',
                      ),
                    ),
                  ),
                  FadeIn(
                    delay: 4,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Motorista',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Câmera'),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Center(
                child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller)),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: controller != null && controller.value.isRecordingVideo
                    ? Colors.redAccent
                    : Colors.grey,
                width: 3.0,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.camera_alt),
              color: Colors.blue,
              onPressed: controller != null &&
                      controller.value.isInitialized &&
                      !controller.value.isRecordingVideo
                  ? onTakePictureButtonPressed
                  : null,
            ),
          ],
        )
      ]),
    );
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          controller = null;
          print(imagePath);
        });
        if (filePath != null) return null;
      }
    });
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
//    logError(e.code, e.description);
//    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Widget _buildForm(AsyncSnapshot snap) {
    if (snap.connectionState == ConnectionState.done) {
      return Padding(
        padding: EdgeInsets.only(
            top: 200,
            left: DefaultPadding.horizontal,
            right: DefaultPadding.horizontal),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Nome da Crianca',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Escola',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Periodo',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nome da Crianca',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Idade',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Motorista',
              ),
            ),
          ],
        ),
      );
    }
    return Center(child: CircularProgressIndicator());
  }
}
