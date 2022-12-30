part of 'mock_data.dart';

Map<String, dynamic> mockRestaurantAddresses(int cityId) => {
      'error': false,
      'message': 'Successful',
      'result': [
        {
          'city_id': 2,
          'city': 'Тамбов',
          'addresses': [
            {
              'id': 0,
              'city': 'Тамбов',
              'selected': true,
              'street': 'Сергеева-Ценского',
              'house': '1',
              'phone_number': '+7 900 490-03-62',
              'location': {
                'lon': '41.46983044580173',
                'lat': '52.71239280113732',
              },
              'working_hours': {
                'start_time': '10:00',
                'end_time': '23:00',
              }
            },
            {
              'id': 1,
              'city': 'Тамбов',
              'street': 'Чичерина',
              'house': '27',
              'phone_number': '+7 900 490-03-62',
              'location': {
                'lon': '41.39773101008092',
                'lat': '52.76637682593797',
              },
              'working_hours': {
                'start_time': '10:00',
                'end_time': '22:00',
              }
            },
            {
              'id': 2,
              'city': 'Тамбов',
              'street': 'Комунальная',
              'house': '10',
              'phone_number': '+7 900 490-03-62',
              'location': {
                'lon': '41.45057697568237',
                'lat': '52.722820471517906',
              },
              'working_hours': {
                'start_time': '09:00',
                'end_time': '22:00',
              }
            },
          ]
        },
        {
          'city_id': 1,
          'city': 'Москва',
          'addresses': [
            {
              'id': 0,
              'city': 'Москва',
              'street': 'Павла Корчагина',
              'house': '3с1',
              'phone_number': '+7 977 980-37-27',
              'location': {
                'lon': '37.656496',
                'lat': '55.813981',
              },
              'working_hours': {
                'start_time': '09:00',
                'end_time': '23:00',
              }
            },
            {
              'id': 1,
              'city': 'Москва',
              'street': 'Пресненская набережная',
              'house': '2',
              'phone_number': '+7 903 585-93-74',
              'location': {
                'lon': '37.539742',
                'lat': '55.749162',
              },
              'working_hours': {
                'start_time': '10:00',
                'end_time': '22:00',
              }
            }
          ]
        }
      ].firstWhere((element) => element['city_id'] == cityId)['addresses']
    };

mockDeliveryAddresses(int cityId, String accessToken) => {
      'error': false,
      'message': 'Successful',
      'result': [
        {
          'city_id': 2,
          'city': 'Тамбов',
          'addresses': [
            {
              'id': 3,
              'city': 'Тамбов',
              'selected': true,
              'street': 'Студенецкая',
              'house': '20a',
              'apartment': 53,
              'entrance': 1,
              'floor': 1,
              'door_code': '0',
              'title': 'Офис',
              'commentary': 'da',
              'lon': '52.726762354442386',
              'lat': '41.44712068089326',
            },
            {
              'id': 4,
              'city': 'Тамбов',
              'street': 'Мичуринская',
              'house': '201',
              'lon': '52.76517815428631',
              'lat': '41.403241323564515',
            },
          ],
        },
        {
          'city_id': 1,
          'city': 'Москва',
          'addresses': [
            {
              'id': 5,
              'city': 'Тамбов',
              'street': 'Константина-Царева',
              'house': '14',
              'lon': '52.76517815428631',
              'lat': '41.403241323564515',
            },
          ],
        }
      ].firstWhere((element) => element['city_id'] == cityId)['addresses']
    };
