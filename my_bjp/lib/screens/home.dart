import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:my_bjp/screens/wr_prs.dart';
import '../services/eventsFetching.dart';
import 'about/about.dart';
import '../services/fetching.dart';
import '../services/schemeListFetching.dart';
import '../templates/buttonList.dart';
import '../values/constants.dart' as Constants;

class Home extends StatelessWidget {

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: Container(
            color: Color(0xFFff8000),
            child: Column(
              children: <Widget>[
                DrawerHeader(
                  child: Column(children: <Widget>[
                    Image.asset(
                      Constants.LOGO_AS,
                      width: 80,
                      height: 80,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        Constants.MADE_BY,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                ),
                Expanded(child: ListView(children: [
                ListTile(
                  dense:true,
                  title: Text('Write to State President', 
                  style: TextStyle(color: Colors.white,fontSize: 20,)

                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => WrPrs()));
                  },
                ),
                 ListTile(
                   dense:true,
                  title: Text('About State President',
                  style: TextStyle(color: Colors.white,fontSize: 20,)
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _launchURL(Constants.ABOUT_PRESIDENT);

                  },
                ),
                 ListTile(
                   dense:true,
                  title: Text(
                    'Upcoming Events',
                     style: TextStyle(color: Colors.white,fontSize: 20,)
                    ),
                  onTap: () {
                    Navigator.pop(context);
          
                    Navigator.push(context,MaterialPageRoute(builder: (context) => EventsList()));
              
                  },
                ),
                ListTile(
                  dense:true,
                  title: Text('MANN KI BAAT',
                  style: TextStyle(color: Colors.white,fontSize: 20,)
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _launchURL(Constants.MANN_KI_BAAT);

                  },
                ),
                ListTile(
                  dense:true,
                  title: Text('About the Party',
                  style: TextStyle(color: Colors.white,fontSize: 20,)
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,MaterialPageRoute(builder: (context) => About()));
                  },
                ),
                    ListTile(
                      dense:true,
                  title: Text('Organization',
                  style: TextStyle(color: Colors.white,fontSize: 20,)
                  ),
                  onTap: () {
                    int id=0;
                    Navigator.pop(context);
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ButtonList(title:"Organization",url:"empty",data: Constants.ORG_LIST[id],start:"")));
              
                  },
                ),
                 ListTile(
                   dense:true,
                  title: Text('BJP Barta',
                  style: TextStyle(color: Colors.white,fontSize: 20,)
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _launchURL(Constants.BJP_BARTA);

                  },
                ),
                 ListTile(
                   dense:true,
                  title: Text('Donation',
                  style: TextStyle(color: Colors.white,fontSize: 20,)
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _launchURL(Constants.DONATION);              
                  },
                ),
                ])),
                Column(children: [
                  Image.asset(
                    Constants.LOGO_BLACK,
                    height: 100,
                    ),
                  Text(
                    Constants.COPYRIGHT,
                    textAlign: TextAlign.center,
                  ),
                ]),
              ],
            ),
          ),
        ),
        appBar:AppBar(
          toolbarHeight: MediaQuery.of(context).size.width*0.25,
          flexibleSpace: Image(
            image: AssetImage(Constants.APP_BAR_BANNER),
            fit: BoxFit.cover,

          ),
          bottom: TabBar(

            unselectedLabelColor: Colors.white,
            labelColor: Colors.lightGreenAccent,
            indicatorColor: Colors.red,
            indicatorWeight: 2,
            tabs: [
              Padding(padding: EdgeInsets.only(right: 50), child: 
              Tab( icon: Icon(Icons.home, size: 35,color: Colors.orange[900]), ),
              ),
               Padding(padding: EdgeInsets.only(left: 50), child: 
              Tab(icon: Icon(Icons.list, size: 35,color:Constants.BJP_GREEN))
              ),
            ],
          ),
        ),
        
        body: TabBarView(
          children: [
            FetchData(),
            FetchSchemeList(),
          ],
        ),
      ),
    )
    );
  }
}
