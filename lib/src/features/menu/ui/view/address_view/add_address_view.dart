import 'dart:async';
import 'dart:math';

import 'package:address_repository/address_repository.dart';
import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/features/menu/bloc/add_address_cubit/add_address_cubit.dart';
import 'package:dodo_clone/src/features/menu/bloc/add_address_cubit/add_address_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAddressFormWidget extends StatelessWidget {
  final BuildContext parentContext;
  const AddAddressFormWidget({required this.parentContext, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => AddAddressCubit(
        parentContext.read<IAddressRepository>(),
        parentContext.read<IAddressRepository>().selectedCity,
        const AddAddressState(),
      )..initialize(),
      child: const AddDeliveryAddressWidget(),
    );
  }
}

class AddDeliveryAddressWidget extends StatelessWidget {
  const AddDeliveryAddressWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddAddressCubit, AddAddressState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight),
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                padding: EdgeInsets.zero,
                splashRadius: 10,
                color: Colors.orange,
                icon: const Icon(Icons.close),
                onPressed: AppRouter.instance().pop,
              ),
              actions: [
                _BuildSaveButton(
                  canSave: state.canSave,
                ),
              ],
              title: const Text('Адрес доставки'),
            ),
            body: ListView.builder(
              itemCount: state.addressMarkers.length,
              padding: const EdgeInsets.only(
                top: 10,
              ),
              itemBuilder: (context, index) {
                if (index == 0) {
                  ///Поле улицы
                  return _BuildDropDownSuggestions(
                    index: index,
                  );
                } else if (index == 1) {
                  ///Поле дома
                  return _BuildAddressTextField(
                    name: state.addressMarkers[index],
                    onChanged: (text) {
                      context
                          .read<AddAddressCubit>()
                          .changeAddress(index, text);
                    },
                  );
                } else {
                  /// Прочие поля
                  return _BuildAddressTextField(
                    name: state.addressMarkers[index],
                    onChanged: (text) {
                      context
                          .read<AddAddressCubit>()
                          .changeAddress(index, text);
                    },
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class _BuildDropDownSuggestions extends StatefulWidget {
  final int index;

  const _BuildDropDownSuggestions({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<_BuildDropDownSuggestions> createState() =>
      _BuildDropDownSuggestionsState();
}

class _BuildDropDownSuggestionsState extends State<_BuildDropDownSuggestions> {
  Timer? _debounce;
  late final TextEditingController controller;
  List<String> result = [];
  bool isSelected = false;
  bool notFound = false;

  void _resetTimer() {
    if (_debounce != null) {
      _debounce!.cancel();
    }
    result.clear();
    _debounce = Timer(const Duration(seconds: 2), () async {
      if (controller.value.text.isNotEmpty) {
        result = await context
            .read<AddAddressCubit>()
            .updateStreet(controller.value.text);
        notFound = result.isEmpty;
        setState(() {});
      }
    });
    setState(() {});
  }

  void _onValueTap(int index) {
    controller.text = result[index - 1];
    isSelected = true;
    result = [];
    context.read<AddAddressCubit>().changeAddress(0, controller.value.text);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController()
      ..addListener(() {
        if (controller.value.text.isEmpty) {
          isSelected = false;
          result = [];
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddAddressCubit, AddAddressState>(
      builder: (context, state) {
        return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          primary: false,
          itemCount:
              (_debounce?.isActive ?? false) ? 2 : max(2, result.length + 1),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return _BuildAddressTextField(
                  name: state.addressMarkers[widget.index],
                  controller: controller,
                  onChanged: (text) {
                    _resetTimer();
                  },
                  isBlocked: isSelected,
                );
              case 1:
                if (controller.value.text.isEmpty || isSelected) {
                  return const SizedBox.shrink();
                } else if ((_debounce?.isActive ?? false) &&
                    controller.value.text.isNotEmpty) {
                  return const _BuildMessageCloudWidget(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator.adaptive(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (notFound) {
                  return SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 20,
                    child: _BuildMessageCloudWidget(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Место не найдено',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Проверьте правильность написания',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      _onValueTap(index);
                    },
                    child: _BuildMessageCloudWidget(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                        child: Text(result[index - 1]),
                      ),
                    ),
                  );
                }
              default:
                return GestureDetector(
                  onTap: () {
                    _onValueTap(index);
                  },
                  child: ColoredBox(
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      child: Text(result[index - 1]),
                    ),
                  ),
                );
            }
          },
        );
      },
    );
  }
}

class _BuildMessageCloudWidget extends StatelessWidget {
  final Widget child;
  const _BuildMessageCloudWidget({required this.child, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CustomShape(Colors.grey.shade200),
      child: child,
    );
  }
}

class _BuildAddressTextField extends StatelessWidget {
  final String name;
  final void Function(String text)? onChanged;
  final TextEditingController? controller;
  final bool isBlocked;
  const _BuildAddressTextField({
    Key? key,
    required this.name,
    this.onChanged,
    this.isBlocked = false,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        controller: controller,
        readOnly: isBlocked,
        cursorColor: Colors.orangeAccent,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: controller?.value.text.isEmpty ?? true
              ? null
              : IconButton(
                  icon: const Icon(Icons.close_rounded),
                  color: Colors.orangeAccent,
                  onPressed: () {
                    context.read<AddAddressCubit>().changeAddress(0, '');
                    controller!.clear();
                  },
                ),
          labelText: name,
          labelStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _BuildSaveButton extends StatelessWidget {
  final bool canSave;
  const _BuildSaveButton({
    Key? key,
    required this.canSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canSave
          ? () {
              context.read<AddAddressCubit>().saveAddress();
            }
          : null,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: kFloatingActionButtonMargin),
          child: Text(
            'Сохранить',
            style:
                TextStyle(color: canSave ? Colors.orangeAccent : Colors.grey),
          ),
        ),
      ),
    );
  }
}

class CustomShape extends CustomPainter {
  final Color bgColor;

  CustomShape(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = bgColor;

    final path = Path()
      ..lineTo(20, 0)
      ..lineTo(25, -7)
      ..lineTo(30, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..lineTo(0, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
