import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:mini_chat_application/dto/dictionary_dto.dart';
import 'package:retrofit/retrofit.dart';
import 'package:mini_chat_application/bloc/api_resp_state.dart';
import 'package:mini_chat_application/data/repository/chat_repositary.dart';
import 'package:mini_chat_application/dto/reciever_response.dart';

class ChatCubit extends Cubit<ResponseState> {
 final ChatRepository chatRepository;

 ChatCubit(this.chatRepository) : super(ResponseStateInitial());

 Future<void> getComments() async {
  emit(ResponseStateLoading());
  HttpResponse httpResponse;
  RecieverResponse dto;
  try {
   httpResponse = await chatRepository.getComments({"limit":200});
   dto = httpResponse.data as RecieverResponse;
   if(isClosed) return;
   emit(ResponseStateSuccess(dto));
  } on DioException catch (error) {
   emit(error.message as ResponseState);
  }
 }

 Future<void> getDictionary(data) async {
  emit(ResponseStateLoading());
  HttpResponse httpResponse;
  DictionaryDto dto;
  try {
   httpResponse = await chatRepository.getDictionary(data);
   dto = httpResponse.data as DictionaryDto;
   if(isClosed) return;
   emit(ResponseStateSuccess(dto));
  } on DioException catch (error) {
   emit(error.message as ResponseState);
  }
 }

}