class ContentData{

  static final ContentData _instance = ContentData._internal();

  factory ContentData() => _instance;

  ContentData._internal();

  final List<String> fortune = [
    '大吉',
    '吉',
    '半吉',
    '小吉',
    '末小吉',
    '末吉',
    '凶',
  ];


}