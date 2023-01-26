import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'RestClient.g.dart';

@RestApi(baseUrl: "http://youpiwhatsappbot-env.eba-3aevkfzh.eu-west-3.elasticbeanstalk.com")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/chat-bot/youpi/history")
  Future<List<Answer>> getAnswers(@Query("pageSize") int pageSize,
      @Query("offset") int offset, @Query("token") String token);

  /* post questions and wait for answer */
  @POST("/chat-bot/youpi/ask")
  Future<Answer> askQuestion(@Body() Question question);
}

@JsonSerializable()
class Question {
  int? id;
  String? username;
  String? question;
  String? language;
  DateTime? createDateTime;

  Question({this.id, this.username,this.language, this.question, this.createDateTime});

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable()
class Answer {
  int? id;
  Question? question;
  String? answer;
  DateTime? createDateTime;

  Answer({this.id, this.question, this.answer, this.createDateTime});

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerToJson(this);
}
