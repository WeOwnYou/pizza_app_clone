import 'package:dodo_clone_repository/dodo_clone_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:person_repository/person_repository.dart';

part 'bonuses_event.dart';
part 'bonuses_state.dart';

class BonusesBloc extends Bloc<BonusesEvent, BonusesState> {
  final PersonRepository _personRepository;
  final IDodoCloneRepository _dodoCloneRepository;

  BonusesBloc({
    required PersonRepository personRepository,
    required IDodoCloneRepository dodoCloneRepository,
  })  : _personRepository = personRepository,
        _dodoCloneRepository = dodoCloneRepository,
        super(BonusesState.initial) {
    on<BonusesInitializeEvent>(_initialize);
    on<BonusAddProductToCartEvent>(_onAddBonusProductToCart);
    on<BonusHistoryInitializeEvent>(_onBonusHistoryInitialize);
  }

  Future<void> _initialize(
    BonusesInitializeEvent event,
    Emitter<BonusesState> emit,
  ) async {
    final loyaltyOffers = await _dodoCloneRepository.loyaltyOffersBlock();
    final coins = (await _personRepository.person).dodoCoins;
    return emit(
      state.copyWith(
        availableCoins: coins - event.coinsInCart,
        loyaltyOffers: loyaltyOffers,
        status: BonusesStateStatus.success,
        numberOfOffersInCart: event.numberOfBonusOffersInCart,
      ),
    );
  }

  void _onAddBonusProductToCart(
    BonusAddProductToCartEvent event,
    Emitter<BonusesState> emit,
  ) {
    final shoppingCartItem = ShoppingCartItem.fromBonuses(
      offer: event.offer,
      coinsPrice: event.coinsPrice.toDouble(),
      imageUrl: event.offer.image,
    );
    _dodoCloneRepository.addProductsToCart(productsToAdd: [shoppingCartItem]);
    return emit(
      state.copyWith(
        availableCoins: state.availableCoins - event.coinsPrice,
        numberOfOffersInCart: state.numberOfOffersInCart + 1,
      ),
    );
  }

  Future<void> _onBonusHistoryInitialize(
    BonusHistoryInitializeEvent event,
    Emitter<BonusesState> emit,
  ) async {
    final person = await _personRepository.person;
    final coinsOperations = await _personRepository.coinsOperations(person.id);
    return emit(state.copyWith(coinsOperations: coinsOperations));
  }
}
