import 'dart:io';

import 'package:badges/badges.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/core/ui/utils/extensions/connectivity_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_colors.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_images.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_sizes.dart';
import 'package:dodo_clone/src/core/ui/widgets/corporate_button.dart';
import 'package:dodo_clone/src/features/contacts/bloc/contacts_cubit.dart';
import 'package:dodo_clone/src/features/contacts/domain/entity/message.dart';
import 'package:dodo_clone/src/features/contacts/ui/utils/contacts_lifecycle_manager.dart';
import 'package:dodo_clone/src/features/contacts/ui/view/support_chat_view.dart';
import 'package:dodo_clone/src/features/main/ui/custom_paint/contacts_trapezoid.g.dart';
import 'package:dodo_clone/src/features/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactsView extends StatelessWidget {
  static const title = 'Контакты';
  static Widget androidIcon(bool selected) =>
      _BuildContactsIcon(selected: selected);
  static Widget iosIcon(bool selected) =>
      _BuildContactsIcon(selected: selected);

  const ContactsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final callButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppColors.secondBgOrange,
      foregroundColor: AppColors.mainTextOrange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(200),
      ),
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 10),
    );
    final contactsCubit = context.read<ContactsCubit>();
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        final hasInternet = snapshot.data.hasInternet;
        contactsCubit.updateInternetStatus(hasInternet: hasInternet);
        return ContactsLifecycleManager(
          child: BlocBuilder<ContactsCubit, ContactsState>(
            buildWhen: (oldState, newState) {
              if (oldState.chatState == ChatState.disabled &&
                  newState.chatState == ChatState.active) {
                _openSupportChat(context);
              }
              return oldState.messages != newState.messages;
            },
            builder: (context, state) => Scaffold(
              body: SafeArea(
                child: ListView(
                  padding: const EdgeInsets.all(kMainHorizontalPadding),
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(250 / 2),
                          child: const ColoredBox(
                            color: AppColors.mainBgGrey,
                            child: FlutterLogo(
                              size: 250,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: CorporateButton(
                            isActive: true,
                            child: const Text('Пиццерии на карте'),
                            onTap: () {
                              launchUrlString(
                                'https://yandex.ru/maps/?um=constructor%3A071caf5edd6c7c8a2885dc81e8f7494273f6e3cc28b3bffba86aa869f7c1bc85&source=constructorLink',
                              );
                            },
                            widthFactor: 0.7,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Связаться с поддержкой',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: FractionallySizedBox(
                            widthFactor: 0.9,
                            child: ElevatedButton(
                              onPressed: () {
                                _launchURL(phone: 'tel:+78005553535');
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(3.0),
                                child: Text('Позвонить'),
                              ),
                              style: callButtonStyle,
                            ),
                          ),
                        ),
                        Expanded(
                          child: BlocBuilder<ProfileBloc, ProfileState>(
                            buildWhen: (oldState, newState) {
                              return oldState.person != newState.person;
                            },
                            builder: (context, profileState) {
                              // print(AppsListScreen());
                              final unreadMessages =
                                  state.messages.unreadMessages(
                                context.read<ProfileBloc>().state.person.id,
                              );
                              return Badge(
                                showBadge: unreadMessages.isNotEmpty &&
                                    profileState.person.isNotEmpty,
                                position: const BadgePosition(top: 0, end: 0),
                                badgeContent:
                                    Text(unreadMessages.length.toString()),
                                child: FractionallySizedBox(
                                  widthFactor: 0.9,
                                  child: ElevatedButton(
                                    onPressed: () => hasInternet
                                        ? contactsCubit.initChat()
                                        : null,
                                    child: const Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Text('Написать в чат'),
                                    ),
                                    style: callButtonStyle,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: SvgPicture.asset(AppImages.vkImageSvg),
                            onPressed: () async {
                              await _launchURL(
                                host: 'vk.com',
                                path: 'dodo',
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: SvgPicture.asset(AppImages.youtubeImageSvg),
                            onPressed: () async {
                              await _launchURL(
                                host: 'youtube.com',
                                path: 'c/DodoPizzaRussia',
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    ListTile(
                      title: const Text('Правовые документы'),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        AppRouter.instance()
                            .navigate(const LegalDocumentsRoute());
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('О приложении'),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        AppRouter.instance().navigate(const AboutAppRoute());
                      },
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchURL({
    String? host,
    String? path,
    String? phone,
  }) async {
    assert(
      (host != null && path != null) ^ (phone != null),
      'Should be provided host & path or phone',
    );
    if (phone != null) {
      await launchUrlString('tel:78005553535');
      return;
    }
    const scheme = 'https';
    final uri = Uri(scheme: scheme, host: host, path: path);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: Platform.isAndroid
            ? LaunchMode.externalApplication
            : LaunchMode.inAppWebView,
      );
    }
  }

  void _openSupportChat(BuildContext context) {
    showModalBottomSheet<void>(
      useRootNavigator: true,
      isScrollControlled: true,
      context: context,
      builder: (_) => SupportChatView(
        parentContext: context,
      ),
    ).then((_) {
      context.read<ContactsCubit>().onDisposed();
    });
  }
}

class _BuildContactsIcon extends StatelessWidget {
  const _BuildContactsIcon({
    Key? key,
    required this.selected,
  }) : super(key: key);

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (selected)
          Positioned(
            left: 1,
            bottom: 0,
            child: CustomPaint(
              painter: ContactsTrapezoid(),
              size: const Size(24, 6),
            ),
          ),
        const Icon(Icons.location_on),
      ],
    );
  }
}

