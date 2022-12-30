import 'package:dodo_clone/src/core/ui/utils/extensions/int_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/res/res.dart';
import 'package:flutter/material.dart';

class PriceWidget extends StatelessWidget {
  final int price;
  final bool isFixed;
  final VoidCallback? onTap;
  final bool isRubles;
  final bool active;
  const PriceWidget({
    required this.price,
    required this.isFixed,
    required this.active,
    this.onTap,
    this.isRubles = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: active ? onTap : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: active ? AppColors.secondBgOrange : AppColors.mainBgGrey,
          borderRadius: BorderRadius.circular(
            20,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          child: FittedBox(
            child: Text(
              price == -1 ? 'Будет позже' :
              '${isFixed ? '' : 'от '}${isRubles ? price.rubles : price.coins}',
              style: TextStyle(
                color: active ? AppColors.mainTextOrange : AppColors.mainTextGrey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
