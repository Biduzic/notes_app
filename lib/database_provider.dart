import 'package:flutter/cupertino.dart';
import 'package:notes_app/app_database.dart';

class DatabaseProvider extends ChangeNotifier{
  final AppDatabase _appDatabase=AppDatabase.db;

  List<Map<String,dynamic>> _notes=[];

  List<Map<String,dynamic>> get notes=>_notes;
  DatabaseProvider() {
    // Fetch initial notes when DatabaseProvider is created
    fetchAllNotes().then((notes) {
      _notes = notes;
      notifyListeners();
    });
  }

  //insert
  Future<bool> insertNote({required String title,required String desc})async{
    bool result=await _appDatabase.insertNote(title: title, desc: desc);
    if(result){
      _notes=await fetchAllNotes();
      notifyListeners();
    }
    return result;
  }
  //fetch
  Future<List<Map<String,dynamic>>> fetchAllNotes()async{
    List<Map<String,dynamic>> notes=await _appDatabase.fetchAllNotes();
    _notes=notes;
    notifyListeners();
    return notes;
  }
  //update
  void updateNote({required String title,required String desc,required int id})async{
     _appDatabase.updateNote(title, desc, id);
     await fetchAllNotes();
  }
  //delete
   void  deleteNote({required int id})async{
     _appDatabase.deleteNote(id);
     await fetchAllNotes();

  }
}
