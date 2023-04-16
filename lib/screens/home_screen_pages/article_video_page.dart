import 'package:any_link_preview/any_link_preview.dart';
import 'package:figma_app/base/app_constans.dart';
import 'package:figma_app/base/app_methods.dart';
import 'package:figma_app/base/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';

import '../../base/app_classes.dart';
import '../../base/article_video_base.dart';

class ArticlesVideosPage extends StatefulWidget {
  const ArticlesVideosPage({super.key});

  @override
  State<ArticlesVideosPage> createState() => _ArticlesVideosPageState();
}

class _ArticlesVideosPageState extends State<ArticlesVideosPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ValueNotifier<int> pageIndex = ValueNotifier<int>(0);
  final MyInAppBrowser browser = MyInAppBrowser();
  var options = InAppBrowserClassOptions(
    crossPlatform: InAppBrowserOptions(hideUrlBar: false),
    inAppWebViewGroupOptions: InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(javaScriptEnabled: true),
    ),
  );
  List<Article> articleData = List.generate(
    article.titles.length,
    (index) => Article(
      article.titles[index],
      article.urls[index],
    ),
  );
  List<Video> videoData = List.generate(
    article.titles.length,
    (index) => Video(
      video.titles[index],
      video.ids[index],
    ),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: pageIndex.value,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.mainBackgrounColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.mainBackgrounColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(29),
          child: ValueListenableBuilder(
            valueListenable: pageIndex,
            builder: (context, value, _) {
              return customTabBar(
                'Articles',
                'Video',
                _tabController,
                pageIndex,
              );
            },
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 40,
          left: method.hSizeCalc(20),
          right: method.hSizeCalc(20),
        ),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            ListView.builder(
              itemCount: articleData.length,
              itemBuilder: (context, index) {
                return articleContainer(
                  'article',
                  articleData[index].title,
                  articleData[index].urlLink,
                );
              },
            ),
            ListView.builder(
              itemCount: videoData.length,
              itemBuilder: (context, index) {
                return articleContainer(
                  'video',
                  videoData[index].title,
                  videoData[index].id,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget articleContainer(String tab, String title, String url) {
    return Container(
      padding: EdgeInsets.all(method.hSizeCalc(15)),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: method.hSizeCalc(10)),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                height: 1.05,
              ),
            ),
          ),
          tab == 'article'
              ? AnyLinkPreview(
                  cache: const Duration(minutes: 1),
                  onTap: () {
                    browser.openUrlRequest(
                      urlRequest: URLRequest(
                        url: Uri.parse(url),
                      ),
                      options: options,
                    );
                  },
                  link: url,
                  displayDirection: UIDirection.uiDirectionHorizontal,
                  titleStyle: const TextStyle(fontSize: 0),
                  backgroundColor: Colors.white,
                  removeElevation: true,
                  bodyMaxLines: 5,
                  bodyStyle: TextStyle(
                    color: colors.greyColor,
                    fontSize: 16,
                    height: 1.33,
                  ),
                  errorWidget: Container(
                    constraints: const BoxConstraints(
                      minHeight: 118,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text('Cannot load url'),
                    ),
                  ),
                  previewHeight: 118,
                  placeholderWidget: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    constraints: const BoxConstraints(
                      minHeight: 118,
                    ),
                    child: const Center(
                      child: Text('Loading'),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    browser.openUrlRequest(
                      urlRequest: URLRequest(
                        url: Uri.parse(method.getLinkFromId(url)),
                      ),
                      options: options,
                    );
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return PlayerPage(id: url);
                    //     },
                    //   ),
                    // );
                  },
                  child: Container(
                    constraints: const BoxConstraints(
                      maxHeight: 166,
                      minHeight: 166,
                      minWidth: double.infinity,
                    ),
                    child: FutureBuilder(
                      future: method.getVideoPreview(url),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: snapshot.data!,
                                ),
                              ),
                              SvgPicture.asset(
                                ipath.player,
                              ),
                            ],
                          );
                        } else {
                          return const Center(
                            child: SizedBox(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
