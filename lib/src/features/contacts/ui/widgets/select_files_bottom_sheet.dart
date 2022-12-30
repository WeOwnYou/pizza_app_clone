import 'dart:async';
import 'dart:typed_data';

import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_colors.dart';
import 'package:dodo_clone/src/core/ui/widgets/corporate_button.dart';
import 'package:dodo_clone/src/features/contacts/bloc/contacts_cubit.dart';
import 'package:dodo_clone/src/features/contacts/ui/utils/constants.dart';
import 'package:dodo_clone/src/features/contacts/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:person_repository/person_repository.dart';
import 'package:photo_manager/photo_manager.dart';

class SelectFilesBottomSheet extends StatefulWidget {
  final BuildContext parentContext;
  final List<AssetEntity> recentImages;
  const SelectFilesBottomSheet({
    required this.parentContext,
    Key? key,
    required this.recentImages,
  }) : super(key: key);

  @override
  State<SelectFilesBottomSheet> createState() => _SelectFilesBottomSheetState();
}

class _SelectFilesBottomSheetState extends State<SelectFilesBottomSheet> {
  List<AssetEntity> selectedImages = [];
  bool shouldShowPreview = true;
  @override
  Widget build(BuildContext context) {
    final addImage = widget.parentContext.read<ContactsCubit>().addImages;
    return BlocBuilder<ContactsCubit, ContactsState>(
      bloc: BlocProvider.of(widget.parentContext),
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height *
              (widget.recentImages.isNotEmpty ? 0.373 : 0.2),
          color: AppColors.mainBgGrey,
          child: Column(
            children: [
              if (widget.recentImages.isNotEmpty)
                SizedBox(
                  height: supportChatPictureSize,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      late final int imageIndex;
                      if (shouldShowPreview) {
                        imageIndex = index - 1;
                      } else {
                        imageIndex = index;
                      }
                      final isImageSelected =
                          // ignore: avoid_bool_literals_in_conditional_expressions
                          index == 0
                              ? false
                              : selectedImages
                                  .contains(widget.recentImages[imageIndex]);
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 3,
                        ),
                        width: supportChatPictureSize,
                        child: index == 0 && shouldShowPreview
                            ? CameraPreviewWidget(
                                previewSize: supportChatPictureSize,
                                onTap: () async {
                                  setState(() {
                                    shouldShowPreview = false;
                                  });
                                  final image = await ImagePicker()
                                      .pickImage(source: ImageSource.camera);
                                  if (image != null) {
                                    await addImage(
                                      chatImages: [
                                        ChatImage.fromState(
                                          byteImage: await image.readAsBytes(),
                                        )
                                      ],
                                    );
                                  }
                                  if (image != null) {
                                    await AppRouter.instance().pop();
                                  } else {
                                    setState(() {
                                      shouldShowPreview = true;
                                    });
                                  }
                                },
                              )
                            : ImageItemWidget(
                                selected: isImageSelected,
                                onTap: () async {
                                  if (isImageSelected) {
                                    setState(() {
                                      selectedImages.remove(
                                        widget.recentImages[imageIndex],
                                      );
                                    });
                                  } else {
                                    setState(() {
                                      selectedImages
                                          .add(widget.recentImages[imageIndex]);
                                    });
                                  }
                                },
                                entity: widget.recentImages[imageIndex],
                                option: ThumbnailOption(
                                  size: ThumbnailSize.square(
                                    supportChatPictureSize.toInt(),
                                  ),
                                ),
                              ),
                      );
                    },
                    itemCount: widget.recentImages.length + 1,
                  ),
                ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.13,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BuildAddFileButtonWidget(
                      icon: Icons.image,
                      text: 'Галеерея',
                      onPressed: () async {
                        final xFileImages =
                            await ImagePicker().pickMultiImage();
                        if (xFileImages.isNotEmpty) {
                          final uint8ListImages = <Uint8List>[];
                          for (final image in xFileImages) {
                            uint8ListImages.add(await image.readAsBytes());
                          }
                          await addImage(
                            chatImages: uint8ListImages
                                .map((e) => ChatImage.fromState(byteImage: e))
                                .toList(),
                          );
                        }
                        if (xFileImages.isNotEmpty) {
                          await AppRouter.instance().pop();
                        }
                      },
                    ),
                    BuildAddFileButtonWidget(
                      icon: Icons.file_copy,
                      text: 'Файл',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              if (widget.recentImages.isNotEmpty)
                CorporateButton(
                  margin: EdgeInsets.zero,
                  onTap: () async {
                    if (selectedImages.isEmpty) {
                      selectedImages = [];
                    } else {
                      await addImages();
                    }
                    unawaited(AppRouter.instance().popTop());
                  },
                  isActive: true,
                  backgroundColor: selectedImages.isEmpty
                      ? Colors.white
                      : AppColors.mainBgOrange,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        selectedImages.isEmpty ? 'Отменить' : 'Добавить',
                        style: TextStyle(
                          color: selectedImages.isEmpty
                              ? AppColors.mainBgOrange
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (selectedImages.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              '${selectedImages.length}',
                              style: const TextStyle(
                                color: AppColors.mainBgOrange,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  widthFactor: 0.95,
                )
            ],
          ),
        );
      },
    );
  }

  Future<void> addImages() async {
    final addImages = widget.parentContext.read<ContactsCubit>().addImages;
    final images = <Uint8List>[];
    for (final image in selectedImages) {
      final uint8ListImage =
          await image.thumbnailDataWithSize(const ThumbnailSize(600, 600));
      if (uint8ListImage != null) {
        images.add(uint8ListImage);
      }
    }
    await addImages(
      chatImages: images.map((e) => ChatImage.fromState(byteImage: e)).toList(),
    );
  }
}

class BuildAddFileButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function() onPressed;
  const BuildAddFileButtonWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: MaterialButton(
        onPressed: onPressed,
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.mainBgOrange,
              size: 60,
            ),
            Text(
              text,
              style: const TextStyle(color: Colors.orange),
            )
          ],
        ),
      ),
    );
  }
}
