import '../../../restrr.dart';

class Page<T> {
  final int pageNumber;
  final int limit;
  final int total;
  final List<T> items;
  final Future<Page<T>> Function(Restrr)? nextPage;
  final Future<Page<T>> Function(Restrr)? previousPage;

  const Page({
    required this.pageNumber,
    required this.limit,
    required this.total,
    required this.items,
    this.nextPage,
    this.previousPage,
  });

  int get length => items.length;
  bool get hasNext => nextPage != null;
  bool get hasPrevious => previousPage != null;
}
