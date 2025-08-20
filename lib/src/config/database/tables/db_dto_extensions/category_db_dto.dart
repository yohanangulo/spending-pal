part of 'db_dto_extensions.dart';

extension CategoryDbDtoExtension on CategoryDbDto {
  Category toDomain() {
    return Category(
      id: id.toString(),
      name: name,
      icon: IconData(icon, fontFamily: 'MaterialIcons'),
      color: Color(color),
      expenseCount: 0,
    );
  }
}
