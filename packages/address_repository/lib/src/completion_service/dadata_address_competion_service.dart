
import 'package:address_repository/src/completion_service/dadata_suggestion_api.dart';
import 'package:address_repository/src/models/address_completion_response.g.dart';

class DadataAddressCompletionService {
  final DadataSuggestionApi _suggestionApi = DadataSuggestionApi();
  static final DadataAddressCompletionService instance =
      DadataAddressCompletionService._();

  DadataAddressCompletionService._();
  Future<List<String>> getSuggestions(String address) async {
    final allData =
        (await _suggestionApi.getSuggestedAddresses(address)).suggestions;
    final suggestedStreets = allData.map(_addressToString).toList();
    return suggestedStreets;

  }

  String _addressToString(Suggestion suggestion){
    return suggestion.data!.streetWithType!;
  }
}
