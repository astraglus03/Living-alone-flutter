//FIXME: 생체인식을 진행한다고 가정했을떄 생체 인증으로 로그인 대충 만들어 놓았음. 추후 회의 진행 후 수정 요망.

// import 'dart:convert';
// import 'package:flutter_keychain/flutter_keychain.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// class TokenManager {
//   static final _storage = const FlutterSecureStorage();
//
//   static Future<void> saveTokens({
//     required String accessToken,
//     required String refreshToken,
//   }) async {
//     await _storage.write(key: 'ACCESS_TOKEN', value: accessToken);
//     await _storage.write(key: 'REFRESH_TOKEN', value: refreshToken);
//   }
//
//   static Future<void> clearTokens() async {
//     await _storage.delete(key: 'ACCESS_TOKEN');
//     await _storage.delete(key: 'REFRESH_TOKEN');
//   }
//
//   static Future<bool> hasValidTokens() async {
//     final accessToken = await _storage.read(key: 'ACCESS_TOKEN');
//     return accessToken != null;
//   }
// }
//
// class CredentialManager {
//   static const String _credentialKey = 'SECURE_CREDENTIALS';
//
//   static Future<void> saveCredentials(String email, String password) async {
//     final credentials = {
//       'email': email,
//       'password': password,
//     };
//     print(jsonEncode(credentials));
//     await FlutterKeychain.put(
//       key: _credentialKey,
//       value: jsonEncode(credentials),
//     );
//   }
//
//   static Future<Map<String, String>?> getCredentials() async {
//     try {
//       final savedCredentials = await FlutterKeychain.get(key: _credentialKey);
//       if (savedCredentials != null) {
//         return Map<String, String>.from(jsonDecode(savedCredentials));
//       }
//     } catch (e) {
//       print('자격증명 조회 실패: $e');
//     }
//     return null;
//   }
//
//   static Future<void> clearCredentials() async {
//     await FlutterKeychain.remove(key: _credentialKey);
//   }
// }
//
// // login_service.dart
// class LoginService {
//   static Future<bool> login(String email, String password) async {
//     try {
//       // TODO: API 로그인 호출
//       // final response = await loginAPI(email, password);
//
//       // 임시 더미 데이터
//       final dummyTokens = {
//         'accessToken': 'dummy_access_token',
//         'refreshToken': 'dummy_refresh_token',
//       };
//
//       // 토큰 저장
//       await TokenManager.saveTokens(
//         accessToken: dummyTokens['accessToken']!,
//         refreshToken: dummyTokens['refreshToken']!,
//       );
//
//       // 자격증명 저장
//       await CredentialManager.saveCredentials(email, password);
//
//       return true;
//     } catch (e) {
//       print('로그인 실패: $e');
//       return false;
//     }
//   }
//
//   static Future<void> logout() async {
//     await TokenManager.clearTokens();
//     await CredentialManager.clearCredentials();
//   }
// }