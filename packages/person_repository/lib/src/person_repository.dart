import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:local_storage_dodo_clone_api/local_storage_dodo_clone_api.dart';
import 'package:ntp/ntp.dart';
import 'package:person_repository/src/models/models.dart';
import 'package:dodo_clone_api_client/dodo_clone_api_client.dart'
    hide OrderType, Person, OrdersHistory, Promotion, Mission, CoinsOperation;

const supportId = 666;

class PersonRepository {
  final PersonApiClient _personApiClient;
  OrderType _orderType = OrderType.delivery;
  Person? _currentPerson;
  late final StreamController<OrderType> _orderTypeController;
  late final DatabaseReference _databaseReference;
  late final StreamController<Message> _newMessageController;
  final List<Message> _chatMessages = <Message>[];
  final _chatImages = <ChatImage>[];

  ///Костыль чтобы первого сообщения не было сверху
  bool _isLoading = true;

  OrderType get orderType => _orderType;

  List<Message> get messages => _chatMessages;

  List<ChatImage> get images => _chatImages;

  FutureOr<Person> get person async {
    if (_currentPerson == null) await _loadPerson();
    return _currentPerson!;
  }

  Stream<OrderType> get orderTypeStream async* {
    yield _orderType;
    yield* _orderTypeController.stream;
  }

  Stream<Message> get messageStream async* {
    yield* _newMessageController.stream;
  }

  PersonRepository(
      {PersonApiClient? personApiClient,
      LocalStorageDodoCloneApi? localStorage})
      : _personApiClient = personApiClient ?? PersonApiClient() {
    _orderTypeController = StreamController.broadcast()
      ..add(OrderType.delivery);
    _newMessageController = StreamController<Message>.broadcast();
    _databaseReference = FirebaseDatabase.instance.ref();
    initChat();
  }

  Future<void> _loadPerson({String? chatId}) async {
    // TODO(fix): need to provide real token
    final allData = await _personApiClient.person('accessToken');
    final activeChatId = chatId ?? await _readPersonActiveChatId(allData.id);
    _currentPerson = Person.fromApiClient(allData, activeChatId: activeChatId);
  }

  Future<List<Promotion>> promotions(int personId) async {
    final allData = await _personApiClient.promotions(personId);
    return allData.map((e) => promotionFromApiClient(e)).toList();
  }

  Future<List<CoinsOperation>> coinsOperations(int personId) async {
    final allData = await _personApiClient.coinsOperations(personId);
    final coinsOperations = allData.result
        .map((coinsOperation) => coinsOperationFromApiClient(coinsOperation))
        .toList();
    return coinsOperations;
  }

  Future<List<Mission>> missions(int personId) async {
    final allData = await _personApiClient.missions(personId);
    return allData.map((e) => missionFromApiClient(e)).toList();
  }

  ///Смотрит был ли у человека активный чат
  Future<String?> _readPersonActiveChatId(int personId) async {
    final userValue = (await _databaseReference.child('users/$personId').once())
        .snapshot
        .value;
    if (userValue == null) return null;
    final user = Map<String, dynamic>.from(userValue as Map);
    return user['activeChat'] as String;
  }

  Future<void> initChat() async {
    if ((await person).activeChatId == null) return;
    await _addListenerToMessageAdd();
    _addListenerToMessageUpdate();
  }

  Future<void> _addListenerToMessageAdd() async {
    if (_currentPerson == null) await _loadPerson();
    _databaseReference
        .child('chats/${_currentPerson!.activeChatId}')
        .onChildAdded
        .listen((event) async {
      if (_isLoading) return;
      final jsonMessage =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      final message = Message.fromJson(Map<String, dynamic>.from(jsonMessage),
          messageId: event.snapshot.key!);
      List<ChatImage>? images;
      if (message.images != null) {
        images = await _readImagesFromBd(message.images!);
        _chatImages.addAllImages(images);
      }
      _chatMessages.add(message.copyWith(images: images));
      _newMessageController.add(message.copyWith(images: images));
    });
  }

  Future<void> _addListenerToMessageUpdate() async {
    if (_currentPerson == null) await _loadPerson();
    _databaseReference
        .child('chats/${_currentPerson!.activeChatId}')
        .onChildChanged
        .listen((event) async {
      final jsonMessage =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      final message = Message.fromJson(Map<String, dynamic>.from(jsonMessage),
          messageId: event.snapshot.key!);
      if (!_chatMessages.contains(message)) return;
      _newMessageController.add(_chatMessages[_chatMessages.indexOf(message)]
          .copyWith(isWatched: message.isWatched));
    });
  }

