import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/common/widgets/app_bar_widget.dart';
import 'package:barbell/core/services/storage_service.dart';
import 'package:barbell/core/utils/constants/sizer.dart';
import 'package:barbell/core/utils/constants/svg_path.dart';
import 'package:barbell/features/tips/controllers/article_controller.dart';
import 'package:barbell/features/tips/controllers/video_controller.dart';
import 'package:barbell/features/tips/view/fitness_tips_articles_screen.dart';
import 'package:barbell/features/tips/view/fitness_tips_video_screen.dart';
import 'package:barbell/features/tips/view/upload_tips_screen.dart';
import 'package:barbell/features/tips/widgets/tips_home_card.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ArticleController articleController = Get.put(ArticleController());
    final VideoController videoController = Get.put(VideoController());
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Fitness Tips & Blog',
        showNotification: true,
        showBackButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    videoController.loadVideosFromAPI(isRefresh: true);
                    Get.to(() => const FitnessTipsVideoScreen());
                  },
                  child: TipsTabCard(
                    label: 'Video',
                    icon: SvgPath.playButtonSvg,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    articleController.loadArticlesFromAPI(isRefresh: true);
                    Get.to(() => FitnessTipsScreen());
                  },
                  child: TipsTabCard(label: 'Articles', icon: SvgPath.article),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    videoController.loadSavedVideosFromAPI(isRefresh: true);
                    Get.to(() => const FitnessTipsVideoScreen(isSaved: true));
                  },
                  child: TipsTabCard(
                    label: 'Save Video',
                    icon: SvgPath.saveTag,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    articleController.loadSavedArticlesFromAPI(isRefresh: true);
                    Get.to(() => FitnessTipsScreen(isSaved: true));
                  },
                  child: TipsTabCard(
                    label: 'Save Articles',
                    icon: SvgPath.saveTag,
                  ),
                ),
              ],
            ),

            Spacer(),
            if (StorageService.role == 'admin')
              Column(
                children: [
                  // Videos Tip Upload
                  _buildUploadButton(
                    label: 'Upload New Video Tip',
                    onTap: () {
                      // Get.to(() => TestScreen());

                      Get.to(
                        () => UploadTipsScreen(
                          appBarTitle: 'Upload New Video Tip',
                          isVideo: true,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  // Artical Tip Upload
                  _buildUploadButton(
                    label: 'Upload New Article',
                    onTap: () {
                      Get.to(
                        () =>
                            UploadTipsScreen(appBarTitle: 'Upload New Article'),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        fixedSize: Size(Sizer.wp(350), 56),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide(color: Color(0xff373D02), width: 0.86),
      ),
      onPressed: onTap,
      label: Text(
        label,
        style: getTextStyleWorkSans(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w400,
          height: 2.22,
        ),
      ),
      icon: SvgPicture.asset(SvgPath.uploadIcon),
    );
  }
}
