import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            color: Color(0xFF515151)
          )
        )
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  TabController tabController;
  List posts = [];
  List newPosts = [];
  List bestPosts = [];
  bool showHeader = true;
  final Color whiteColor = Colors.white;
  final Color greyColor = Colors.grey;
  final Widget sizedBox10 = SizedBox(height: 10);

  @override
  void initState() {
    super.initState();

    this._fetchData();

    tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _fetchData() async {
    String stringData = await rootBundle.loadString('assets/posts.json');
    setState(() {
      posts = jsonDecode(stringData);
      newPosts = posts.where((post) => post['status'] == 'new').toList();
      bestPosts = posts.where((post) => post['status'] == 'best').toList();
    });
  }

  Widget header() {
    if (showHeader) {
      return Container(
        color: Color(0xFF5C80FF),
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.arrow_forward,
                      color: whiteColor,
                      size: 15,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Тема дня',
                      style: TextStyle(
                        fontSize: 15,
                        color: whiteColor,
                      ),
                    ),
                  ]
                ),
                InkWell(
                  onTap: () => {
                    setState(() {
                      showHeader = false;
                    })
                  },
                  child: Icon(
                    Icons.close,
                    size: 28,
                    color: whiteColor,
                  ),
                ),
              ]
            ),
            sizedBox10,
            Text(
              'А как Вы называете друг друга?',
              style: TextStyle(
                fontSize: 25,
                color: whiteColor,
                fontWeight: FontWeight.w600
              ),
            )
          ]
        ),
      );
    }
    return Container();
  }

  Widget getTabBar() {
    return TabBar(
      controller: tabController,
      labelPadding: EdgeInsets.symmetric(vertical: 4.0),
      labelColor: Color(0xFF515151),
      unselectedLabelColor: Color(0xFF98A1B9),
      labelStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold
      ),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
            width: 4.0,
            color: Color(0xFF5C80FF),
        )
      ),
      tabs: [
        Tab(text: 'Новые'),
        Tab(text: 'Популярные'),
        Tab(text: 'Подписки'),
      ]
    );
  }

  Widget getTabBarPages() {
    return TabBarView(
      controller: tabController,
      children: <Widget>[
        postsList(newPosts),
        postsList(bestPosts),
        postsList(posts)
      ]
    );
  }

  Widget postsList(List<dynamic> posts) {
    return Container(
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          return post(posts[index]);
        }
      ),
    );
  }

  Widget promo(String image) {
    if (image != null) {
      return Container(
        padding: EdgeInsets.only(top: 10),
        child: Image.network(
          image
        )
      );
    }

    return Container();
  }

  Widget post(dynamic post) {
    return Container(
        color: whiteColor,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: <Widget>[
                  avatar(post['author_avatar']),
                  SizedBox(width: 10),
                  Text(
                    post['author_name'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    width: 40,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Color(0xFFFF00FF),
                      borderRadius: BorderRadius.all(
                          Radius.circular(100)
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '1г2м',
                        style: TextStyle(
                            fontSize: 12,
                            color: whiteColor
                        ),
                      )
                    )
                  ),
                  SizedBox(width: 15),
                  Container(
                    width: 30,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Color(0xFF5C80FF),
                      borderRadius: BorderRadius.all(
                          Radius.circular(100)
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '2н',
                        style: TextStyle(
                            fontSize: 12,
                            color: whiteColor
                        ),
                      )
                    )
                  )
                ]
              ),
            ),
            promo(post['image']),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    post['title'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  sizedBox10,
                  Text(
                    post['description'],
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15
                    ),
                  ),
                  sizedBox10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        post['created_at'],
                        style: TextStyle(
                          fontSize: 12,
                          color: greyColor
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.arrow_forward,
                            color: greyColor,
                            size: 12,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'От рождения до года',
                            style: TextStyle(
                              fontSize: 12,
                              color: greyColor
                            ),
                          ),
                        ]
                      ),
                    ]
                  ),
                  SizedBox(height: 5),
                  Divider(
                    color: greyColor
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () => {},
                                child: Icon(
                                  Icons.favorite_border,
                                  size: 28,
                                  color: greyColor
                                ),
                              ),
                              SizedBox(width: 3),
                              Text(
                                '12',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: greyColor
                                ),
                              ),
                            ]
                          ),
                          SizedBox(width: 10),
                          Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () => {},
                                child: Icon(
                                  Icons.insert_comment,
                                  size: 28,
                                  color: greyColor
                                ),
                              ),
                              SizedBox(width: 3),
                              Text(
                                '40',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: greyColor
                                ),
                              ),
                            ]
                          ),
                          SizedBox(width: 20),
                          InkWell(
                            onTap: () => {},
                            child: Icon(
                              Icons.redo,
                              size: 28,
                              color: greyColor
                            ),
                          ),
                        ]
                      ),
                      InkWell(
                        onTap: () => {},
                        child: Icon(
                          Icons.star_border,
                          size: 30,
                          color: greyColor
                        ),
                      ),
                    ]
                  )
                ],
              )
            )
          ]
        )
    );
  }

  Widget avatar(String avatarUrl) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
            Radius.circular(100)
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
            Radius.circular(100),
        ),
        child: Image.network(
          avatarUrl,
          fit: BoxFit.cover,
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {},
          icon: Icon(
            Icons.menu,
            size: 28
          ),
        ),
        title: Text(
          'News',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
          ),
        ),
        backgroundColor: whiteColor,
        bottom: getTabBar(),
        actions: <Widget>[
          IconButton(
            onPressed: () => {},
            icon: Icon(
              Icons.location_on,
              size: 28
            ),
          ),
          IconButton(
            onPressed: () => {},
            icon: Icon(
              Icons.search,
              size: 28
            ),
          ),
        ],
      ),
      body: Column(
          children: <Widget>[
            header(),
            Expanded(
              child: getTabBarPages()
            )
          ],
        )
      
    );
  }
}
