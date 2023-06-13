import 'package:ztp_projekt/common/models/table_name.dart';

String createBooksTableQuery =
    'CREATE TABLE `${TableName.books.name}` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , `authorId` INTEGER NOT NULL , `title` TEXT NOT NULL ,`publisher` TEXT NOT NULL , `publicationDate` TEXT NOT NULL , `isbnNumber` TEXT NOT NULL , `price` DOUBLE NOT NULL ,  FOREIGN KEY(authorId) REFERENCES ${TableName.authors.name}(id)) ';
String createAuthorsTableQuery =
    'CREATE TABLE `${TableName.authors.name}` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , `firstName` TEXT NOT NULL , `lastName` TEXT NOT NULL )';
String getAllBooks =
    "select books.id, authors.firstName || ' ' || authors.lastName as authorName, books.authorId, books.title, books.publisher, books.publicationDate, books.isbnNumber, books.price from books INNER JOIN authors on authors.id==books.authorId";
String getBook =
    "select books.id, authors.firstName || ' ' || authors.lastName as authorName, books.authorId, books.title, books.publisher, books.publicationDate, books.isbnNumber, books.price from books INNER JOIN authors on authors.id==books.authorId where books.id=={id} ";
const List<Map<String, Object?>> initAuthorsTable = [
  {
    'id': null,
    'firstName': 'Jan',
    'lastName': 'Kowalski',
  },
  {
    'id': null,
    'firstName': 'Adam',
    'lastName': 'Nowak',
  },
  {
    'id': null,
    'firstName': 'Karol',
    'lastName': 'Andrysiewicz',
  },
];
const List<Map<String, Object?>> initBooksTable = [
  {
    'id': null,
    'authorId': 1,
    'title': 'Wędrowycz',
    'publisher': 'Biblioteka słów',
    'publicationDate': '2000-08-10 23:59:59.100',
    'isbnNumber': '978-0-7334-2609-4',
    'price': 29.99,
  },
  {
    'id': null,
    'authorId': 2,
    'title': 'Metro 2033',
    'publisher': 'Słowozbiór',
    'publicationDate': '2010-05-05 23:59:59.100',
    'isbnNumber': '321-4-7647-5760-4',
    'price': 24.75,
  },
  {
    'id': null,
    'authorId': 3,
    'title': 'Wodogrzmoty Małe',
    'publisher': 'Kaszaloty małe',
    'publicationDate': '1999-08-04 23:59:59.100',
    'isbnNumber': '321-4-7647-5760-4',
    'price': 14.75,
  },
];
