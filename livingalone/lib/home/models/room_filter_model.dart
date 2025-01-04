import 'package:flutter/material.dart';

class FilterState {
  final Map<String, bool> locations;
  final Map<String, bool> buildingTypes;
  final Map<String, bool> propertyTypes;
  final Map<String, bool> rentalTypes;
  final RangeValues? depositRange;
  final RangeValues? monthlyRange;
  final Map<String, bool> facilities;
  final Map<String, bool> conditions;

  FilterState({
    Map<String, bool>? locations,
    Map<String, bool>? buildingTypes,
    Map<String, bool>? propertyTypes,
    Map<String, bool>? rentalTypes,
    this.depositRange,
    this.monthlyRange,
    Map<String, bool>? facilities,
    Map<String, bool>? conditions,
  }) : 
    this.locations = locations ?? {
      '안서동': false,
      '신부동': false,
      '두정동': false,
    },
    this.buildingTypes = buildingTypes ?? {
      '아파트': false,
      '빌라': false,
      '주택': false,
      '오피스텔': false,
    },
    this.propertyTypes = propertyTypes ?? {
      '매물(신축)': false,
      '매물(구축)': false,
    },
    this.rentalTypes = rentalTypes ?? {
      '월세': false,
      '전세': false,
    },
    this.facilities = facilities ?? {
      '주차가능': false,
      '엘리베이터': false,
      'CCTV': false,
      '옥탑': false,
      '복층': false,
    },
    this.conditions = conditions ?? {
      '2인 거주 가능': false,
      '여성 전용': false,
      '반려동물 가능': false,
    };

  FilterState copyWith({
    Map<String, bool>? locations,
    Map<String, bool>? buildingTypes,
    Map<String, bool>? propertyTypes,
    Map<String, bool>? rentalTypes,
    RangeValues? depositRange,
    RangeValues? monthlyRange,
    Map<String, bool>? facilities,
    Map<String, bool>? conditions,
  }) {
    return FilterState(
      locations: locations ?? Map.from(this.locations),
      buildingTypes: buildingTypes ?? Map.from(this.buildingTypes),
      propertyTypes: propertyTypes ?? Map.from(this.propertyTypes),
      rentalTypes: rentalTypes ?? Map.from(this.rentalTypes),
      depositRange: depositRange ?? this.depositRange,
      monthlyRange: monthlyRange ?? this.monthlyRange,
      facilities: facilities ?? Map.from(this.facilities),
      conditions: conditions ?? Map.from(this.conditions),
    );
  }

  String? get selectedLocations {
    final selected = locations.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    return selected.isEmpty ? null : selected.join(', ');
  }

  String? get selectedBuildingTypes {
    final selected = buildingTypes.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    return selected.isEmpty ? null : selected.join(', ');
  }

  String? get selectedPropertyTypes {
    final selected = propertyTypes.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    return selected.isEmpty ? null : selected.join(', ');
  }

  String? get selectedRentalTypes {
    final selected = rentalTypes.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    return selected.isEmpty ? null : selected.join(', ');
  }

  String? get selectedFacilities {
    final selected = facilities.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    return selected.isEmpty ? null : selected.join(', ');
  }

  String? get selectedConditions {
    final selected = conditions.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    return selected.isEmpty ? null : selected.join(', ');
  }

  String? get depositRangeText {
    if (depositRange == null) return null;
    return '${depositRange!.start.toInt()}-${depositRange!.end.toInt()}만원';
  }

  String? get monthlyRangeText {
    if (monthlyRange == null) return null;
    return '${monthlyRange!.start.toInt()}-${monthlyRange!.end.toInt()}만원';
  }
}