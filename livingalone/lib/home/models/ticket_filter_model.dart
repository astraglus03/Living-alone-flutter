class TicketFilterState {
  final Map<String, bool> locations;
  final Map<String, bool> ticketTypes;

  TicketFilterState({
    Map<String, bool>? locations,
    Map<String, bool>? ticketTypes,
  }) :
        this.locations = locations ?? {
          '안심동': false,
          '신부동': false,
          '두정동': false,
        },
        this.ticketTypes = ticketTypes ?? {
          '스터디 카페': false,
          '헬스PT': false,
          '필라테스': false,
        };

  TicketFilterState copyWith({
    Map<String, bool>? locations,
    Map<String, bool>? ticketTypes,
  }) {
    return TicketFilterState(
      locations: locations ?? Map.from(this.locations),
      ticketTypes: ticketTypes ?? Map.from(this.ticketTypes),
    );
  }

  String? get selectedLocations {
    final selected = locations.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    return selected.isEmpty ? null : selected.join(', ');
  }

  String? get selectedTicketTypes {
    final selected = ticketTypes.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    return selected.isEmpty ? null : selected.join(', ');
  }
}