part of 'mock_data.dart';

//TODO(mes): заменить фотографии продукта на фотографии офера, фотографии продукта убрать (в меню на переднем плане фотографии выбранного офера)
List<Map<String, dynamic>> productsDetails(bool withOffers) => [
      {
        'CATEGORY_ID': 0,
        'ID': 8086,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Пепперони фреш',
        'PRICE': 915,
        'SPECIAL': true,
        'DETAIL_TEXT':
            'Пикантная пепперони, увеличенная порция моцареллы, томаты, фирменный томатный соус',
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/pepperoni_fresh.png',
        'TOPPING_LIST': [1, 2, 3, 4, 5, 6, 7],
        'INGREDIENTS': [100, 99, 98, 101, 102, 103, 104],
        'OFFERS': withOffers
            ? [
                offers[0],
                offers[1],
                offers[2],
              ]
            : [offers[0]]
      },
      {
        'CATEGORY_ID': 0,
        'ID': 8008, //1
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: false,
          1: false,
          2: true,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Маргарита',
        'PRICE': 100,
        'SPECIAL': false,
        'DETAIL_TEXT':
            'Увеличенная порция моцареллы, томаты, итальянские травы, фирменный томатный соус',
        'TOPPING_LIST': [5, 6, 7],
        'INGREDIENTS': [104, 105, 106, 107],
        'PICTURE': 'http://kotlyarov.3jz.ru/dodo_clone/images/margarita.png',
        'OFFERS': withOffers
            ? [
                offers[3],
                offers[4],
                offers[5],
              ]
            : [offers[3]]
      },
      {
        'CATEGORY_ID': 0,
        'ID': 505,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Ветчина и сыр',
        'PRICE': 505,
        'SPECIAL': true,
        'DETAIL_TEXT': 'Ветчина, моцарелла, фирменный соус альфредо',
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/vetchina_i_sir.png',
        'TOPPING_LIST': [0, 1, 2, 3, 4, 5, 6, 7],
        'INGREDIENTS': [108, 109, 110, 111],
        'OFFERS': withOffers
            ? [
                offers[6],
                offers[7],
                offers[8],
              ]
            : [offers[6]]
      },
      {
        'CATEGORY_ID': 1,
        'ID': 0,
        'NAME': 'Комбо 1',
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: false,
          1: true,
          2: true,
        },
        'DELIVER_AVAILABLE': true,
        'DETAIL_TEXT': 'Просто офигенное описание этой вкуснятины 1',
        'discount': 0.1,
        'PICTURE': 'http://kotlyarov.3jz.ru/dodo_clone/images/combo_10.webp',
        'PRICE': 180,
        'OFFERS': withOffers
            ? [
                offers[9],
              ]
            : [
                offers[9],
              ]
      },
      {
        'CATEGORY_ID': 1,
        'ID': 2,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Комбо 2',
        'DETAIL_TEXT': 'Просто офигенное описание этой вкуснятины 2',
        'discount': 0.1,
        'PRICE': 190,
        'PICTURE': 'http://kotlyarov.3jz.ru/dodo_clone/images/combo_10.webp',
        'OFFERS': withOffers
            ? [
                offers[10],
              ]
            : [
                offers[10],
              ]
      },
      {
        'CATEGORY_ID': 1,
        'ID': 3,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: false,
          1: true,
          2: true,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Комбо 3',
        'PRICE': 200,
        'DETAIL_TEXT': 'Просто офигенное описание этой вкуснятины 3',
        'discount': 0.1,
        'PICTURE': 'http://kotlyarov.3jz.ru/dodo_clone/images/combo_10.webp',
        'OFFERS': withOffers
            ? [
                offers[11],
              ]
            : [
                offers[11],
              ]
      },
      {
        'CATEGORY_ID': 2,
        'ID': 35,
        'NAME': 'Закуски 1',
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'SPECIAL': false,
        'DETAIL_TEXT': 'Description',
        'PRICE': 120,
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/cheese_bruskets_with_garlic.png',
        'OFFERS': withOffers
            ? [
                offers[12],
              ]
            : [
                offers[12],
              ]
      },
      {
        'CATEGORY_ID': 2,
        'ID': 4,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Закуски 2',
        'SPECIAL': true,
        'DETAIL_TEXT': 'Description 2',
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/cheese_bruskets_with_garlic.png',
        'PRICE': 200,
        'OFFERS': withOffers
            ? [
                offers[13],
              ]
            : [
                offers[13],
              ]
      },
      {
        'CATEGORY_ID': 2,
        'ID': 5,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Закуски 3',
        'SPECIAL': false,
        'DETAIL_TEXT': 'Description 3',
        'PRICE': 500,
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/cheese_bruskets_with_garlic.png',
        'OFFERS': withOffers
            ? [
                offers[14],
              ]
            : [
                offers[14],
              ]
      },
      {
        'CATEGORY_ID': 2,
        'ID': 6,
        'NAME': 'Закуски 4',
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'SPECIAL': true,
        'DETAIL_TEXT': 'Description 4',
        'PRICE': 500,
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/cheese_bruskets_with_garlic.png',
        'OFFERS': withOffers
            ? [
                offers[15],
              ]
            : [
                offers[15],
              ]
      },
      {
        'CATEGORY_ID': 3,
        'ID': 7,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Десерты 1',
        'SPECIAL': false,
        'DETAIL_TEXT': 'Description 1',
        'PRICE': 120,
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/cheescake_newyork.png',
        'OFFERS': withOffers
            ? [
                offers[16],
              ]
            : [
                offers[16],
              ]
      },
      {
        'CATEGORY_ID': 3,
        'ID': 8,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Десерты 2',
        'SPECIAL': true,
        'DETAIL_TEXT': 'Description 2',
        'PRICE': 150,
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/cheescake_newyork.png',
        'OFFERS': withOffers
            ? [
                offers[17],
              ]
            : [
                offers[17],
              ]
      },
      {
        'ID': 9,
        'CATEGORY_ID': 3,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Десерты 3',
        'SPECIAL': false,
        'DETAIL_TEXT': 'Description 3',
        'PRICE': 190,
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/cheescake_newyork.png',
        'OFFERS': withOffers
            ? [
                offers[18],
              ]
            : [
                offers[18],
              ]
      },
      {
        'CATEGORY_ID': 4,
        'ID': 10,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Напитки 1',
        'SPECIAL': true,
        'DETAIL_TEXT': 'Description',
        'PRICE': 200,
        'PICTURE': 'http://kotlyarov.3jz.ru/dodo_clone/images/nice_orange.png',
        'OFFERS': withOffers
            ? [
                offers[19],
              ]
            : [
                offers[19],
              ]
      },
      {
        'CATEGORY_ID': 4,
        'ID': 11,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Напитки 2',
        'SPECIAL': false,
        'DETAIL_TEXT': 'Description',
        'PRICE': 300,
        'PICTURE': 'http://kotlyarov.3jz.ru/dodo_clone/images/nice_orange.png',
        'OFFERS': withOffers
            ? [
                offers[20],
              ]
            : [
                offers[20],
              ]
      },
      {
        'CATEGORY_ID': 4,
        'ID': 12,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Напитки 3',
        'SPECIAL': true,
        'DETAIL_TEXT': 'Description',
        'PRICE': 400,
        'PICTURE': 'http://kotlyarov.3jz.ru/dodo_clone/images/nice_orange.png',
        'OFFERS': withOffers
            ? [
                offers[21],
              ]
            : [
                offers[21],
              ]
      },
      {
        'ID': 13,
        'CATEGORY_ID': 4,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Напитки 4',
        'SPECIAL': false,
        'DETAIL_TEXT': 'Description',
        'PRICE': 300,
        'PICTURE': 'http://kotlyarov.3jz.ru/dodo_clone/images/nice_orange.png',
        'OFFERS': withOffers
            ? [
                offers[22],
              ]
            : [
                offers[22],
              ]
      },
      {
        'CATEGORY_ID': 4,
        'ID': 14,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Напитки 5',
        'SPECIAL': true,
        'DETAIL_TEXT': 'Description',
        'PRICE': 300,
        'PICTURE': 'http://kotlyarov.3jz.ru/dodo_clone/images/nice_orange.png',
        'OFFERS': withOffers
            ? [
                offers[23],
              ]
            : [
                offers[23],
              ]
      },
      {
        'CATEGORY_ID': 5,
        'ID': 15,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Соусы 1',
        'SPECIAL': false,
        'DETAIL_TEXT': 'Description',
        'PRICE': 300,
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/barbeku_souce.jpeg',
        'OFFERS': withOffers
            ? [
                offers[24],
              ]
            : [
                offers[24],
              ]
      },
      {
        'CATEGORY_ID': 5,
        'ID': 16,
        'NAME': 'Соусы 2',
        'SPECIAL': true,
        'DETAIL_TEXT': 'Description',
        'PRICE': 300,
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/barbeku_souce.jpeg',
        'OFFERS': withOffers
            ? [
                offers[25],
              ]
            : [
                offers[25],
              ]
      },
      {
        'CATEGORY_ID': 5,
        'ID': 17,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Соусы 3',
        'SPECIAL': false,
        'DETAIL_TEXT': 'Description',
        'PRICE': 300,
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/barbeku_souce.jpeg',
        'OFFERS': withOffers
            ? [
                offers[26],
              ]
            : [
                offers[26],
              ]
      },
      {
        'CATEGORY_ID': 6,
        'ID': 18,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Другие товары 1',
        'SPECIAL': true,
        'DETAIL_TEXT': 'Description',
        'PRICE': 300,
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/dodo_painter.jpeg',
        'OFFERS': withOffers
            ? [
                offers[27],
              ]
            : [
                offers[27],
              ]
      },
      {
        'CATEGORY_ID': 6,
        'ID': 19,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Другие товары 2',
        'SPECIAL': false,
        'DETAIL_TEXT': 'Description',
        'PRICE': 300,
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/dodo_painter.jpeg',
        'OFFERS': withOffers
            ? [
                offers[28],
              ]
            : [
                offers[28],
              ]
      },
      {
        'CATEGORY_ID': 6,
        'ID': 20,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Другие товары 3',
        'SPECIAL': true,
        'DETAIL_TEXT': 'Description',
        'PRICE': 300,
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/dodo_painter.jpeg',
        'OFFERS': withOffers
            ? [
                offers[29],
              ]
            : [
                offers[29],
              ]
      },
      {
        'CATEGORY_ID': 6,
        'ID': 21,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Другие товары 4',
        'SPECIAL': false,
        'DETAIL_TEXT': 'Description',
        'PRICE': 300,
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/dodo_painter.jpeg',
        'OFFERS': withOffers
            ? [
                offers[30],
              ]
            : [
                offers[30],
              ]
      },
      {
        'CATEGORY_ID': 6,
        'ID': 22,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Другие товары 5',
        'SPECIAL': true,
        'DETAIL_TEXT': 'Description',
        'PRICE': 300,
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/dodo_painter.jpeg',
        'OFFERS': withOffers
            ? [
                offers[31],
              ]
            : [
                offers[31],
              ]
      },
      {
        'CATEGORY_ID': 6,
        'ID': 23,
        'RESTAURANT_AVAILABLE': true,
        'RESTAURANTS_TO_BUY': {
          0: true,
          1: false,
          2: false,
        },
        'DELIVER_AVAILABLE': true,
        'NAME': 'Другие товары 6',
        'SPECIAL': false,
        'DETAIL_TEXT': 'Description',
        'PRICE': 300,
        'PICTURE':
            'http://kotlyarov.3jz.ru/dodo_clone/images/dodo_painter.jpeg',
        'OFFERS': withOffers
            ? [
                offers[32],
              ]
            : [
                offers[32],
              ]
      },
    ];
