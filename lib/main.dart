import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() { 
    super.initState();
  }

Future<List<News>> _getNews() async{

  var data = await http.get('https://newsapi.org/v2/top-headlines?country=in&apiKey=e9cc18d3d4cd41639a4a43e4f93e9f2a');


  var jsonData =  json.decode(data.body);

  var newsData = jsonData['articles'];

  List<News> news = [];

  for(var u in newsData){
    News newsItem = News(u['title'], u['description'], u['author'],u['urlToImage'],u['publishedAt']);
    news.add(newsItem);
  }
  return news;
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      
      body:Container(            
            child: FutureBuilder(
              future: _getNews(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.data == null){

                  return Container(
                    child:Center(
                      child: CircularProgressIndicator(),)
                  );

                }else{

                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){

                    return InkWell(
                      onTap: (){
                            News news = new News(snapshot.data[index].title, snapshot.data[index].description, snapshot.data[index].author, snapshot.data[index].urlToImage,snapshot.data[index].publishedAt);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => new Details(news: news,)));
                             },
                      child: Card(
                        child: Row(
                          children: <Widget>[

                            Container(
                              width: 120.0,
                              height: 110.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(topLeft: const Radius.circular(8.0), bottomLeft: const Radius.circular(8.0)),
                                child: Image.network(snapshot.data[index].urlToImage, width: 100.0, fit:BoxFit.fill, )),

                            ),

                            Expanded(
                              child: ListTile(
                                  title: Text(snapshot.data[index].title),
                                  subtitle: Text(snapshot.data[index].author == null ? 'Unkonwn': snapshot.data[index].author),
                                  )
                            )
                          ],
                        
                          
                        ),
                      ),
                    );
                  
                    
                  },
                );
                }
              },
            ),
            
          ));

        }
}



class News{

  final String title;
  final String description;
  final String author;
  final String urlToImage;
  final String publishedAt;

  News(this.title,this.description,this.author,this.urlToImage,this.publishedAt);

}

 class Details extends StatelessWidget {
   final News news;
   Details({this.news});
 


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 400.0,
                    child: Image.network('${this.news.urlToImage}', fit: BoxFit.fill,),
                  ),

                  AppBar(
                    backgroundColor: Colors.transparent,
                    leading: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios)),
                    elevation: 0,
                  )

                ],
              
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),

                child: Column(
  
                  children: <Widget>[
                    SizedBox( height: 10.0,),
                    Text('${this.news.title}', style: TextStyle(color: Colors.black87, fontSize: 20.0, fontWeight: FontWeight.bold , letterSpacing: 0.2, wordSpacing: 0.6),),

                    SizedBox(
                       height: 20.0,),
                    Text('${this.news.description}',style: TextStyle(color: Colors.black54, fontSize: 16.0, letterSpacing: 0.2, wordSpacing: 0.3),),

                    SizedBox( height: 20.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(this.news.author == null ? 'Unkonwn': this.news.author, style: TextStyle(color: Colors.grey),),
                        Text('${this.news.publishedAt}', style: TextStyle(color: Colors.grey),)
                      ],
                    )
                  ],
                ),
              ),

            
            ],),),
          ),
    );
  }
}


