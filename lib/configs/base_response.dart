class BaseResponse {
  String? id;
  String? collectionId;
  String? databaseId;
  String? createdAt;
  String? updatedAt;

  BaseResponse(
      {this.id,
      this.collectionId,
      this.databaseId,
      this.createdAt,
      this.updatedAt});

  BaseResponse.fromMap(Map<String, dynamic> map) {
    id = map['\$id'].toString();
    collectionId = map['\$collectionId'].toString();
    databaseId = map['\$databaseId'].toString();
    createdAt = map['\$createdAt'].toString();
    updatedAt = map['\$updatedAt'].toString();
  }
}
