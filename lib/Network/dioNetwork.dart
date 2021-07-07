import 'package:pulizia_strade/Models/PositionInMap.dart';
import 'package:dio/dio.dart';

class DioNetwork {
  final Dio dio = new Dio();
  static const String baseURL = 'https://niksimoni.pythonanywhere.com/api';

  Future<Map> getParkingInfoOnPosition(PositionInMap position) async {
    print("Cerco info su: " + position.toString());
    try {
      Response result = await dio.get(_buildURLForParkingInfo(position));
      return result.data;
    } on DioError {
      throw Failure("Error getting info");
    }
  }

  String _buildURLForParkingInfo(PositionInMap position) {
    String url;
    if (position.section == "strada completa" || position.section == null) {
      print("entro senza section");
      url = '/data_pulizie?indirizzo=' + position.streetName.toUpperCase();
    } else {
      print("Entro con section");
      url = '/data_pulizie?indirizzo=' +
          position.streetName.toUpperCase() +
          '&tratto=' +
          position.section.toUpperCase();
    }
    print("returno " + baseURL + url);
    return baseURL + url;
  }

  Future<Map> getAllStreetsAndTracts(ctx) async {
    try {
      final response = await dio.get(baseURL + '/all_streets_and_tracts');
      return response.data;
    } on DioError {
      throw Failure("Error retrieving streets and tracs");
    }
  }

  Future<List<String>> getTracts(street) async {
    try {
      List<String> tracts = [];
      Response response = await dio
          .get(baseURL + '/tratti_strada?indirizzo=${street.toUpperCase()}');
      for (var i in response.data['tratti']) {
        tracts.add(i);
      }
      return tracts;
    } on DioError {
      throw Failure("Error retrieving tracts");
    }
  }
}

class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => message.toString();
}
