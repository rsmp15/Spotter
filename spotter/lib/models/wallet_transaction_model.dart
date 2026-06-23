class WalletTransaction {
  final String id;
  final int amount; // in paise (positive for credits, negative for debits)
  final String type; // 'credit' | 'debit'
  final String source; // 'stripe_topup' | 'ride_payment' | 'ride_earnings' | 'bank_payout' | 'refund'
  final String description;
  final String? referenceId;
  final DateTime createdAt;

  const WalletTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.source,
    required this.description,
    this.referenceId,
    required this.createdAt,
  });

  double get amountInInr => amount / 100.0;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'] as String,
      amount: json['amount'] as int,
      type: json['type'] as String,
      source: json['source'] as String,
      description: json['description'] as String,
      referenceId: json['referenceId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'type': type,
        'source': source,
        'description': description,
        'referenceId': referenceId,
        'createdAt': createdAt.toIso8601String(),
      };
}

