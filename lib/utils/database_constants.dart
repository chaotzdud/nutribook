abstract class Constants {
  // DATABASE CONSTANTS
  static const databaseName = 'nutribook.db';

  static const users = {
    'tableName': 'users',
    'createTable': 'CREATE TABLE users (name TEXT PRIMARY KEY, photo TEXT, birthDate TEXT);', 
  };

  static const foods = {
    'tableName': 'foods',
    'createTable': 'CREATE TABLE foods (name TEXT PRIMARY KEY, photo TEXT, category TEXT, type TEXT);', 
  };

  static const menus = {
    'tableName': 'menus',
    'createTable': 'CREATE TABLE IF NOT EXISTS menus (id INTEGER PRIMARY KEY , userName TEXT NOT NULL, breakfast TEXT NOT NULL, lunch TEXT NOT NULL, dinner TEXT);'
  };
}
