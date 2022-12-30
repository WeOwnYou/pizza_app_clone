import 'package:dio/dio.dart';
import '../models/models.dart';

class DadataSuggestionApi {
  static const _baseUrl =
      'https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/';
  final Dio _dio;
  DadataSuggestionApi() : _dio = Dio(BaseOptions(baseUrl: _baseUrl));
  Future<AddressCompletionResponse> getSuggestedAddresses(String search) async {
    final response = await _dio.get<Map<String, dynamic>>(
      'address',
      queryParameters: <String, String>{
        'query': search,
        'token': '2f26e12d87f626a7f5d4e3e1a20a6577d48c94b3',
        'secret': 'e3abcf09989ee7ad41dee6be06567eb3d3db97e2 ',
      },
    );
    if (response.statusCode != 200 || response.data == null) {
      throw AddressCompletionRequestFailure();
    }
    final suggestions = AddressCompletionResponse.fromJson(response.data!);
    if(suggestions.suggestions.isEmpty) {
      throw AddressCompletionNotFound();
    }
    for (final element in suggestions.suggestions) {
      if (element.data == null || element.data!.streetWithType == null) {
        throw AddressCompletionNotFound();
      }
    }
    return suggestions;
  }
}
