enum RecurringType {
  daily('daily', '毎日'),
  weekly('weekly', '毎週'),
  monthly('monthly', '毎月'),
  monthlyLast('monthly_last', '毎月最終日');

  const RecurringType(this.value, this.label);
  
  final String value;
  final String label;

  static RecurringType? fromString(String? value) {
    if (value == null) return null;
    for (final type in RecurringType.values) {
      if (type.value == value) return type;
    }
    return null;
  }
}