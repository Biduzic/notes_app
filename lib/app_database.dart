import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase{
   AppDatabase._();

  static final AppDatabase db=AppDatabase._();
  static const String DBNAME="notes.db";
  static const String TABLE_NOTE="noted";
  static const String COLUMN_NOTE_ID="n_id";
  static const String COLUMN_NOTE_TITLE="n_title";
  static const String COLUMN_NOTE_DESC="n_desc";

  Database? mDB;

  Future<Database> getDB()async{
    if(mDB!=null){
      return mDB!;
    }else{
      return await openDB();
    }
  }
  Future<Database> openDB()async{
    var rootPath=await getApplicationDocumentsDirectory();
    var dbPath=join(rootPath.path,DBNAME);

    return await openDatabase(dbPath,version: 1,onCreate: (db,version){

      db.execute("create table $TABLE_NOTE ($COLUMN_NOTE_ID integer primary key autoincrement, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text )");
    });
  }

  //create(insert)
  Future<bool> insertNote({required String title, required String desc})async{
           var mainDB=await getDB();
          int rowsEffect=await mainDB.insert(TABLE_NOTE, {
             COLUMN_NOTE_TITLE:title,
             COLUMN_NOTE_DESC:desc,

           });
          return rowsEffect>0;
  }
  //read(fetch)
  Future<List<Map<String,dynamic>>> fetchAllNotes()async{
    var mainDB=await getDB();
    List<Map<String,dynamic>> mNotes=await mainDB.query(TABLE_NOTE);
    return mNotes;
  }
  void updateNote(String title,String desc,int id)async{
    var mainDB=await getDB();
    mainDB.update(TABLE_NOTE, {
      COLUMN_NOTE_TITLE:title,
      COLUMN_NOTE_DESC:desc,

    },where: "$COLUMN_NOTE_ID=$id");
  }
  void deleteNote(int id)async{
    var mainDB=await getDB();
    mainDB.delete(TABLE_NOTE);
  }
}