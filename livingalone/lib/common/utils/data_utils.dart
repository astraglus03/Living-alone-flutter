import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livingalone/common/const/const.dart';
import 'package:share_plus/share_plus.dart';

class DataUtils{
  static DateTime stringtoDateTime(String value){
    return DateTime.parse(value);
  }

  static String pathToUrl(String value){
    return 'http://$ip/$value';
  }

  // 이미지가 리스트 & 문자열로 있을 경우 리스트화
  static List<String> listPathToUrls(List paths){
    return paths.map((e) => pathToUrl(e)).toList();
  }

  static Future<void> sharePost({
    required String title,
    required String price,
    required String location,
    String? additionalInfo,  // 추가 정보(선택)
  }) async {
    // FIXME: 예시
    final url = 'https://www.naver.com';
    final String shareText = '''
[자취방 양도 게시물 공유하기]

$title

위치: $location
가격: $price
${additionalInfo != null ? '\n$additionalInfo' : ''}

※ 앱 출시할 경우 링크를 통해 보여줄 예정.
${url} ''';

    try {

      final result = await Share.share(
        shareText,
        subject: title,
      );
      // final result = await Share.shareXFiles(
      //   [XFile('assets/applogo/main_logo.png')], text: shareText,
      //   subject: title,
      // );
      if (result.status == ShareResultStatus.success) {
        print('공유 완료');
      }
    } catch (e) {
      debugPrint('공유 중 오류 발생: $e');
    }
  }
}