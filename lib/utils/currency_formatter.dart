String formatPhp(int amount) {
  final digits = amount.toString();
  final formatted = StringBuffer();

  for (int index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) {
      formatted.write(',');
    }

    formatted.write(digits[index]);
  }

  return 'PHP ${formatted.toString()}';
}