import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:code_chronicles/core/core.dart';
import 'package:code_chronicles/models/comment_model.dart';
import 'package:code_chronicles/models/document_model.dart';
import 'package:code_chronicles/utils/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final documentModelAPIProvider = Provider((ref) {
  return DocumentModelAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realTime: ref.watch(
      appwriteRealtimeProvider,
    ),
  );
});

abstract class IDocumentModelAPI {
  Future<Document> getPostById(String id);
  FutureEither<Document> shareDocumentModel(DocumentModel documentModel);
  FutureEither<Document> shareCommentModel(Comment commentModel);
  Future<List<Document>> getDocumentModels();
  Future<List<Document>> getCommentModels(DocumentModel documentModel);
  Future<List<Document>> getDocumentModelsByAUser(String uid);
  Future<List<Document>> getDocumentModelsByTopics(String topic);
  Stream<RealtimeMessage> getLatestDocumentModel();
  Stream<RealtimeMessage> getLatestCommentModel();
  FutureEither<Document> likeDocumentModel(DocumentModel documentModel);
  FutureEither<Document> likeComment(Comment comment);
  FutureEither<Document> updateCommentCount(DocumentModel documentModel);
}

class DocumentModelAPI extends IDocumentModelAPI {
  final Databases _db;
  final Realtime _realTime;

  DocumentModelAPI({required Databases db, required Realtime realTime})
      : _db = db,
        _realTime = realTime;

  @override
  FutureEither<Document> shareDocumentModel(DocumentModel documentModel) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postsCollectionId,
        documentId: ID.unique(),
        data: documentModel.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(
          e.message ?? 'Something went wrong, please try again later',
          stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(
          e.toString(),
          stackTrace,
        ),
      );
    }
  }

  @override
  FutureEither<Document> shareCommentModel(Comment commentModel) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.commentsCollectionId,
        documentId: ID.unique(),
        data: commentModel.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(
          e.message ?? 'Something went wrong, please try again later',
          stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(
          e.toString(),
          stackTrace,
        ),
      );
    }
  }

  @override
  Future<List<Document>> getDocumentModels() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.postsCollectionId,
      queries: [
        Query.orderDesc('createdAt'),
        // Query.
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getCommentModels(DocumentModel documentModel) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.commentsCollectionId,
      queries: [
        Query.orderAsc('createdAt'),
        Query.equal('parentPostId', documentModel.id),
      ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestDocumentModel() {
    return _realTime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.postsCollectionId}.documents',
    ]).stream;
  }

  @override
  Stream<RealtimeMessage> getLatestCommentModel() {
    return _realTime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.commentsCollectionId}.documents',
    ]).stream;
  }

  @override
  FutureEither<Document> likeDocumentModel(DocumentModel documentModel) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postsCollectionId,
        documentId: documentModel.id,
        data: {
          'likes': documentModel.likes,
        },
      );
      return right(document);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(
          e.message ?? 'Something went wrong, please try again later',
          stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(
          e.toString(),
          stackTrace,
        ),
      );
    }
  }

  @override
  FutureEither<Document> likeComment(Comment comment) async {
    try {
      print(comment);
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.commentsCollectionId,
        documentId: comment.id,
        data: {
          'likes': comment.likes,
        },
      );
      return right(document);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(
          e.message ?? 'Something went wrong, please try again later',
          stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(
          e.toString(),
          stackTrace,
        ),
      );
    }
  }

  @override
  FutureEither<Document> updateCommentCount(DocumentModel documentModel) async {
    try {
      print(documentModel.commentIds);
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postsCollectionId,
        documentId: documentModel.id,
        data: {
          'commentIds': documentModel.commentIds,
        },
      );
      return right(document);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(
          e.message ?? 'Something went wrong, please try again later',
          stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(
          e.toString(),
          stackTrace,
        ),
      );
    }
  }

  @override
  Future<Document> getPostById(String id) async {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.postsCollectionId,
      documentId: id,
    );
  }

  @override
  Future<List<Document>> getDocumentModelsByAUser(String uid) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.postsCollectionId,
      queries: [
        Query.orderDesc('createdAt'),
        Query.equal('authorId', uid),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getDocumentModelsByTopics(String topic) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.postsCollectionId,
      queries: [
        Query.orderDesc('createdAt'),
        Query.search('topic', topic),
      ],
    );
    return documents.documents;
  }
}
