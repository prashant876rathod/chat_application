import 'dart:convert';

class DictionaryDto {
  String? word;
  String? partOfSpeech;
  String? definition;

  DictionaryDto({
    this.word,
    this.partOfSpeech,
    this.definition,
  });

  factory DictionaryDto.fromRawJson(String str) => DictionaryDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DictionaryDto.fromJson(Map<String, dynamic> json) => DictionaryDto(
    word: json["word"] ?? "",
    partOfSpeech: json["partOfSpeech"]??"",
    definition: json["definition"]??"",
  );

  Map<String, dynamic> toJson() => {
    "word": word,
    "partOfSpeech": partOfSpeech,
    "definition": definition,
  };
}
