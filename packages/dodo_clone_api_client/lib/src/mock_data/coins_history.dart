part of 'mock_data.dart';

Map<String, dynamic> mockCoinsHistory(int personId) => {
      'error': false,
      'message': 'Successful',
      'result': [
        {
          'person_id': 777,
          'operations': [
            {
              'id': 0,
              'type': 'received',
              'title': 'Начисление за заказ',
              'date_time': '2022-12-16 15:40',
              'coins': 29,
            },
            {
              'id': 1,
              'type': 'spend',
              'title': 'Списание за заказ',
              'date_time': '2022-12-10 05:00',
              'coins': 200,
            },
            {
              'id': 2,
              'type': 'received',
              'title': 'Начисление за заказ',
              'date_time': '2022-11-16 05:39',
              'coins': 11,
            },
            {
              'id': 3,
              'type': 'received',
              'title': 'Начисление за заказ',
              'date_time': '2022-10-10 10:10',
              'coins': 10,
            },
            {
              'id': 4,
              'type': 'received',
              'title': 'Корректировка баланса',
              'date_time': '2021-12-16 15:40',
              'coins': 29,
            },
          ]
        }
      ].firstWhere((element) => element['person_id'] == personId)['operations']
    };
