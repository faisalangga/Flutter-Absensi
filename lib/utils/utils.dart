
class Utils{

  static String shortenString(String input, int maxLength) {
    if (input.length <= maxLength) {
      return input;
    } else {
      return '${input.substring(0, maxLength)}...';
    }
  }
}