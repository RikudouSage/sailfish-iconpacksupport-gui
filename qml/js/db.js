function open() {
    var db = LocalStorage.openDatabaseSync("MainDB","1.0","MainDB", 1000000);
    return db;
}
