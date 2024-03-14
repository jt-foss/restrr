import 'package:restrr/src/internal/requests/responses/rest_response.dart';

class PaginatedResponseMetadataLinks {
  final String prev;
  final String next;

  const PaginatedResponseMetadataLinks({
    required this.prev,
    required this.next,
  });

  factory PaginatedResponseMetadataLinks.fromJson(Map<String, dynamic> json) {
    return PaginatedResponseMetadataLinks(
      prev: json['prev'],
      next: json['next'],
    );
  }
}

class PaginatedResponseMetadata {
  final int page;
  final int limit;
  final int total;
  final PaginatedResponseMetadataLinks links;

  const PaginatedResponseMetadata({
    required this.page,
    required this.limit,
    required this.total,
    required this.links,
  });

  factory PaginatedResponseMetadata.fromJson(Map<String, dynamic> json) {
    return PaginatedResponseMetadata(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      links: PaginatedResponseMetadataLinks.fromJson(json['links']),
    );
  }
}

class PaginatedResponse<T> extends RestResponse<List<T>> {
  final PaginatedResponseMetadata? metadata;

  const PaginatedResponse({
    required super.statusCode,
    super.data,
    this.metadata,
  });
}
