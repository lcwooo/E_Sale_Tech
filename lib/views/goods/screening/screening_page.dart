import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

class ScreeningPage extends StatefulWidget {
  ScreeningPage({this.arguments});
  final Map arguments;
  @override
  _ScreeningPageState createState() => _ScreeningPageState();
}

class _ScreeningPageState extends State<ScreeningPage> {
  int count = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("widget.title"),
        ),
        body:Container(
          // child: build11(context),
        ), 
        );
  }

  // @override
  //   Widget build(BuildContext context)
  //   {
  //       return InnerDrawer(
  //           key: _innerDrawerKey,
  //           onTapClose: true, // default false
  //           swipe: false, // default true            
  //           colorTransitionChild: Colors.white, // default Color.black54
  //           colorTransitionScaffold: Colors.black54, // default Color.black54
  //           // DEPRECATED: use offset
  //           offset: IDOffset.only( 
  //             top: 0.0, 
  //             //OR 
  //             bottom: 0.0, 
  //             right: 0.6, left: 0.0 
  //           ),
  //           leftScale: 1.0,
  //           rightScale: 1.0,
  //           scale: IDOffset.horizontal( 1.0 ),
  //           proportionalChildArea : true, 
  //           leftAnimationType: InnerDrawerAnimation.static, // default static
  //           rightAnimationType: InnerDrawerAnimation.linear,
  //           backgroundDecoration: BoxDecoration(color: Colors.white ), // default  Theme.of(context).backgroundColor
            
  //           //when a pointer that is in contact with the screen and moves to the right or left            
  //           onDragUpdate: (double val, InnerDrawerDirection direction) {
  //               // return values between 1 and 0
  //               print(val);
  //               // check if the swipe is to the right or to the left
  //               print(direction==InnerDrawerDirection.start);
  //           },
            
  //           innerDrawerCallback: (a) => print(a), // return  true (open) or false (close)
  //           // leftChild: Container(),
  //           rightChild: Container(), // required if leftChild is not set
  //           scaffold: Scaffold(
  //               appBar: AppBar(
  //                   automaticallyImplyLeading: false
  //               ),
  //           ),
  //           //OR
  //           // CupertinoPageScaffold(                
  //           //     navigationBar: CupertinoNavigationBar(
  //           //         automaticallyImplyLeading: false
  //           //     ), child: Text("2222"),
  //           // ), 
  //       );
  //   }
    
    //  Current State of InnerDrawerState
    final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();    

    void _toggle()
    {
       _innerDrawerKey.currentState.toggle(
       // direction is optional 
       // if not set, the last direction will be used
       //InnerDrawerDirection.start OR InnerDrawerDirection.end                        
        direction: InnerDrawerDirection.end 
       );
    }
}

