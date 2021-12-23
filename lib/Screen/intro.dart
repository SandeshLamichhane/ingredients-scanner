import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:scanner/Screen/camer.dart';


class intro extends StatefulWidget {
  const intro({ Key? key }) : super(key: key);

  @override
  _introState createState() => _introState();
}

class _introState extends State<intro> {
  
   final pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: TextStyle(fontSize: 19.0),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: 
               Container(
                 
               
                 child: IntroductionScreen(
                    pages: _listPagesViewModel(),
                    onDone: () {
                    // When done button is press
                           // You can also override onSkip callback
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder){

                      return CameraPage();

                    }));
                    },
                    onSkip: () {
                    // You can also override onSkip callback
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder){

                      return CameraPage();

                    }));
                     
                    },
                    showSkipButton: true,
                    skip:  const Text("Skip", style: TextStyle(color: Colors.deepPurple, 
                    fontWeight: FontWeight.w600),),
                    next:  const Icon(Icons.skip_next),
                    done:   Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Done", style: 
                        TextStyle(fontWeight: FontWeight.w800,
                        fontSize: MediaQuery.of(context).size.height/30,
                         color:Colors.orange)),
                      ),
                    ),
                    dotsDecorator: DotsDecorator(
                    size: const Size.square(10.0),
                    activeSize: const Size(20.0, 10.0),
                    activeColor: Theme.of(context).accentColor,
                    color: Colors.black26,
                    spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)
                    )
                    ),
                  ),
               ),
            ),
          
      
        
      
    );
  }

  _listPagesViewModel() {
    return   [
        PageViewModel(
          title: "Detect Deadly Chemicals",
          body:
              "Scan the harmfull  ingredients from daily products.",
          image: _buildImage('assets/4.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Stay healthy !",
          body:
              "you can skip that product which contain, harmfull ingredients.",
          image: _buildImage('assets/2.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Dont be fool ?",
          body:
              "Don't be fool by the brand.  Check the ingredients only then use it.",
          image: _buildImage('assets/3.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Pursue your dream",
          body:
              "be healthy, be happy and chase your dream.",
          image: _buildFullscrenImage(),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
          ),
        )];
  }

  
 Widget _buildFullscrenImage() {
    return Image.asset(
      'assets/4.png',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset(assetName);
  }
}