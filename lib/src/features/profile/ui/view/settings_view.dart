import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_colors.dart';
import 'package:dodo_clone/src/core/ui/utils/res/app_sizes.dart';
import 'package:dodo_clone/src/core/ui/widgets/corporate_button.dart';
import 'package:dodo_clone/src/core/ui/widgets/dodo_text_button.dart';
import 'package:dodo_clone/src/features/profile/bloc/profile_bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SettingsView extends StatefulWidget {
  final BuildContext parentContext;
  const SettingsView({required this.parentContext, Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ModalScrollController.of(context)?.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ModalScrollController.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: scrollController != null &&
                  scrollController.hasClients &&
                  scrollController.offset > 37
              ? const Text('Настройки')
              : null,
          actions: [
            Padding(
              padding: const EdgeInsets.all(kMainHorizontalPadding),
              child: DodoTextButton(
                onTap: AppRouter.instance().popTop,
                text: 'Готово',
                size: 16,
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            const _BuildMainInfoWidget(),
            const Divider(
              thickness: 15,
              color: AppColors.mainBgGrey,
            ),
            const _BuildPushSettingsWidget(),
            const Divider(
              thickness: 15,
              color: AppColors.mainBgGrey,
            ),
            _BuildExitBlockWidget(
              onDeleteAccountTap: () => widget.parentContext
                  .read<ProfileBloc>()
                  .add(DeleteAccountEvent()),
              onExitTap: () {
                debugPrint('need to realise');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildMainInfoWidget extends StatelessWidget {
  const _BuildMainInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: kMainHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Настройки',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          _BuildInputTextFormField(
            labelText: 'Имя',
            initialValue: 'Михаил',
          ),
          _BuildInputTextFormField(
            labelText: 'Телефон',
            initialValue: '+7 915 666-69-15',
          ),
          _BuildInputTextFormField(
            labelText: 'Почта',
            initialValue: 'mihailvezettambov@gmail.com',
          ),
          _BuildInputTextFormField(
            labelText: 'День рождения',
            initialValue: '22 октября',
            enableBorder: false,
          ),
        ],
      ),
    );
  }
}

class _BuildPushSettingsWidget extends StatelessWidget {
  const _BuildPushSettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: kMainHorizontalPadding,
        right: kMainHorizontalPadding,
        top: kMainHorizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Уведомления',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const FittedBox(
              child: Text('Персональные предложения и акции'),
            ),
            subtitle: const FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.7,
              child: FittedBox(
                child: Text('Пуш-уведомления, почта, смс'),
              ),
            ),
            trailing: Switch.adaptive(
              value: true,
              onChanged: (value) {},
              activeColor: AppColors.mainBgOrange,
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildExitBlockWidget extends StatelessWidget {
  final VoidCallback? onDeleteAccountTap;
  final VoidCallback? onExitTap;
  const _BuildExitBlockWidget({
    this.onDeleteAccountTap,
    this.onExitTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(kMainHorizontalPadding),
            child: GestureDetector(
              onTap: onDeleteAccountTap,
              child: const Text(
                'Удалить аккаунт',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        CorporateButton(
          isActive: false,
          child: const Text('Выход'),
          widthFactor: 0.9,
          onTap: onExitTap,
          backgroundColor: AppColors.mainBgGrey,
          foregroundColor: AppColors.mainIconGrey,
        ),
      ],
    );
  }
}

class _BuildInputTextFormField extends StatelessWidget {
  final String labelText;
  final String initialValue;
  final bool enableBorder;
  const _BuildInputTextFormField({
    required this.labelText,
    required this.initialValue,
    this.enableBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final border = enableBorder
        ? const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.mainBgGrey,
              width: 2,
            ),
          )
        : InputBorder.none;
    return TextFormField(
      cursorColor: Colors.orangeAccent,
      initialValue: initialValue,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          top: 20,
          bottom: 5,
        ),
        labelText: labelText,
        labelStyle: const TextStyle(color: AppColors.mainIconGrey),
        enabledBorder: border,
        focusedBorder: border,
      ),
    );
  }
}
