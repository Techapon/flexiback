import 'package:flexiback/core/enums/role.dart';
import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';
import 'package:flexiback/features/relation/data/datasources/relation_datasources.dart';
import 'package:flexiback/features/relation/domain/repositories/relation_repository.dart';

class RelationRepositoryImpl implements RelationRepository {
  final RelationDatasources datasource;

  RelationRepositoryImpl(this.datasource);

  Future<List<ProfileEntity>> getTargetUserList(Role targetRole) {
    return datasource.getTargetUserList(targetRole);
  }
}