  Future<bool> createChat() async {
    if (_currentPerson == null) await _loadPerson();
    final userPath = 'users/${_currentPerson!.id}';
    final chats = _databaseReference.child('chats');
    final newChatKey = chats.push().key;
    await _loadPerson(chatId: newChatKey);

    ///Создаем информацю о чате у юзера
    final updates = <String, dynamic>{};
    updates['$userPath/activeChat'] = newChatKey;
    updates['$userPath/name'] = _currentPerson!.name;

    ///Добавляем чат саппорту
    final supportNewChatKey = _databaseReference.push().key;
    updates['users/$supportId/activeChats/$supportNewChatKey'] = newChatKey;

    ///Применяем изменения и инициализируем чат
    await _databaseReference.update(updates);
    await initChat();
    return true;
  }

  Future<List<Message>?> readMessages({int numberOfMessages = 1000}) async {
    if (_currentPerson == null) await _loadPerson();
    if (_currentPerson?.activeChatId == null) {
      _isLoading = false;
      return null;
    }
    if (_chatMessages.length > 1) return _chatMessages;

    ///Но при считывании сортировка по ключу плохо работает, так что ключи сортируются вручную.
    final messages = Map<String, dynamic>.from(
      ((await _databaseReference
                  .child('chats/${_currentPerson!.activeChatId}')
                  .limitToLast(numberOfMessages)
                  .once())
              .snapshot
              .value ??
          {}) as Map,
    );
    final sortedKeys = messages.keys.toList()..sort();
    for (final key in sortedKeys) {
      ///Добавляем сообщение
      final jsonMessage = Map<String, dynamic>.from(messages[key] as Map);
      final message = Message.fromJson(jsonMessage, messageId: key);
      _chatMessages.add(message);

      ///Добавляем изображение
      if (_chatMessages.last.images != null) {
        final images = await _readImagesFromBd(_chatMessages.last.images!);
        _chatImages.addAllImages(images);
        _chatMessages[_chatMessages.length - 1] =
            _chatMessages.last.copyWith(images: images);
      }
    }
    _isLoading = false;
    return _chatMessages;
  }

  ///Считывает byteArray
  Future<List<ChatImage>> _readImagesFromBd(List<ChatImage> chatImages) async {
    if (_currentPerson == null) await _loadPerson();
    final images = <ChatImage>[];
    for (final image in chatImages) {
      final jsonImage = (await _databaseReference
              .child('images/${_currentPerson!.activeChatId}/${image.imageId!}')
              .once())
          .snapshot
          .value;
      images.add(
          ChatImage.fromJson(imageId: image.imageId!, jsonImage: jsonImage));
    }
    return images;
  }

  Future<bool> uploadMessage(Message message) async {
    try {
      if (_currentPerson == null) await _loadPerson();

      ///Загружаем сообщение
      final chatPath = 'chats/${_currentPerson!.activeChatId}';
      final DateTime currentTime = await NTP.now();

      ///microsecondsSinceEpoch учитывают timeZoneOffset, а dateTime в сообщении обновляется при парсинге
      final String newMessageKey =
          '${currentTime.microsecondsSinceEpoch}${_currentPerson!.id}';
      final updates = <String, dynamic>{};
      final updatedMessage = message
          .copyWith(messageId: newMessageKey, createdAt: currentTime)
          .toJson();

      ///Загружаем картинку
      if (message.images != null) {
        final imagesPath = 'images/${_currentPerson!.activeChatId}';
        final imageIds = <String>[];
        for (final image in message.images!) {
          final newImageKey = image.imageId!;
          updates['$imagesPath/$newImageKey'] = image.byteImage!.toString();
          imageIds.add(newImageKey);
        }
        updatedMessage.addEntries([MapEntry('imageIds', imageIds)]);
      }
      updates['$chatPath/$newMessageKey'] = updatedMessage;

      ///Обновляем значения
      await _databaseReference.update(updates);
      return true;
    } on Exception {
      return false;
    }
  }

  ///Помечаем все сообзения загруженными для одного пользователя, до сообщения с заданым ключем
  Future<void> markReadBefore(String lastMessageKey) async {
    if (_currentPerson == null) return;
    final updates = <String, bool>{};
    final chatPath = 'chats/${_currentPerson!.activeChatId}';
    final messageIndex = (_chatMessages
        .indexWhere((element) => element.messageId == lastMessageKey));
    if (messageIndex == -1) return;
    final fromCustomer = _chatMessages[messageIndex].userId != supportId;
    for (var i = 0;
        i < _chatMessages.length &&
            _chatMessages[i].messageId != lastMessageKey;
        i++) {
      ///Помечаем сообзения поддержки
      if (!fromCustomer && _chatMessages[i].userId == supportId) {
        updates['$chatPath/${_chatMessages[i].messageId}/isWatched'] = true;
      }
    }
    if (!fromCustomer) {
      updates['$chatPath/$lastMessageKey/isWatched'] = true;
    }
    await _databaseReference.update(updates);
  }

  void changeOrderType(OrderType type) {
    _orderType = type;
    _orderTypeController.add(type);
  }

  void dispose() {
    _newMessageController.close();
  }
}
