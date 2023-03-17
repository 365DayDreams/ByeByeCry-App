import 'package:bye_bye_cry_new/compoment/utils/color_utils.dart';
import 'package:bye_bye_cry_new/start_page.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownLoadScreen extends StatefulWidget {
  const DownLoadScreen({Key? key}) : super(key: key);

  @override
  State<DownLoadScreen> createState() => _DownLoadScreenState();
}

class _DownLoadScreenState extends State<DownLoadScreen> {

  late Future<ListResult> futureFile;

  double downloadData =0.0;
  Future downLoadFile (Reference reference)async{
    final url = await reference.getDownloadURL();
    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}/ ${reference.name}";
    //await reference.writeToFile(file);
    await Dio().download(url, path,
        onReceiveProgress: (receive,total){
          double progress = receive/ total;


          setState(() {
            downloadData = progress;

          });
        }

    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Downloade${reference.name}")));

    // showDialog(context: context, builder: (_){
    //   return AlertDialog(
    //     title: Text("Bye Bye Cry",),
    //     content: SingleChildScrollView(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Center(child: Text("Downloaded Audio File",style: TextStyle(
    //               fontSize: 20,
    //             ),)),
    //           ),
    //
    //           downloadData!=null ? Center(
    //             child: CircularProgressIndicator(
    //               color: Colors.blue,
    //             ),
    //           ) : Container(),
    //
    //           // downloadData!=null ? Padding(
    //           //   padding: const EdgeInsets.all(8.0),
    //           //   child: Center(
    //           //     child: Text("$downloadData",style: TextStyle(
    //           //         fontSize: 22
    //           //     ),),
    //           //   ),
    //           // ) : Container(),
    //
    //         ],
    //
    //       ),
    //     ),
    //   );
    // });


  }
  @override
  void initState() {

    super.initState();
    futureFile =   FirebaseStorage.instance.ref("/musicFile").listAll();
    futureFile.then((value) {
      value.items.forEach((element) {
        downLoadFile(element);

      });

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.menu,color:primaryPinkColor ,))
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Download",style: TextStyle(
          fontSize: 18,color: primaryPinkColor,
          fontWeight: FontWeight.bold
        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            SizedBox(height: 50,),
            Center(
              child: Image.asset("asset/images/newlogo.png",height: 250,width: double.infinity,fit: BoxFit.contain,),
            ),
            SizedBox(height: 30,),

            Padding(
              padding: const EdgeInsets.only(left: 18.0,right: 19),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  minHeight: 20,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryPinkColor),

                  value: downloadData,
                ),
              ),
            ),
            SizedBox(height: 20,),

            Text("Preparing your sounds...",style: TextStyle(
                fontSize: 18,color: primaryPinkColor,
                fontWeight: FontWeight.bold
            ),),

            SizedBox(height: 50,),
            
            
            
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=> StartPage()));
              },
              child: Container(
                alignment: Alignment.center,
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                  color: primaryPinkColor,
                  borderRadius: BorderRadius.circular(20.0),

                ),
                child: Text("Ok",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),),
              ),
            )
            
            



          ],
        ),
      ),
    );
  }
}
