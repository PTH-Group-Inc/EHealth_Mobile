class Avatar {
  final String url;
  final String publicId;
  final DateTime? uploadedAt;

  Avatar({
    required this.url,
    required this.publicId,
    this.uploadedAt,
  });
}
