import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/common/const/const.dart';
import 'package:livingalone/common/dio/dio.dart';
import 'package:livingalone/user/models/login_response.dart';
import 'package:livingalone/user/models/verification_model.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_repository.g.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio, baseUrl: 'https://$ip/auth');
});

@RestApi()
abstract class AuthRepository {
  factory AuthRepository(Dio dio, {String baseUrl}) = _AuthRepository;

  // TODO: 추후 requestBody 및 response 수정 예정

  // 로그인((user/view/login_screen.dart)
  @POST('/login')
  Future<LoginResponse> login({
    @Field('email') required String email,
    @Field('password') required String password,
  });

  // 회원가입 완료(user/view/signup_nickname_screen.dart) // 멀티파트
  @POST('/register')
  @MultiPart()
  Future<void> register({
    @Part(name: 'request', contentType: 'application/json') required String request,
    @Part(name: 'profileImage') File? profileImage,
  });

  // 대학생 이메일 인증 코드 전송(user/view/signup_authentication_screen.dart)
  @POST('/verify-email')
  Future<VerificationResponse> sendEmailVerification({
    @Body() required EmailVerificationRequest request,
  });

  // 대학생 이메일 번호 인증(user/view/signup_authentication_screen.dart)
  @POST('/verify-code')
  Future<VerificationResponse> verifyEmailCode({
    @Field('email') required String email,
    @Field('university') required String university,
    @Field('code') required String code,
  });

  // 휴대폰 인증 코드 전송(user/view/signup_phone_verify_screen.dart)
  @POST('/verify-phone')
  Future<VerificationResponse> sendPhoneVerification({
    @Field('phoneNumber') required String phoneNumber,
    @Field('carrier') required String carrier,
  });

  // 휴대폰 번호 코드 인증(user/view/signup_phone_verify_screen.dart)
  @POST('/verify-phone-code')
  Future<VerificationResponse> verifyPhoneCode({
    @Field('phoneNumber') required String phoneNumber,
    @Field('carrier') required String carrier,
    @Field('code') required String code,
  });

  // 닉네임 중복 인증(user/view/signup_nickname_screen.dart)
  @POST('/check-nickname')
  Future<bool> checkNicknameAvailability({
    @Field('nickname') required String nickname,
  });
}