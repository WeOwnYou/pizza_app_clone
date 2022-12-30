part of 'mock_data.dart';

Map<String, dynamic> mockLoyaltyOffers() {
  return {
    'error': false,
    'message': 'Successful',
    'result': [
      {
        'TITLE': 'Соусы',
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/barbeku_souce.jpeg',
        'PRICE_COINS': 50,
        'OFFERS': [
          offers[25],
        ],
      },
      {
        'TITLE': 'Напитки',
        'PICTURE': 'http://kotlyarov.3jz.ru/dodo_clone/images/nice_orange.png',
        'PRICE_COINS': 130,
        'OFFERS': [
          offers[23],
          offers[21],
          offers[20],
          offers[19],
          offers[22],
        ],
      },
      {
        'TITLE': 'Десерты',
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/cheescake_newyork.png',
        'PRICE_COINS': 150,
        'OFFERS': [
          offers[18],
          offers[17],
          offers[16],
        ],
      },
      {
        'TITLE': 'Закуски',
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/cheese_bruskets_with_garlic.png',
        'PRICE_COINS': 200,
        'OFFERS': [
          offers[15],
          offers[14],
          offers[12],
        ],
      },
      {
        'TITLE': 'Маленькая пицца',
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/pepperoni_fresh.png',
        'PRICE_COINS': 400,
        'OFFERS': [
          offers[6],
          offers[3],
        ],
      },
      {
        'TITLE': 'Средняя пицца',
        'PICTURE': 'http://kotlyarov.3jz.ru/dodo_clone/images/margarita.png',
        'PRICE_COINS': 600,
        'OFFERS': [
          offers[7],
          offers[4],
          offers[1],
        ],
      },
      {
        'TITLE': 'Большая пицца',
        'PICTURE': 'http://kotlyarov.3jz.ru/dodo_clone/images/margarita.png',
        'PRICE_COINS': 800,
        'OFFERS': [
          offers[5],
          offers[2],
        ],
      }
    ]
  };
}
