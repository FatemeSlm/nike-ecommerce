import 'package:flutter/material.dart';
import 'package:nike_ecommerce/common/utils.dart';
import 'package:nike_ecommerce/data/banner.dart';
import 'package:nike_ecommerce/ui/widgets/image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerSlider extends StatelessWidget {
  final PageController _controller = PageController();
  final List<BannerEntity> banners;
  BannerSlider({
    Key? key,
    required this.banners,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Stack(
        children: [
          PageView.builder(
            physics: defaultScrollPhsics,
              controller: _controller,
              itemCount: banners.length,
              itemBuilder: ((context, index) =>
                  _Slide(banner: banners[index]))),
          Positioned(
            left: 0,
            right: 0,
            bottom: 8,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: banners.length,
                axisDirection: Axis.horizontal,
                effect:  WormEffect(
                    spacing: 4.0,
                    radius: 4.0,
                    dotWidth: 18.0,
                    dotHeight: 2.0,
                    paintStyle: PaintingStyle.fill,
                    strokeWidth: 1.5,
                    dotColor: Colors.grey.shade400,
                    activeDotColor: Theme.of(context).colorScheme.onBackground),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({
    Key? key,
    required this.banner,
  }) : super(key: key);

  final BannerEntity banner;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: ImageLoadingService(
        imageUrl: banner.image,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
