import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart'as path;

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: firebase_file_storage(),));
}

class firebase_file_storage extends StatefulWidget {

  @override
  State<firebase_file_storage> createState() => _firebase_file_storageState();
}

class _firebase_file_storageState extends State<firebase_file_storage> {

  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Store"),),
      body: Padding(padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton.icon(onPressed: () => uploadData('camera'), //ee orumethodil thanne cmerayanenki camera alllenki gallery
                                                                         // we can do this is in two functions
                    icon: Icon(Icons.camera),
                    label: Text("camera")),
                ElevatedButton.icon(onPressed: () => uploadData('gallery'),
                    icon: Icon(Icons.photo_library),
                    label: Text("camera"))
              ],
            ),
            //firebasilekk datas poyo cloudilekk store avidunn data edukkan time delay und asynchronuus function
            //ahtinu pakaramanu FutureBuilder
            //oru particular time delay ulla peration ahtinte status success aaneneki data uil kanikknm
            Expanded(child: FutureBuilder(  //ehthra data vannalum edukkan expanded
                future: loadData(),  //in future, this method is working
                //projectum firebasile datayum connect ayonn check cheyynm
                //time delay nokkn AsyncSnapshot.athillatheyum cheyyam
                //image stre aavunna keyanu lis<map>
                builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) { //all datas come to snashot
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          final Map<String,dynamic> images = snapshot.data![index];
                          return Card(
                            child: ListTile(
                              ///images and datas in firebase by using this keywords
                              ///getting images and datas by this keys
                              leading: Image.network(images['url']), //images coming froom firebase.so network image
                              title: Text(images['description']),
                              subtitle: Text(images['uploaded_by']),
                              trailing: IconButton(onPressed: ()=> delete(images['path'])
                                  , icon: Icon(Icons.delete)),
                            ),
                          );
                        });
                  }
                  return CircularProgressIndicator();
                }
            ))
          ],
        ),),
    );
  }

  Future<List<Map<String, dynamic>>> loadData() async {
    //data edukkan
    List<Map<String, dynamic>> images = [];
    //firebasile datas ivide varum. nere kodkkn pattilla ListResult nullla clas vazhiyanu kodukkunne
    final ListResult listResult = await firebaseStorage.ref().list();
    //get path .listile ella valuesum itvide varum
    final List<Reference> allfiles = listResult.items;
    await Future.forEach(allfiles, (sfile) async { //sfile-single url
      final String url = await sfile.getDownloadURL(); //get url image path
      final fullMetadata = await sfile.getMetadata();
      //fr eachile data passing
      images.add({
        'url': url,
        'path': sfile.fullPath,
        //mzuz
        'uploaded_by': fullMetadata.customMetadata?['uploaded_by'] ?? 'Nobody',
        'description': fullMetadata.customMetadata?['description'] ?? 'No description'
      });
    });
    return images;
  }

  Future<void> uploadData(String imagepath) async {
    final picker = ImagePicker();
    //ella platformilum run cheyyanulla path fech cheyyun.and also it is platform dependend
    XFile? pickedImage; //ithil imagepath indavum
    //t handle the error at the time of picking image
    try {
      pickedImage = await picker.pickImage(  //to pick image
          source: imagepath == 'camera' ? ImageSource.camera : ImageSource
              .gallery,
          maxWidth: 1920);
      //current path
      final String fileName = path.basename(  //path is dependency. and path is imported by manually as path
          pickedImage!.path);       //path - for creating path(dependency)
      //to convert android
      //fetch absolute path
      File imagefile = File(pickedImage.path); //File - is import by dart io
      try {
        await firebaseStorage.ref(fileName).putFile(imagefile,
            //Setta Meta - optional param
            SettableMetadata(customMetadata: {
              'description': 'its me',
              'uploaded_by': 'some description'
            })
        );
        //refresh Ui.it automatically works not data need
        setState(() {

        });
      } on FirebaseException catch (e) {
        print(e);
      }
    } catch (e) {
      print('Exception $e');
    }
  }

 Future<void> delete(String imagepath)async {
    await firebaseStorage.ref(imagepath).delete();
    setState(() {

    });

}
}
