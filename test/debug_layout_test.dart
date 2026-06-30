import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/core/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Debug ScreenUtil scale', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await initDependencies();

    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const EcommerceApp());
    await tester.pumpAndSettle();

    print('ScreenUtil.screenWidth: ${ScreenUtil().screenWidth}');
    print('ScreenUtil.screenHeight: ${ScreenUtil().screenHeight}');
    print('ScreenUtil.scaleWidth: ${ScreenUtil().scaleWidth}');
    print('ScreenUtil.scaleHeight: ${ScreenUtil().scaleHeight}');
    print('ScreenUtil.scaleText: ${ScreenUtil().scaleText}');
    print('30.sp evaluates to: ${30.sp}');
    print('30.w evaluates to: ${30.w}');
  });
}
