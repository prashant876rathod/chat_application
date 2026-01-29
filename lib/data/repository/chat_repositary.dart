
import 'package:dio/dio.dart';
import 'package:mini_chat_application/data/network/rest_client.dart';
import 'package:mini_chat_application/dto/dictionary_dto.dart';
import 'package:mini_chat_application/dto/reciever_response.dart';
import 'package:retrofit/dio.dart';

class ChatRepository{
  final Dio _dio = Dio();
  late RestClient _apiClient;

  ChatRepository() {
    _apiClient = RestClient(_dio);
  }

  Future<HttpResponse<RecieverResponse>> getComments(limit) async {
    return _apiClient.getComments(limit);
  }

  Future<HttpResponse<DictionaryDto>> getDictionary(data) async {
    return _apiClient.getDictionary(data);
  }

}