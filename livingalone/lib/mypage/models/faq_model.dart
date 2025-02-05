import 'package:json_annotation/json_annotation.dart';

part 'faq_model.g.dart';

@JsonSerializable()
class FAQModel {
  final String id;
  final String question;
  final String answer;

  FAQModel({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory FAQModel.fromJson(Map<String, dynamic> json) => _$FAQModelFromJson(json);
  Map<String, dynamic> toJson() => _$FAQModelToJson(this);

  static List<FAQModel> getDummyList() {
    return [
      FAQModel(
        id: '1',
        question: '다른 건물의 커뮤니티에 참여할 수 있나요?',
        answer: '안녕하세요. 나눔이는 사용자가 등록한 주소를 기반으로 같은 건물 이웃과 소통하는 공간입니다. 주소를 잘못하여 등록시 카카오톡 문의하기 창에서 커뮤니티 변경 부탁드립니다.',
      ),
      FAQModel(
        id: '2',
        question: '질문 2',
        answer: '답변 2',
      ),
      // ... 추가 FAQ 항목들
    ];
  }
}