class RecieveState {
  final int currentPage;
  final String selectedRecieveType;

  const RecieveState({
    this.currentPage = 0,
    this.selectedRecieveType = 'Code',
  });

  RecieveState copyWith({
    int? currentPage,
    String? selectedRecieveType,
  }) {
    return RecieveState(
      currentPage: currentPage ?? this.currentPage,
      selectedRecieveType: selectedRecieveType ?? this.selectedRecieveType,
    );
  }
}