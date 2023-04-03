const String booksTableName = 'books';
const String authorsTableName = 'authors';

// 'CREATE TABLE `$databaseName`.`$booksTableName` (`id` INT NOT NULL AUTO_INCREMENT , `authorId` INT NOT NULL , `publisher` TEXT NOT NULL , `publicationDate` TEXT NOT NULL , `isbnNumber` TEXT NOT NULL , `price` DOUBLE NOT NULL , PRIMARY KEY (`id`), INDEX `authorId` (`authorId`)) ';
const String createBooksTableQuery =
    'CREATE TABLE `$booksTableName` (`id` INT NOT NULL AUTO_INCREMENT , `authorId` INT NOT NULL , `title` TEXT NOT NULL ,`publisher` TEXT NOT NULL , `publicationDate` TEXT NOT NULL , `isbnNumber` TEXT NOT NULL , `price` DOUBLE NOT NULL , PRIMARY KEY (`id`), INDEX `authorId` (`authorId`)) ';
const String createAuthorsTableQuery =
    'CREATE TABLE `$authorsTableName` (`id` INT NOT NULL AUTO_INCREMENT , `firstName` TEXT NOT NULL , `lastName` TEXT NOT NULL , PRIMARY KEY (`id`))';

const String initAuthorsTable =
    "INSERT INTO `$authorsTableName` (`id`, `firstName`, `lastName`) VALUES (NULL, 'Jan', 'Kowalski'), (NULL, 'Adam', 'Nowak'),(NULL, 'Karol', 'Andrysiewicz')";

const String initBooksTable =
    "INSERT INTO `$booksTableName` (`id`, `authorId`, `publisher`, `publicationDate`, `isbnNumber`, `price`) VALUES (NULL, '1', 'Wędrowycz', 'Biblioteka słów', '2000-08-10 23:59:59:100', '978-0-7334-2609-4', '29.99'),(NULL, '2', 'Metro 2033', 'Słowozbiór', '2010-05-05 23:59:59:100', '321-4-7647-5760-4', '24,75'),(NULL, '3', 'Wodogrzmoty Małe', 'Kaszaloty małe', '1999-08-04 23:59:59:100', '321-4-7647-5760-4', '14,75')";
