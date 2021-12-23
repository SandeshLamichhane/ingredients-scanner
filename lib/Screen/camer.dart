import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scanner/Bloc/bloc/chemical_bloc.dart';
import 'package:scanner/Model/chemical.dart';
import 'package:scanner/Repository/services.dart';
import 'package:scanner/data/crud.dart';
import 'package:scanner/data/recognizetext.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class CameraPage extends StatefulWidget {
  CameraPage({
    Key? key,
  }) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}
 XFile? picturefile;
class _CameraPageState extends State<CameraPage> {
  String? recognizedText;

 
  final textDetector = GoogleMlKit.vision.textDetector();
  late final chemicalBloc;

  static List<String>? _listofString;
  @override
  void initState() {
    // TODO: implement initState
    InitialService().loadchemicalsAndsync();
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    //
    chemicalBloc = BlocProvider.of<ChemicalBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChemicalBloc, ChemicalState>(
      builder: (context, state) {
        if (state is ChemicalInitial || state is ChemicalLoading) {
           
          return WillPopScope(
        onWillPop: _onBackPressed,
            child: Stack(
              children: [
                _stackContainer(),
                if (state is ChemicalLoading) _showLoader()
              ],
            ),
          );
        }

        if (state is ChemicalLoaded) {
          return showScanresult(
              getListofchemical: state.getListofchemical,
              scannedText: _listofString);
        }
        if (state is NotAnyChemicalFound) {
          return _showNotAnyChemicalFound(recognizedText);
        }

        return Scaffold(
           backgroundColor: const Color(0xffEEF3F7),
          body: Center(
            child: Text("Something went wrong"),
          ),
        );
      },
    );
  }

  ///it will pick the image from camera or file
  /////
  ///
  

