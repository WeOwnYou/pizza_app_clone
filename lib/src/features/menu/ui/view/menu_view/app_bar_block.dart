part of 'menu_view.dart';

class _BuildAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const _BuildAppBarWidget({Key? key}) : super(key: key);

  Future<void> _androidBonusViewBuilder(BuildContext context) {
    final shoppingCartCubitState = context.read<ShoppingCartCubit>().state;
    return showMaterialModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => BlocProvider(
        // lazy: false,
        child: BonusesView(
          parentContext: context,
        ),
        create: (ctx) => BonusesBloc(
          dodoCloneRepository: context.read<IDodoCloneRepository>(),
          personRepository: context.read<PersonRepository>(),
        )..add(
          BonusesInitializeEvent(
            coinsInCart:
            shoppingCartCubitState.shoppingCartProducts.coinsSpent,
            numberOfBonusOffersInCart: shoppingCartCubitState
                .shoppingCartProducts.numberOfBonusesInCart,
          ),
        ),
      ),
    );
  }

  Future<void> _iosBonusViewBuilder(BuildContext context) {
    final shoppingCartCubitState = context.read<ShoppingCartCubit>().state;
    return showCupertinoModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => BlocProvider(
        child: BonusesView(
          parentContext: context,
        ),
        // lazy: false,
        create: (ctx) => BonusesBloc(
          dodoCloneRepository: context.read<IDodoCloneRepository>(),
          personRepository: context.read<PersonRepository>(),
        )..add(
          BonusesInitializeEvent(
            coinsInCart:
            shoppingCartCubitState.shoppingCartProducts.coinsSpent,
            numberOfBonusOffersInCart: shoppingCartCubitState
                .shoppingCartProducts.numberOfBonusesInCart,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kMainHorizontalPadding),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet<int?>(
                  backgroundColor: Colors.transparent,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  context: context,
                  builder: (_) => SelectCityModalSheet(
                    parentContext: context,
                  ),
                ).then((city) {
                  if (city != null) {
                    context.read<AddressCubit>().changeCity(city);
                  }
                });
              },
              child: Row(
                children: [
                  BlocBuilder<AddressCubit, AddressState>(
                    buildWhen: (prev, current) {
                      return prev.selectedCity != current.selectedCity;
                    },
                    builder: (context, state) {
                      // TODO(mes): FIX IT??? SOMEHOW
                      return Text(state.selectedCity?.name ?? 'Загрузка...');
                    },
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ],
              ),
            ),
            if (context.select<MenuBloc, bool>(
              (value) => value.state.status == MenuStateStatus.success,
            )) ...[
              const Spacer(),
              BouncingWidget(
                child: Stack(
                  children: [
                    Container(
                      height: 24, //default icon size
                      width: 24 * 2.5,
                      margin: const EdgeInsets.only(top: 5),
                      padding: const EdgeInsets.only(right: 24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.mainBluePurple,
                            AppColors.bgLightOrange,
                          ],
                          begin: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(kMainBorderRadius),
                      ),
                      child: BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (ctx, state) {
                          return FittedBox(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.2, horizontal: 5.5),
                              child: Text(
                                '${state.person.dodoCoins}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      child: Transform.rotate(
                        angle: -pi / 6,
                        child: const FaIcon(
                          FontAwesomeIcons.bitcoin,
                          color: AppColors.mainBgOrange,
                          size: 25,
                        ),
                      ),
                      bottom: 4,
                      right: 0,
                    ),
                  ],
                ),
                onPressed: () {
                  // TODO(mes): посомтреть работу на айфоне
                  PlatformDependentMethod.callFutureByPlatform(
                    androidMethod: () => _androidBonusViewBuilder(context),
                    iosMethod: () => _iosBonusViewBuilder(context),
                  );
                },
              ),
              GestureDetector(
                onTap: () {
                  AutoRouter.of(context).push(const SearchRoute());
                },
                child: const Icon(Icons.search),
              ),
            ]
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
