import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livingalone/mypage/models/user_profile_model.dart';
import 'package:livingalone/user/models/user_model.dart';

final myPageProvider = StateNotifierProvider<MypageNotifier, MypageState>((ref) {
  // API 연동 시 사용할 코드
  // final repository = ref.watch(mypageRepositoryProvider);
  // return MypageNotifier(repository);

  // 더미데이터용
  return MypageNotifier(DummyMypageRepository());
});

class MypageState {
  final UserProfileModel? profile;
  final bool isLoading;
  final String? error;

  MypageState({
    this.profile,
    this.isLoading = false,
    this.error,
  });

  MypageState copyWith({
    UserProfileModel? profile,
    bool? isLoading,
    String? error,
  }) {
    return MypageState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class MypageNotifier extends StateNotifier<MypageState> {
  final DummyMypageRepository repository;

  MypageNotifier(this.repository) : super(MypageState()) {
    getProfile();
  }

  Future<void> getProfile() async {
    state = state.copyWith(isLoading: true);
    try {
      // 더미 데이터 사용
      await Future.delayed(Duration(milliseconds: 500));
      final profile = UserProfileModel(
        id: '1',
        email: '201921035@sangmyung.kr',
        nickname: '서울대 의대생',
        phoneNumber: '010 1234 5678',
        language: '한국어',
        profileImage: 'https://picsum.photos/200',
        pushNotificationEnabled: true,
        chatNotificationEnabled: true,
        neighborNotificationEnabled: true,
        handoverNotificationEnabled: true,
        communityNotificationEnabled: true,
        noticeNotificationEnabled: true,
        address: '충남 천안시 동남구 상명대길 31',
      );
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> updateProfile({
    String? nickname,
    String? profileImage,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final currentProfile = state.profile!;
      final updatedProfile = currentProfile.copyWith(
        nickname: nickname ?? currentProfile.nickname,
        profileImage: profileImage ?? currentProfile.profileImage,
      );
      state = state.copyWith(profile: updatedProfile, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> updateNotificationSettings({
    bool? pushNotificationEnabled,
    bool? chatNotificationEnabled,
    bool? neighborNotificationEnabled,
    bool? handoverNotificationEnabled,
    bool? communityNotificationEnabled,
    bool? noticeNotificationEnabled,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final currentProfile = state.profile!;
      final updatedProfile = currentProfile.copyWith(
        pushNotificationEnabled: pushNotificationEnabled ?? currentProfile.pushNotificationEnabled,
        chatNotificationEnabled: chatNotificationEnabled ?? currentProfile.chatNotificationEnabled,
        neighborNotificationEnabled: neighborNotificationEnabled ?? currentProfile.neighborNotificationEnabled,
        handoverNotificationEnabled: handoverNotificationEnabled ?? currentProfile.handoverNotificationEnabled,
        communityNotificationEnabled: communityNotificationEnabled ?? currentProfile.communityNotificationEnabled,
        noticeNotificationEnabled: noticeNotificationEnabled ?? currentProfile.noticeNotificationEnabled,
      );
      state = state.copyWith(profile: updatedProfile, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> updateLanguage(String language) async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(Duration(milliseconds: 500));
      final currentProfile = state.profile!;
      final updatedProfile = currentProfile.copyWith(language: language);
      state = state.copyWith(profile: updatedProfile, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> updateAddress({
    required String address,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final updatedProfile = await repository.updateAddress(
        body: {
          'address': address,
        },
      );
      state = state.copyWith(
        profile: updatedProfile,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: '주소 업데이트에 실패했습니다.',
        isLoading: false,
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(Duration(milliseconds: 500));
      state = MypageState();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> withdrawal() async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(Duration(milliseconds: 500));
      state = MypageState();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

// 더미 데이터용 Repository
class DummyMypageRepository {
  Future<UserProfileModel> getProfile() async {
    await Future.delayed(Duration(milliseconds: 500));
    return UserProfileModel(
      id: '1',
      email: '123456789@sangmyung.kr',
      nickname: '네이름은코난',
      phoneNumber: '010 1234 5678',
      language: '한국어',
      profileImage: 'https://picsum.photos/200',
      pushNotificationEnabled: true,
      chatNotificationEnabled: true,
      neighborNotificationEnabled: true,
      handoverNotificationEnabled: true,
      communityNotificationEnabled: true,
      noticeNotificationEnabled: true,
      address: '충남 천안시 동남구 상명대길 31',
    );
  }

  Future<UserProfileModel> updateAddress({
    required Map<String, String> body,
  }) async {
    await Future.delayed(Duration(milliseconds: 500));
    return UserProfileModel(
      id: '1',
      email: '201921035@sangmyung.kr',
      nickname: '서울대 의대생',
      phoneNumber: '010 1234 5678',
      language: '한국어',
      profileImage: 'https://picsum.photos/200',
      pushNotificationEnabled: true,
      chatNotificationEnabled: true,
      neighborNotificationEnabled: true,
      handoverNotificationEnabled: true,
      communityNotificationEnabled: true,
      noticeNotificationEnabled: true,
      address: body['address'] ?? '충남 천안시 동남구 상명대길 31',
    );
  }
}















// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:livingalone/user/models/user_model.dart';
// import 'package:livingalone/user/repository/user_repository.dart';
//
// final myPageProvider = StateNotifierProvider<MypageNotifier, MyPageState>((ref) {
//   final repository = ref.watch(myPageRepositoryProvider);
//   return MypageNotifier(repository);
// });
//
// class MyPageState {
//   final UserModel? profile;
//   final bool isLoading;
//   final String? error;
//
//   MyPageState({
//     this.profile,
//     this.isLoading = false,
//     this.error,
//   });
//
//   MyPageState copyWith({
//     UserModel? profile,
//     bool? isLoading,
//     String? error,
//   }) {
//     return MyPageState(
//       profile: profile ?? this.profile,
//       isLoading: isLoading ?? this.isLoading,
//       error: error,
//     );
//   }
// }
//
// class MypageNotifier extends StateNotifier<MyPageState> {
//   final MyPageRepository repository;
//
//   MypageNotifier(this.repository) : super(MyPageState()) {
//     getProfile();
//   }
//
//   Future<void> getProfile() async {
//     state = state.copyWith(isLoading: true);
//     try {
//       final profile = await repository.getProfile();
//       state = state.copyWith(
//         profile: profile,
//         isLoading: false,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         error: e.toString(),
//         isLoading: false,
//       );
//     }
//   }
//
//   Future<void> updateProfile({
//     required String nickname,
//     String? profileImage,
//   }) async {
//     state = state.copyWith(isLoading: true);
//     try {
//       final updatedProfile = await repository.updateProfile(
//         body: {
//           'nickname': nickname,
//           if (profileImage != null) 'profileImage': profileImage,
//         },
//       );
//       state = state.copyWith(
//         profile: updatedProfile,
//         isLoading: false,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         error: e.toString(),
//         isLoading: false,
//       );
//     }
//   }
//
//   Future<void> updateNotificationSettings({
//     required Map<String, bool> settings,
//   }) async {
//     state = state.copyWith(isLoading: true);
//     try {
//       final updatedProfile = await repository.updateNotificationSettings(
//         body: settings,
//       );
//       state = state.copyWith(
//         profile: updatedProfile,
//         isLoading: false,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         error: e.toString(),
//         isLoading: false,
//       );
//     }
//   }
//
//   Future<void> updateLanguage(String language) async {
//     state = state.copyWith(isLoading: true);
//     try {
//       final updatedProfile = await repository.updateLanguage(
//         body: {'language': language},
//       );
//       state = state.copyWith(
//         profile: updatedProfile,
//         isLoading: false,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         error: e.toString(),
//         isLoading: false,
//       );
//     }
//   }
//
//   Future<void> updateAddress(String address) async {
//     state = state.copyWith(isLoading: true);
//     try {
//       final updatedProfile = await repository.updateAddress(
//         body: {'address': address},
//       );
//       state = state.copyWith(
//         profile: updatedProfile,
//         isLoading: false,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         error: e.toString(),
//         isLoading: false,
//       );
//     }
//   }
//
//   Future<void> logout() async {
//     state = state.copyWith(isLoading: true);
//     try {
//       await repository.logout();
//       state = MyPageState();
//     } catch (e) {
//       state = state.copyWith(
//         error: e.toString(),
//         isLoading: false,
//       );
//     }
//   }
//
//   Future<void> withdrawal() async {
//     state = state.copyWith(isLoading: true);
//     try {
//       await repository.withdrawal();
//       state = MyPageState();
//     } catch (e) {
//       state = state.copyWith(
//         error: e.toString(),
//         isLoading: false,
//       );
//     }
//   }
// }