class ApiOptions {
  final ApiType apiType;
  final String prodUrl;
  final String prodKey;
  final String devUrl;
  final String devKey;

  ApiOptions({
    required this.apiType,
    required this.devUrl,
    required this.prodUrl,
    required this.devKey,
    required this.prodKey,
  });

  factory ApiOptions.empty() {
    return ApiOptions(
      apiType: ApiType.rest,
      devUrl: '',
      prodUrl: '',
      devKey: '',
      prodKey: '',
    );
  }
}

enum ApiType {
  none,
  rest,
  graphql,
  supabase;

  static ApiType fromString(String apiType) {
    final typeLower = apiType.toLowerCase();
    if (typeLower == 'none') {
      return ApiType.none;
    } else if (typeLower == 'rest') {
      return ApiType.rest;
    } else if (typeLower == 'graphql') {
      return ApiType.graphql;
    } else if (typeLower == 'supabase') {
      return ApiType.supabase;
    } else {
      throw Exception('Invalid ApiType');
    }
  }
}
