import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:guava/const/resource.dart';
import 'package:guava/core/resources/extensions/context.dart';
import 'package:guava/core/styles/colors.dart';
import 'package:guava/widgets/utility_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(),
                      SizedBox(width: 10.w),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                            text: 'Hey\n',
                            style: context.medium.copyWith(
                                color: hexColor('#B0B7B1'), fontSize: 12.sp)),
                        TextSpan(
                            text: 'Vwegba',
                            style: context.medium.copyWith(
                                color: BrandColors.light, fontSize: 16.sp))
                      ])),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(R.ASSETS_IMAGES_SCAN_BUTTON_PNG,
                          height: 20.h),
                      SizedBox(width: 20.w),
                      Image.asset(R.ASSETS_IMAGES_NOTIFICATION_BUTTON_PNG,
                          height: 20.h),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.w),
                          padding: EdgeInsets.symmetric(
                              vertical: 5.h, horizontal: 10.w),
                          decoration: ShapeDecoration(
                              color: hexColor('#334e48'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              )),
                          child: Text(
                            'Main Wallet',
                            style: context.medium.copyWith(
                                color: BrandColors.light, fontSize: 12.sp),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.h, horizontal: 10.w),
                          decoration: ShapeDecoration(
                              color: hexColor('#334e48'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              )),
                          child: Row(
                            children: [
                              Text(
                                'UFQ_....BfSs ',
                                style: context.medium.copyWith(
                                    color: hexColor('#B0B7B1'),
                                    fontSize: 12.sp),
                              ),
                              Image.asset(R.ASSETS_IMAGES_COPY_BUTTON_PNG,
                                  height: 12.h)
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Balance',
                            style: context.semiBold.copyWith(
                                color: BrandColors.light, fontSize: 14.sp),
                          ),
                          Row(
                            children: [
                              Text(
                                '0.00',
                                style: context.medium.copyWith(
                                    color: BrandColors.light, fontSize: 36.sp),
                              ),
                              SizedBox(width: 10.w),
                              Icon(Icons.visibility, color: BrandColors.light)
                            ],
                          ),
                          Text(
                            '0.00 USDC',
                            style: context.semiBold.copyWith(
                                color: hexColor('#B0B7B1'), fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.w),
                      padding: EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 20.w),
                      decoration: ShapeDecoration(
                          color: hexColor('#334e48'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                R.ASSETS_IMAGES_TRANSFER_BTN_PNG,
                                height: 48.h,
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                'Transfer',
                                style: context.medium.copyWith(
                                    color: BrandColors.light, fontSize: 12.sp),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Image.asset(
                                R.ASSETS_IMAGES_RECEIVE_BTN_PNG,
                                height: 48.h,
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                'Recieve',
                                style: context.medium.copyWith(
                                    color: BrandColors.light, fontSize: 12.sp),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Image.asset(
                                R.ASSETS_IMAGES_GUAVA_PAY_BTN_PNG,
                                height: 48.h,
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                'Guava Pay',
                                style: context.medium.copyWith(
                                    color: BrandColors.light, fontSize: 12.sp),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 5.h),
                    SizedBox(
                      height: 104.h,
                      child: PageView(
                        children: [
                          Image.asset(
                            R.ASSETS_IMAGES_HOME_SLIDER1_PNG,
                            height: 100.h,
                          ),
                          Image.asset(
                            R.ASSETS_IMAGES_HOME_SLIDER2_PNG,
                            height: 100.h,
                          ),
                          Image.asset(
                            R.ASSETS_IMAGES_HOME_SLIDER3_PNG,
                            height: 100.h,
                          ),
                          Image.asset(
                            R.ASSETS_IMAGES_HOME_SLIDER4_PNG,
                            height: 100.h,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Categories',
                            style: context.medium
                                .copyWith(color: Colors.white, fontSize: 16.sp),
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding:
                                      EdgeInsets.fromLTRB(25.w, 20.h, 0, 20.h),
                                  decoration: ShapeDecoration(
                                      color: hexColor('#D4A441'),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                      )),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        R.ASSETS_IMAGES_SAVINGS_PNG,
                                        height: 18.h,
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        'Savings',
                                        style: context.medium.copyWith(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Container(
                                  padding:
                                      EdgeInsets.fromLTRB(25.w, 20.h, 0, 20.h),
                                  decoration: ShapeDecoration(
                                      color: hexColor('#599DB0'),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                      )),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        R.ASSETS_IMAGES_ESCROW_PNG,
                                        height: 18.h,
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        'Escrow',
                                        style: context.medium.copyWith(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding:
                                      EdgeInsets.fromLTRB(25.w, 20.h, 0, 20.h),
                                  decoration: ShapeDecoration(
                                      color: hexColor('#A9B0A6'),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                      )),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        R.ASSETS_IMAGES_STATEMENT_PNG,
                                        height: 18.h,
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        'Statement',
                                        style: context.medium.copyWith(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Container(
                                  padding:
                                      EdgeInsets.fromLTRB(25.w, 20.h, 0, 20.h),
                                  decoration: ShapeDecoration(
                                      color: hexColor('#F4A988'),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                      )),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        R.ASSETS_IMAGES_INVITE_PNG,
                                        height: 18.h,
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        'Invite Friends',
                                        style: context.medium.copyWith(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Transaction history',
                                style: context.medium.copyWith(
                                    color: Colors.white, fontSize: 16.w),
                              ),
                              Text(
                                'View all',
                                style: context.medium.copyWith(
                                    color: hexColor('#B0B7B1'), fontSize: 14.w),
                              ),
                            ],
                          ),
                          SizedBox(height: 7.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20.h, horizontal: 15.w),
                            decoration: ShapeDecoration(
                                color: hexColor('#334e48'),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                )),
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 3,
                              separatorBuilder: (ctx, i) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Divider(
                                    color: hexColor('#FCFCFC')
                                        .withValues(alpha: 0.3)),
                              ),
                              itemBuilder: (ctx, i) {
                                return Row(
                                  children: [
                                    Image.asset(
                                      R.ASSETS_IMAGES_PENDING_TRANS_PNG,
                                      height: 40.h,
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Transfer to UGf_...Gbfh...',
                                            style: context.medium.copyWith(
                                                color: Colors.white,
                                                fontSize: 16.w),
                                          ),
                                          SizedBox(height: 3.h),
                                          Row(
                                            children: [
                                              Text(
                                                'Feb 28',
                                                style: context.medium.copyWith(
                                                    color: hexColor('#B0B7B1'),
                                                    fontSize: 12.w),
                                              ),
                                              SizedBox(width: 15.w),
                                              Text(
                                                '12:09AM',
                                                style: context.medium.copyWith(
                                                    color: hexColor('#B0B7B1'),
                                                    fontSize: 12.w),
                                              ),
                                              SizedBox(width: 15.w),
                                              Text(
                                                'Wallet',
                                                style: context.medium.copyWith(
                                                    color: hexColor('#B0B7B1'),
                                                    fontSize: 12.w),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '91,000.89',
                                          style: context.medium.copyWith(
                                              color: Colors.white,
                                              fontSize: 16.w),
                                        ),
                                        SizedBox(height: 3.h),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.h, horizontal: 6.w),
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                                side: BorderSide(
                                                    color:
                                                        hexColor('#D4A4411A'))),
                                          ),
                                          child: Text(
                                            'Pending',
                                            style: context.medium.copyWith(
                                                color: hexColor('#D4A441'),
                                                fontSize: 11.sp),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Deposit',
                                style: context.medium.copyWith(
                                    color: Colors.white, fontSize: 16.w),
                              ),
                              Text(
                                'View all',
                                style: context.medium.copyWith(
                                    color: hexColor('#B0B7B1'), fontSize: 14.w),
                              ),
                            ],
                          ),
                          SizedBox(height: 7.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20.h, horizontal: 15.w),
                            decoration: ShapeDecoration(
                                color: hexColor('#334e48'),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                )),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      R.ASSETS_IMAGES_STABLE_COINS_PNG,
                                      height: 40.h,
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Using other stable coins',
                                            style: context.medium.copyWith(
                                                color: Colors.white,
                                                fontSize: 14.w),
                                          ),
                                          SizedBox(height: 3.h),
                                          Text(
                                            'Swap USDT or USDC for eUSD',
                                            style: context.medium.copyWith(
                                                color: hexColor('#B0B7B1'),
                                                fontSize: 12.w),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: Divider(
                                      color: hexColor('#FCFCFC')
                                          .withValues(alpha: 0.3)),
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      R.ASSETS_IMAGES_MOB_COINS_PNG,
                                      height: 40.h,
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Using MOB',
                                            style: context.medium.copyWith(
                                                color: Colors.white,
                                                fontSize: 14.w),
                                          ),
                                          SizedBox(height: 3.h),
                                          Text(
                                            'Swap MOB for eUSD',
                                            style: context.medium.copyWith(
                                                color: hexColor('#B0B7B1'),
                                                fontSize: 12.w),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Withdraw funds',
                                style: context.medium.copyWith(
                                    color: Colors.white, fontSize: 16.w),
                              ),
                              Text(
                                'View all',
                                style: context.medium.copyWith(
                                    color: hexColor('#B0B7B1'), fontSize: 14.w),
                              ),
                            ],
                          ),
                          SizedBox(height: 7.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20.h, horizontal: 15.w),
                            decoration: ShapeDecoration(
                                color: hexColor('#334e48'),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                )),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      R.ASSETS_IMAGES_STABLE_COINS_PNG,
                                      height: 40.h,
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Using bank transfer',
                                            style: context.medium.copyWith(
                                                color: Colors.white,
                                                fontSize: 14.w),
                                          ),
                                          SizedBox(height: 3.h),
                                          Text(
                                            'Swap USDT or USDC for eUSD',
                                            style: context.medium.copyWith(
                                                color: hexColor('#B0B7B1'),
                                                fontSize: 12.w),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: Divider(
                                      color: hexColor('#FCFCFC')
                                          .withValues(alpha: 0.3)),
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      R.ASSETS_IMAGES_MOB_COINS_PNG,
                                      height: 40.h,
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Using MOB',
                                            style: context.medium.copyWith(
                                                color: Colors.white,
                                                fontSize: 14.w),
                                          ),
                                          SizedBox(height: 3.h),
                                          Text(
                                            'Swap MOB for eUSD',
                                            style: context.medium.copyWith(
                                                color: hexColor('#B0B7B1'),
                                                fontSize: 12.w),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
