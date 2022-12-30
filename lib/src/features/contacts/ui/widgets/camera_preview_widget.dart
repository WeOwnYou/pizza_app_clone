import 'package:camera/camera.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_colors.dart';
import 'package:flutter/material.dart';

class CameraPreviewWidget extends StatefulWidget {
  final double previewSize;
  final void Function() onTap;
  const CameraPreviewWidget({
    Key? key,
    required this.previewSize,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image;

  @override
  void initState() {
    _loadCamera();
    super.initState();
  }

  Future<void> _loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(
        cameras![0],
        ResolutionPreset.max,
        enableAudio: false,
      );

      await controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          SizedBox(
            width: widget.previewSize,
            height: widget.previewSize,
            child: !(controller?.value.isInitialized ?? false)
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : CameraPreview(controller!),
          ),
          const Center(
            child: Icon(
              Icons.camera_alt,
              size: 40,
              color: AppColors.mainBgOrange,
            ),
          )
        ],
      ),
    );
  }
}