  void _pickImageFromCamera() async {
  
  try{
    _listofString = [];
    if (picturefile != null) {
      final inputImage = InputImage.fromFile(File(picturefile!.path));
      final RecognisedText recognisedText =
          await textDetector.processImage(inputImage);

      String text = recognisedText.text;
      for (TextBlock block in recognisedText.blocks) {
        final Rect rect = block.rect;
        final List<Offset> cornerPoints = block.cornerPoints;
        final String text = block.text;
        final List<String> languages = block.recognizedLanguages;

        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            recognizedText =
                recognizedText??"" + "   " + element.text.toString();
            _listofString?.add(element.text.toString());
          }
        }
       
  
      }

       if (recognizedText != null) {
               setState(() {});
          // RegonizeText().splitText(recognizedText!);
          // splitText(recognizedText!);
          // call the event search chemical
          if (_listofString != null) {
            chemicalBloc.add(SearchChemical(_listofString!));
            //RegonizeText().CompareString(_listofString!);
          }
        }
    }
  }
  catch(e){
    print(e.toString());
  }
  }

  DisplayAllChemical(List<ChemicalModel>? getListofchemical) {
    return getListofchemical == null
        ? Container(child: Text("saNo e="))
        : ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: getListofchemical.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  title: Text(getListofchemical[index].chemicalName),
                  subtitle: Column(
                    children: <Widget>[
                      Text(getListofchemical[index].feature),

                      SizedBox(height: 20,),
                     const  Text("Alternative"),

                     RichText(text:
                      TextSpan(
                        children:[
                          TextSpan(
                            text: "Alternztive"
                          ),

                          TextSpan(
                            text:
                            " kjasbda kjaskd sad. kjadska jbsc  hjbadsjasd jbkasbdabkdl")
                        ]

                     ))

                    ],
                  )
                  
                  );
            });
  }

  // ###################### Header widget #############
  _headerWidget() {
       const colorizeColors = [
  Colors.purple,
  Colors.blue,
  Colors.yellow,
  Colors.red,
];

 var colorizeTextStyle = TextStyle(
  fontSize:  MediaQuery.of(context).size.height/30,
  fontFamily: 'Horizon',
  fontWeight:FontWeight.w600
);

return SizedBox(
   
  child: AnimatedTextKit(
    repeatForever:true,
    animatedTexts: [
      ColorizeAnimatedText(
        'Capture image',
        textAlign:TextAlign.center,
        textStyle: colorizeTextStyle,
        colors: colorizeColors,
      ),
      ColorizeAnimatedText(

        'Of Ingredients',
         textAlign:TextAlign.center,
        textStyle: colorizeTextStyle,
        colors: colorizeColors,
      ),

        ColorizeAnimatedText(

        'In your products',
         textAlign:TextAlign.center,
        textStyle: colorizeTextStyle,
        colors: colorizeColors,
      ),
       
    ],
    isRepeatingAnimation: true,
    onTap: () {
      print("Tap Event");
    },
  ),
);
  }
  ////////////////////////////// Image widget ########################

  _imageWidget() {
    return SizedBox(
      height: 250,
      width: double.maxFinite,
      child: picturefile == null
          ? Icon(Icons.camera_alt_outlined,
              size: MediaQuery.of(context).size.height / 7, color: Colors.grey)
          : Image.file(
              File(picturefile!.path),
              width: 300,
              height: 200,
              fit: BoxFit.fitHeight,
              scale: 2.0,
            ),
    );
  }

  _uploadImage() {
    return Material(
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton.icon(
                  onPressed: () {
                    _showmodalbottom();
                   // _pickImageFromCamera();

                  },
                  icon: Icon(Icons.camera_alt_rounded),
                  label: Text("Upload")))),
    );
  }

  _showLoader() {
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.red.withOpacity(0.2),
            child: const Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.tealAccent,
                )),
              ),
            ),
          ),
        ));
  }

  Widget _showNotAnyChemicalFound(String? scannedText) {
    return SafeArea(
      child: Scaffold(
         backgroundColor:    Color(0xFFD9F5F3),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
            
                
              const  Icon(Icons.error_outline,
                color: Colors.deepPurple,
                size: 120,),
            
            SizedBox(height:10),
                //on the 
                _createheaderForNoElement(),
                ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:  MaterialStateProperty.all(Colors.deepPurple)
                        ),
                          onPressed: () {
                            chemicalBloc.add(ChemicalInitialEvent());
                          },
                          child: Text("Try again")),
                    )),

                   SizedBox(height :20),
                     
                      Flexible(
                        child: Card(
                  elevation: 50,
          
           
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView(
                              shrinkWrap:true,
                            
                            children: [
                              Container(
                                padding:EdgeInsets.symmetric(horizontal: 10),
                                color: Colors.purple.withOpacity(0.1),
                                child:   Padding(
                                  padding:   EdgeInsets.all(8.0),
                                  child: Text("What we scanned ?",   
                                  style: TextStyle(
                                    fontFamily: "Verdana",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.indigo,
                                    fontSize: MediaQuery.of(context).size.height/44
                                    

                                  ),
                                  ),
                                ),
                              ),
                             
                              Container(
                                padding:EdgeInsets.symmetric(horizontal: 10),
                                color: Colors.purple.withOpacity(0.1),
                                child: Text(
                                               scannedText.toString(),
                                               
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  letterSpacing: 1.1,height: 1.2,
                                                  wordSpacing:1
                                                  ,

                                                  color: Colors.green[900],
                                                ), //Textstyle
                                              ),
                              ), //Te
                                                
                            ],),
                          ),
                        ),
                      )
                      ],
                    ),
              ),
            ),
          )),
    );
  }

  _createheaderForNoElement() {
    return Padding(
      padding: const EdgeInsets.only(top:20.0, bottom: 20),
      child: Text("Oops, Unable to detect any harfmull chemical.",
      textAlign:TextAlign.center,
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.height/40,
        fontFamily: "Verdana",
        color:Colors.blueGrey,
        fontWeight:FontWeight.w500,
        wordSpacing:1.1,
        letterSpacing: 1.1,
        
      ),
      ),
    );
  }

  _stackContainer() {
    return Container(
      child: SafeArea(
        child: Scaffold(
           backgroundColor:    Color(0xFFD9F5F3),
          floatingActionButton: FloatingActionButton(onPressed: ()async {
            // chemicalBloc.add(Addchemical());
            // chemicalBloc.add(Loadchemical());
            //splitText(recognizedText!);
         ChemicalDao().  getalljson();
              // chemicalBloc.add(AddChemicaltoFirestore());
               
          //  if (_listofString != null) {
             // chemicalBloc.add(SearchChemical(_listofString!));
           //   RegonizeText().CompareString(_listofString!);
           // }
          }),
          body: Column(
            children:<Widget>[
               SizedBox(height: MediaQuery.of(context).size.height/30),
             Padding(
               padding: const EdgeInsets.all(12.0),
               child: Card(
               
                 child: Padding(
                 padding: const EdgeInsets.all(12.0),
                 child: _animatedTxt(),
               )),
             ),
                SizedBox(height: MediaQuery.of(context).size.height/30),

           _scanContainer(context)
            
            ]
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async{
    bool value=false;
    await  showDialog(
    context: context,
    builder: (context) =>   AlertDialog(
      title:  Text('Are you sure?'),
      content:   Text('Do you want to exit an App'),
      actions: <Widget>[
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Text("NO"),
        ),
        SizedBox(height: 16),
         GestureDetector(
          onTap: ()  { Navigator.of(context).pop(true);
          value=true;
           },
          child: Text("YES"),
        ),
      ],
    ),
  )  ;
  return Future.value(value);
  }
// animated txt on the 
  _animatedTxt() {

return Container(
 
  child:   Row(
    children: [
      Flexible(
      
        child:  DefaultTextStyle(
      
          style:   TextStyle(
      
            fontSize: MediaQuery.of(context).size.height/35,
      
            color: Colors.red,
      
            fontFamily: 'Agne',
      
          ),
      
          child: AnimatedTextKit(
      
            repeatForever: true,
      
            animatedTexts: [
      
              TypewriterAnimatedText('Scan your product'),
      
              TypewriterAnimatedText('Know harmfull ingredients'),
      
               TypewriterAnimatedText('Avoid harmfull chemical'),
      
              TypewriterAnimatedText('Be healthy and happy'),
      
              TypewriterAnimatedText('live a long life'),
      
            ],
      
            onTap: () {
      
              print("Tap Event");
      
            },
      
          ),
      
        ),
      
      ),
    ],
  ),
);
     
 
 


  }

  _scanContainer(BuildContext context) {
    return   Flexible(
               child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                        
                  
                          _headerWidget(),
                           SizedBox(height: 10),
                  
                          _imageWidget(),
                          SizedBox(height: 15),
                          _uploadImage(),
                  
                          // ScanHarmResult(),
                          // if (state is ChemicalLoaded)
                          //  DisplayAllChemical(
                          //   state.getListofchemical,
                          // ),
                          //   ScanBeniResult()
                        ],
                      ),
                    ),
                  ),
                ),
                         ),
             );
  }

   _showmodalbottom() {
     showModalBottomSheet(
            context: context,
            // color is applied to main screen when modal bottom screen is displayed
            
            //elevates modal bottom screen
            elevation: 10,
            // gives rounded corner to modal bottom screen
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            builder: (BuildContext context) {
              return Container(
                height: 170,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Select image of ingredients",
                      style:TextStyle(
                        fontFamily: "Verdana",
                        fontWeight:FontWeight.bold,
                        color:Colors.indigo,
                        fontSize: MediaQuery.of(context).size.height/45
                      )
                      ),
                      SizedBox(height:10),
                      Flexible(child: 
                      Row(
                        crossAxisAlignment:  CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            
                            IconButton(onPressed: ()async{
                                picturefile = await ImagePicker().pickImage(source: ImageSource.camera);
                             
                                _pickImageFromCamera();
                                Navigator.pop(context);
                            }, icon: Icon(Icons.camera, size: 50,color: Colors.deepOrange,)),
                            SizedBox(width:50),
                           IconButton(onPressed: ()async{
                               picturefile = await ImagePicker().pickImage(source: ImageSource.gallery);
                                _pickImageFromCamera();
                                  Navigator.pop(context);

                           }, icon: Icon(Icons.file_copy_rounded,size: 50,color: Colors.deepPurple,))



                      ],))
                    ],
                  ),
                ),
              );
            }
     );
  }
}

