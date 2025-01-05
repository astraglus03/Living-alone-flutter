// 건물 유형
enum BuildingType {
  apartment,    // 아파트
  villa,        // 빌라
  house,        // 주택
  officeTel;    // 오피스텔

  String get label {
    switch (this) {
      case BuildingType.apartment: return '아파트';
      case BuildingType.villa: return '빌라';
      case BuildingType.house: return '주택';
      case BuildingType.officeTel: return '오피스텔';
    }
  }
}

// 매물 종류
enum PropertyType {
  openRoom,       // 원룸(오픈형)
  separatedRoom,  // 원룸(분리형)
  twoRoom,        // 투룸
  threeRoom;      // 쓰리룸 이상

  String get label {
    switch (this) {
      case PropertyType.openRoom: return '원룸(오픈형)';
      case PropertyType.separatedRoom: return '원룸(분리형)';
      case PropertyType.twoRoom: return '투룸';
      case PropertyType.threeRoom: return '쓰리룸 이상';
    }
  }
}

// 임대 방식
enum RentType {
  monthlyRent,    // 월세
  wholeRent,      // 전세
  shortRent;      // 단기임대

  String get label {
    switch (this) {
      case RentType.monthlyRent: return '월세';
      case RentType.wholeRent: return '전세';
      case RentType.shortRent: return '단기양도';
    }
  }
}

// 옵션 목록
enum RoomOption {
  washingMachine,    // 세탁기
  dryer,             // 건조기
  refrigerator,      // 냉장고
  airConditioner,    // 에어컨
  airPurifier,       // 공기청정기
  microwave,         // 전자레인지
  gasRange,          // 가스레인지
  induction,         // 인덕션
  bed,               // 침대
  desk,              // 책상
  chair,             // 의자
  closet,            // 옷장
  builtInCloset;     // 붙박이장

  String get label {
    switch (this) {
      case RoomOption.washingMachine: return '세탁기';
      case RoomOption.dryer: return '건조기';
      case RoomOption.refrigerator: return '냉장고';
      case RoomOption.airConditioner: return '에어컨';
      case RoomOption.airPurifier: return '공기청정기';
      case RoomOption.microwave: return '전자레인지';
      case RoomOption.gasRange: return '가스레인지';
      case RoomOption.induction: return '인덕션';
      case RoomOption.bed: return '침대';
      case RoomOption.desk: return '책상';
      case RoomOption.chair: return '의자';
      case RoomOption.closet: return '옷장';
      case RoomOption.builtInCloset: return '붙박이장';
    }
  }
}

// 시설 목록
enum Facility {
  elevator,          // 엘리베이터
  parking,           // 주차장
  cctv,              // CCTV
  duplex,            // 복층
  rooftop;           // 옥탑

  String get label {
    switch (this) {
      case Facility.elevator: return '엘리베이터';
      case Facility.parking: return '주차장';
      case Facility.cctv: return 'CCTV';
      case Facility.duplex: return '복층';
      case Facility.rooftop: return '옥탑';
    }
  }
}

// 조건 목록
enum RoomCondition {
  twoResidents,      // 2인 거주 가능
  femaleOnly,        // 여성 전용
  petAllowed;        // 반려동물 가능

  String get label {
    switch (this) {
      case RoomCondition.twoResidents: return '2인 거주 가능';
      case RoomCondition.femaleOnly: return '여성 전용';
      case RoomCondition.petAllowed: return '반려동물 가능';
    }
  }
} 