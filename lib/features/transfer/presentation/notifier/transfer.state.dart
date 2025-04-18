class TransferState {
  final int currentPage;
  final String selectedTransferType;

  const TransferState({
    this.currentPage = 0,
    this.selectedTransferType = 'Transfer',
  });

  TransferState copyWith({
    int? currentPage,
    String? selectedTransferType,
  }) {
    return TransferState(
      currentPage: currentPage ?? this.currentPage,
      selectedTransferType: selectedTransferType ?? this.selectedTransferType,
    );
  }
}