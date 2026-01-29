import 'package:dio/dio.dart';
import 'package:mini_chat_application/dto/dictionary_dto.dart';
import 'package:mini_chat_application/dto/reciever_response.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: "https://dummyjson.com/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("comments")
  Future<HttpResponse<RecieverResponse>> getComments(
      @Queries() Map<String, dynamic> data,
      );

  @GET("https://dictionary-api-7hmy.onrender.com/define")
  Future<HttpResponse<DictionaryDto>> getDictionary(
      @Queries() Map<String, dynamic> data,
      );


}
