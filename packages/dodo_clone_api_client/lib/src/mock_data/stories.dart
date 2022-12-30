part of 'mock_data.dart';

Map<String, dynamic> mockStories(int cityId) => {
      'error': false,
      'message': 'Successful',
      'result': [
        {
          'id': 0,
          'story_name': 'Встреча с друзьями: лайфхак',
          'badge': 'Выгодно',
          'front_image':
              'https://cdn.dodopizza.info/files/marketing/sources/image1.jpg',
          'watched': false,
          'story_content': [
            {
              'id': 0,
              'content_type': 'image',
              'link':
                  'https://cdn.dodopizza.info/files/marketing/sources/EU-Cheese-Crust2.jpg',
              'navigate_to_web': '',
              'navigate_in_app': '',
              'duration': '3',
            },
            {
              'id': 1,
              'content_type': 'image',
              'link':
                  'https://cdn.dodopizza.info/files/marketing/sources/bed4aea2-70ac2.jpg',
              'duration': '4',
            },
            {
              'id': 2,
              'content_type': 'image',
              'link':
                  'https://cdn.dodopizza.info/files/marketing/sources/RUIce-2.jpg',
              'duration': '2',
            },
          ]
        },
        if (cityId == 1)
          {
            'id': 1,
            'story_name': 'Сладкий отзыв на маффин',
            'badge': 'Новинка',
            'watched': true,
            'front_image':
                'https://img1.akspic.ru/previews/9/9/1/9/6/169199/169199-smartfon-Vozdushnyy_sharik-sinij-chelovek-zhest-500x.jpg',
            'story_content': [
              {
                'id': 0,
                'content_type': 'image',
                'link':
                    'https://cdn.dodopizza.info/files/marketing/sources/image3.jpg',
                'duration': '3',
              }
            ]
          },
        if (cityId == 2)
          {
            'id': 2,
            'story_name': 'Летнее меню',
            'badge': 'Выгодно',
            'front_image':
                'http://kotlyarov.3jz.ru/dodo_clone/images/oblepiha.jpeg',
            'watched': false,
            'story_content': [
              {
                'id': 0,
                'content_type': 'image',
                'link':
                    'http://kotlyarov.3jz.ru/dodo_clone/images/ice_cream_first.jpeg',
                'navigate_to_web': '',
                'navigate_in_app': '',
                'duration': '3',
              },
              {
                'id': 1,
                'content_type': 'image',
                'link':
                    'http://kotlyarov.3jz.ru/dodo_clone/images/raspberry_first.jpeg',
                'duration': '4',
              },
            ]
          },
      ]
    };