class showScanresult extends StatefulWidget {
  List<ChemicalModel>? getListofchemical;
  List<String>? scannedText;
  showScanresult({Key? key, this.getListofchemical, required this.scannedText})
      : super(key: key);

  @override
  _showScanresultState createState() => _showScanresultState();
}

class _showScanresultState extends State<showScanresult> {
  late final chemicalBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
        chemicalBloc = BlocProvider.of<ChemicalBloc>(context);

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:  Color(0xFFD9F5F3),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: () {
            picturefile=null;
              BlocProvider.of<ChemicalBloc>(context).add(ChemicalInitialEvent());
          },
          child: const Icon(Icons.new_label_rounded),
        ),


        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height:20),

                  Center(child: Container(
                    child: Container(
                      child: CircleAvatar(
                        backgroundColor:Colors.deepPurple,
                        radius: 58,

                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CircleAvatar(
                            backgroundColor:Colors.white,
                            radius: 55,
                            child: CircleAvatar(

                              radius: 50,
                              backgroundImage: picturefile!=null? FileImage(File(  picturefile!.path)):
                            null
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),),

                  
                  SizedBox(height: 20,),

                  Flexible(
                      child: widget.getListofchemical == null
                          ? Center(child: Text("Oops we donot detect any Element",
                          style: TextStyle(fontWeight: FontWeight.w600, fontFamily:"Verdana",)
                          
                          ))
                          : Container(
                             color: Colors.green.withOpacity(0.1),
                            child: Card(
                              child: Container(
                                color:Colors.deepPurple.withOpacity(0.1),
                                child: ListView.builder(
                                      
                          
                          
                          
                                    itemCount: widget.getListofchemical==null?2: widget.getListofchemical!.length+2,
                                    
                          
                                    itemBuilder: (BuildContext context, int index) {
                                        if(index==0){
                                          return titleScannedResult();
                                        }
                                        if(widget.getListofchemical==null && index==1 ||
                                         widget.getListofchemical!=null &&
                                        index== widget.getListofchemical!.length+ 1)
                                        {
                                          return _showScannedText(widget.scannedText);
                          
                                        }
                                      return _listofharmfullwidget(
                                          widget.getListofchemical?[index-1], index);
                                    },
                                  ),
                              ),
                            ),
                          ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _listofharmfullwidget(ChemicalModel? getListofchemical, int index) {
    return   getListofchemical==null? Container():
    Card(
      child: Container(
        color: Colors.deepPurple.withOpacity(0.1),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            radius: 15,
            child: Text(index.toString())),
          title: Text(getListofchemical.chemicalName, 
           style:TextStyle(fontFamily: "Verdana",  fontWeight:FontWeight.bold, color:Colors.black)
          ),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            children:[
            Padding(
            padding: const EdgeInsets.only(top:4.0),
            child: Text(
                getListofchemical.feature,
                
                style: TextStyle(
                  height: 1.2,
                  letterSpacing:1.1,
                  wordSpacing:1.1,

                  fontFamily: "Verdana",
                  
                ),
                ),
          ),


            ]
          ),

          trailing: Icon(Icons.warning, color:Colors.red),
        ),
      ),
    );
  }

    _onBackPressed() {
  
}

  Widget titleScannedResult() {
    return Flexible(
      child: Container(
        color:Colors.deepPurple.withOpacity(0.2),
    child: Padding(
          padding: const EdgeInsets.only(bottom:10, top:10, left:5, right:5),
          child: Text("Harmfull ingredients on your product. ",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: "Verdana",

            color: Colors.indigo,
             fontSize: MediaQuery.of(context).size.height/50
          ),
          ),
        ),
      ),
    );
  }

  Widget _showScannedText(List<String>? scannedText) {

    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
       
        children:<Widget>[

          SizedBox(height: 30,),
          Container(
            width: double.maxFinite,
            color: Colors.deepPurple.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Extracted text from image",
              style:TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: "Verdana",

                color: Colors.blueGrey,
                 fontSize: MediaQuery.of(context).size.height/50
              ),
              
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(scannedText.toString(), 
            
            style: TextStyle(
              fontFamily: "Verdana",
              letterSpacing: 1.1,
              wordSpacing: 1,
              height: 1.5,
              fontSize:14,
              color: Colors.grey,

            ),),
          )
    
        ]
      ),
    );
  }

}
