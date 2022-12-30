part of 'mock_data.dart';

List<Map<String, dynamic>> mockPromotions(int personId) => [
  {
    'id': 0,
    'title': 'Чоризо фреш 25 см в подарок от 749 ₽',
    'description': 'Акция действует по 1 декабря. Скидки по промокодам не суммируются. Промокод действует 1 раз, Акция не работает на добавленные ингредиенты и при заказе комбо',
    'image': 'http://kotlyarov.3jz.ru/dodo_clone/images/promotions/promo_first.png',
    'expires': '01-12-2022',
  },
  {
    'id': 1,
    'title': 'Скидка 30% при заказе от 1099 ₽',
    'description': 'Акция действует по 8 декабря. Скидки по промокодам не суммируются. Промокод действует 1 раз, Акция не работает при заказе комбо',
    'image': 'http://kotlyarov.3jz.ru/dodo_clone/images/promotions/promo_second.png',
    'expires': '08-12-2022',
  },
  {
    'id': 2,
    'title': '2 Додстера',
    'description': 'Акция действует по 8 января. Скидки по промокодам не суммируются. Промокод действует 1 раз, Акция не работает при заказе комбо',
    'image': 'http://kotlyarov.3jz.ru/dodo_clone/images/promotions/promo_second.png',
    'expires': '08-01-2023',
  },
];

List<Map<String, dynamic>> mockMissions(int personId) => [
  {
    'id': 0,
    'title': 'Сделайте 2 заказа с вампирскими продуктами',
    'description': 'Нажмите "Приступить" в миссии. Сделайте 2 заказа с любым продуктом, который отмечен значком "Вампиры средней полосы" и получите 200 додокоинов и промокод в онлайн-кинотеатр START. Заказ пиццы в составе двух половинок не учитываем. Додокоины за миссию автоматически начислим в течение суток после завершения последнего заказа. Отмененные заказы не считаются. На кассе ресторана не забудьте назвать номер телефона',
    'image': 'http://kotlyarov.3jz.ru/dodo_clone/images/promotions/mission_first.png',
    'expires': '27-12-2022',
    'dodo_reward': 200,
  }
];