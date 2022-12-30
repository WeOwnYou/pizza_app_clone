abstract class AddressCompletionException implements Exception {}

class AddressCompletionRequestFailure extends AddressCompletionException {}

class AddressCompletionNotFound extends AddressCompletionException {}
