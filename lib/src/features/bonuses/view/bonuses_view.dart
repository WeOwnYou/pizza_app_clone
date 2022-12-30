import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dodo_clone/src/core/ui/navigation/service/router.dart';
import 'package:dodo_clone/src/core/ui/utils/extensions/int_extensions.dart';
import 'package:dodo_clone/src/core/ui/utils/res/res.dart';
import 'package:dodo_clone/src/features/bonuses/bloc/bonuses_bloc.dart';
import 'package:dodo_clone/src/features/bonuses/view/bonuses_history_view.dart';
import 'package:dodo_clone/src/features/bonuses/widgets/widgets.dart';
import 'package:dodo_clone/src/features/main/address_cubit/address_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// const _itemHeight = 220.0;
const _itemWidth = 200.0;

class BonusesView extends StatelessWidget {
  final BuildContext parentContext;
  const BonusesView({Key? key, required this.parentContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Возможно связать с локализацией
    final cityUrl =
        parentContext.read<AddressCubit>().state.selectedCity?.id == 1
            ? 'moscow'
            : 'tambov';
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          color: Colors.white,
          onPressed: AppRouter.instance().popTop,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            onPressed: () {
              launchUrl(
                Uri(
                  scheme: 'https',
                  host: 'dodopizza.ru',
                  path: '$cityUrl/loyaltyprogram',
                ),
                mode: LaunchMode.inAppWebView,
              );
            },
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Image.asset(
            AppImages.splashImage,
            fit: BoxFit.fitHeight,
            height: MediaQuery.of(context).size.height,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.mainBluePurple,
                  AppColors.bgLightOrange.withOpacity(0.93),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.54, 0.9],
              ),
            ),
          ),
          BlocBuilder<BonusesBloc, BonusesState>(
            builder: (context, state) {
              final lowestCoinsPrice =
                  state.loyaltyOffers.firstOrNull?.coinsPrice ?? 0;
              switch (state.status) {
                case BonusesStateStatus.loading:
                  return const Center(
                    child: CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  );
                case BonusesStateStatus.failure:
                  return const Center(
                    child: Text(
                      'Что-то пошло не так, попробуйте позже',
                      style: TextStyle(color: Colors.white, fontSize: 19),
                    ),
                  );
                case BonusesStateStatus.success:
                  final bonus = state.numberOfOffersInCart % 10 == 1
                      ? 'бонусный'
                      : 'бонусных';
                  final products = state.numberOfOffersInCart
                      .declension('товар', 'товара', 'товаров');
                  return Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1,
                    ),
                    child: Column(
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.8,
                          child: ListTile(
                            title: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 5,
                                    right: 5,
                                  ),
                                  child: Text(
                                    'У вас ${state.availableCoins}',
                                    style: const TextStyle(fontSize: 32),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Transform.rotate(
                                  angle: pi / 6,
                                  child: const FaIcon(
                                    FontAwesomeIcons.bitcoin,
                                    size: 25,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: state.numberOfOffersInCart == 0
                                ? Text(
                                    (state.availableCoins >= lowestCoinsPrice)
                                        ? 'Выберите на что потратить'
                                        : 'Нужно накопить еще немного',
                                    textAlign: TextAlign.center,
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            kMainBorderRadius / 2,
                                          ),
                                          color: Colors.white,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        child: Text(
                                          '${state.numberOfOffersInCart}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '$bonus $products в корзине',
                                      )
                                    ],
                                  ),
                            tileColor: Colors.white,
                            textColor: Colors.white,
                            iconColor: AppColors.mainBgOrange,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.1,
                          ),
                          height: _itemWidth * 1.3,
                          child: ScrollSnapList(
                            itemBuilder: (ctx, index) => ProductCategoryCard(
                              itemWidth: _itemWidth,
                              itemHeight: _itemWidth * 1.1,
                              loyaltyOffersBlock: state.loyaltyOffers[index],
                              availableCoins: state.availableCoins,
                              parentContext: context,
                            ),
                            duration: 200,
                            itemCount: state.loyaltyOffers.length,
                            itemSize: _itemWidth,
                            onItemFocus: (_) {},
                            dynamicItemSize: true,
                            updateOnScroll: true,
                          ),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.receipt_long_outlined,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'История',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: const Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                          ),
                          // TODO(mes): добавить историю (как запрос и  страницу)
                          onTap: () {
                            context
                                .read<BonusesBloc>()
                                .add(const BonusHistoryInitializeEvent());
                            showGeneralDialog(
                              context: context,
                              barrierColor: Colors.transparent,
                              transitionDuration:
                                  const Duration(milliseconds: 200),
                              transitionBuilder:
                                  (context, animation, _, child) {
                                const begin = Offset(1.0, 0);
                                const end = Offset.zero;
                                const curve = Curves.ease;

                                final tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                              pageBuilder: (_, __, ___) {
                                return BonusesHistoryView(
                                  parentContext: context,
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  );
              }
            },
          )
        ],
      ),
    );
  }
}
