import 'package:livingalone/common/const/const.dart';

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
}