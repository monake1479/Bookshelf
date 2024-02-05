# Bookshelf

## General info


Project created using Flutter for the Windows and Linux platforms. The application was designed to explore Flutter desktop capabilities and manage SQLite database. Bookshelf is capable of managing a small database for storing Books and Authors. It autonomously creates the database and allows for the importation of an existing one previously created. Database operations can be performed through a graphical user interface (GUI) as well as a built-in terminal.

Bookshelf use Flutter Version Manager `fvm` (https://fvm.app/).

## Technoglogies
Flutter:
- `3.7.8 version`<br>
State management: 
- `Riverpod`<br>
Database connection:
- `sqflite`
- `sqflite_common_ffi`
- `sqlite3_flutter_libs`

## Installation

### Requirements 
- Windows or Linux operating system
- Any IDE with Flutter support
- `fvm` installed (https://fvm.app/docs/getting_started/installation)

### Usage
- Open Bookshelf in your IDE
- Run `fvm use` command in terminal
- Run `fvm flutter pub get` command in terminal
- Run `fvm flutter pub run build_runner build --delete-conflicting-outputs` command in terminal
- Run `fvm flutter run` command in terminal


