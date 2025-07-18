// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:taccontractor/data/data/constants/app_colors.dart';
// import 'package:taccontractor/data/data/constants/app_typography.dart';
// import 'package:taccontractor/widhets/common%20widgets/buttons/custom_button_with_icon.dart';
// import 'package:taccontractor/widhets/common%20widgets/buttons/custom_icon_button.dart';

// class GuardDetailScreen extends StatelessWidget {
//   const GuardDetailScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final width = Get.width;
//     final height = Get.height;

//     return Scaffold(
//       backgroundColor: AppColors.kDarkBlue,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             SingleChildScrollView(
//               padding: EdgeInsets.only(bottom: height * 0.15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // App Bar
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.015),
//                     child: Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () => Get.back(),
//                           child: Icon(Icons.arrow_back, color: Colors.white, size: width * 0.06),
//                         ),
//                         SizedBox(width: width * 0.02),
//                         Text("Guard Profile", style: AppTypography.kBold18.copyWith(color: Colors.white)),
//                       ],
//                     ),
//                   ),

//                   // Banner + Profile
//                   Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       Container(
//                         width: double.infinity,
//                         height: height * 0.13,
//                         decoration: BoxDecoration(
//                           color: AppColors.kSkyBlue,
//                           borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(width * 0.04),
//                             bottomRight: Radius.circular(width * 0.04),
//                           ),
//                         ),
//                         child: Align(
//                           alignment: Alignment.centerRight,
//                           child: Padding(
//                             padding: EdgeInsets.only(right: width * 0.04),
//                             child: Image.asset(
//                               'assets/logoforhomescreen.png',
//                               width: width * 0.3,
//                               fit: BoxFit.contain,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: -width * 0.12,
//                         left: width * 0.04,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(width * 0.02),
//                           child: Image.asset(
//                             'assets/userpicture.jpg',
//                             width: width * 0.24,
//                             height: width * 0.24,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   // Info Section
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: width * 0.04).copyWith(top: width * 0.14),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: width * 0.01),
//                               decoration: BoxDecoration(
//                                 color: AppColors.kGuardsCard,
//                                 borderRadius: BorderRadius.circular(width * 0.02),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Image.asset("assets/icon/Layer 2.png", width: width * 0.035),
//                                   SizedBox(width: width * 0.01),
//                                   Text('Leader Guard', style: AppTypography.kBold10.copyWith(color: Colors.white)),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(width: width * 0.015),
//                             CircleAvatar(
//                               radius: width * 0.03,
//                               backgroundColor: AppColors.kGuardsCard,
//                               child: Icon(Icons.verified, size: width * 0.04, color: Colors.white),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: height * 0.015),
//                         Text("Johsan Bill", style: AppTypography.kBold20.copyWith(color: Colors.white)),
//                         SizedBox(height: height * 0.004),
//                         Text("Senior Security Professional", style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
//                         SizedBox(height: height * 0.01),
//                         Row(
//                           children: [
//                             Icon(Icons.location_on, color: AppColors.kgrey, size: width * 0.04),
//                             SizedBox(width: 4),
//                             Text("New York, NY", style: AppTypography.kLight12.copyWith(color: AppColors.kgrey)),
//                             const Spacer(),
//                             OutlinedButton(
//                               onPressed: (){
                                      
//                               },
//                               style: OutlinedButton.styleFrom(
//                                 backgroundColor: AppColors.kSkyBlue,
//                                       // side: const BorderSide(color: AppColors.kSkyBlue), // Sky Blue border
//                                       // foregroundColor: Colors.white, // Text and icon color
//                                       // padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                               ),
//                               child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
                                         
//                                       children: 
//                              [
//                               Icon(Icons.message, color: AppColors.kBlack,size:Get.width * 0.08),
//                              SizedBox(width: 4,),
//                                Text(
//                                   'Message',
//                                   style: AppTypography.kBold17
//                                       .copyWith(color: AppColors.kBlack),
//                                 ),
                               
                                   
//                               ]
                                         
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: height * 0.02),
//                         Container(
//                           width: double.infinity,
//                           padding: EdgeInsets.all(width * 0.035),
//                           decoration: BoxDecoration(
//                             color: AppColors.kinput.withOpacity(0.5),
//                             borderRadius: BorderRadius.circular(width * 0.015),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Professional Information", style: AppTypography.kBold14.copyWith(color: Colors.white)),
//                               SizedBox(height: height * 0.015),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   _infoColumn("Year of Experience", "5"),
//                                   _infoColumn("Level", "2"),
//                                 ],
//                               ),
//                               SizedBox(height: height * 0.015),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   _infoColumn("Security Licence Number", "123456789 (Class 1A)"),
//                                   _infoColumn("ABN", "12 345 678 910"),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Bottom Buttons
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 color: AppColors.kDarkBlue,
//                 padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.02),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: CustomButtonWithIcon(
//                         title: "Save",
//                         icon: Icons.bookmark_border,
//                         onTap: () {},
//                       ),
//                     ),
//                     SizedBox(width: width * 0.04),
//                     Expanded(
//                       child: CustomButtonWithIcon(
//                         title: "Hire Me",
//                         icon: Icons.send,
//                         onTap: () {},
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _infoColumn(String label, String value) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: AppTypography.kLight12.copyWith(color: AppColors.kgrey)),
//           SizedBox(height: 4),
//           Text(value, style: AppTypography.kBold12.copyWith(color: Colors.white)),
//         ],
//       ),
//     );
//   }
// } 


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/Guard_details/hire_confirmation.dart';
import 'package:taccontractor/widhets/common%20widgets/buttons/custom_button_with_icon.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GuardDetailScreen extends StatelessWidget {
  const GuardDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController();
     final List<String> _licenseImages = [
    'assets/icon/License Image.png',
    'assets/icon/License Image.png',
    'assets/icon/License Image.png',
    'assets/icon/License Image.png',
  ];
    final width = Get.width;
    final height = Get.height;

    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: height * 0.15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.015),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Icon(Icons.arrow_back, color: Colors.white, size: width * 0.06),
                        ),
                        SizedBox(width: width * 0.02),
                        Text("Guard Profile", style: AppTypography.kBold18.copyWith(color: Colors.white)),
                      ],
                    ),
                  ),

                  // Banner + Profile
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        height: height * 0.13,
                        decoration: BoxDecoration(
                          color: AppColors.kSkyBlue,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(width * 0.04),
                            bottomRight: Radius.circular(width * 0.04),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: width * 0.04),
                            child: Image.asset(
                              'assets/logoforhomescreen.png',
                              width: width * 0.3,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -width * 0.12,
                        left: width * 0.04,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(width * 0.02),
                          child: Image.asset(
                            'assets/userpicture.jpg',
                            width: width * 0.24,
                            height: width * 0.24,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Info Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04).copyWith(top: width * 0.14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: width * 0.01),
                              decoration: BoxDecoration(
                                color: AppColors.kGuardsCard,
                                borderRadius: BorderRadius.circular(width * 0.02),
                              ),
                              child: Row(
                                children: [
                                  Image.asset("assets/icon/Layer 2.png", width: width * 0.035),
                                  SizedBox(width: width * 0.01),
                                  Text('Leader Guard', style: AppTypography.kBold10.copyWith(color: Colors.white)),
                                ],
                              ),
                            ),
                            SizedBox(width: width * 0.015),
                            CircleAvatar(
                              radius: width * 0.03,
                              backgroundColor: AppColors.kGuardsCard,
                              child: Icon(Icons.verified, size: width * 0.04, color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.015),
                        Row(
                          children: [

                            Text("Johsan Bill", style: AppTypography.kBold20.copyWith(color: Colors.white)),
                              Spacer(),
                              OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.kSkyBlue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Row(
                                children: [
                                   Image.asset(
                                  'assets/icon/message.png',
                                  // width: width * 0.6,
                                  fit: BoxFit.cover,
                                ),
                                 
                                 SizedBox(width: 4),
                                  Text('Message', style: AppTypography.kBold17.copyWith(color: AppColors.kBlack)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.004),
                        Text("Senior Security Professional", style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
                        SizedBox(height: height * 0.01),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: AppColors.kgrey, size: width * 0.04),
                            SizedBox(width: 4),
                            Text("New York, NY", style: AppTypography.kLight12.copyWith(color: AppColors.kgrey)),
                            
                            
                          ],
                        ),
                          SizedBox(height: height * 0.02),

                        // Tags Section
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _tagChip("Asset Protection"),
                            _tagChip("Healthcare"),
                            _tagChip("Driving License"),
                            _tagChip("Arm License"),
                            _tagChip("Visa for Work"),
                          ],
                        ),
                        SizedBox(height: height * 0.02),

                        // Professional Info
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(width * 0.035),
                          decoration: BoxDecoration(
                            color: AppColors.kinput.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(width * 0.015),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Professional Information", style: AppTypography.kBold14.copyWith(color: Colors.white)),
                              SizedBox(height: height * 0.015),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _infoColumn("Year of Experience", "5"),
                                  _infoColumn("Level", "2"),
                                ],
                              ),
                              SizedBox(height: height * 0.015),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _infoColumn("Security Licence Number", "123456789 (Class 1A)"),
                                  _infoColumn("ABN", "12 345 678 910"),
                                ],
                              )
                            ],
                          ),
                        ),

                  
                        SizedBox(height: height * 0.02),

                        // // License Horizontal Scroll
                        // SizedBox(
                        //   height: height * 0.12,
                        //   child: ListView.separated(
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount: 2,
                        //     separatorBuilder: (_, __) => SizedBox(width: 10),
                        //     itemBuilder: (context, index) {
                        //       return ClipRRect(
                        //         borderRadius: BorderRadius.circular(8),
                        //         child: Image.asset(
                        //           'assets/icon/License Image.png',
                        //           width: width * 0.6,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),

                        /// 🔵 Carousel with Dot Indicator
                 SizedBox(
  height: height * 0.36,
  child: Column(
    children: [
      Expanded(
        child: PageView.builder(
          controller: _pageController,
          itemCount: _licenseImages.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white, // optional background
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    _licenseImages[index],
                    fit: BoxFit.contain, // 👈 full image shown
                    width: width * 0.9,
                    height: double.infinity,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 10),
      SmoothPageIndicator(
        controller: _pageController,
        count: _licenseImages.length,
        effect: ExpandingDotsEffect(
          dotColor: AppColors.kgrey,
          activeDotColor: AppColors.kSkyBlue,
          dotHeight: 8,
          dotWidth: 8,
          expansionFactor: 2.5,
        ),
      ),
    ],
  ),
),


                        SizedBox(height: height * 0.03),

                        // Experience
                            SizedBox(height: 10),
                       _experienceSection(),

                        // See more
                            SizedBox(height: 20),

                    
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.kinput.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                           children : [
                               Text("Reviews", style: AppTypography.kBold14.copyWith(color: Colors.white)),
                          SizedBox(height: 2,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.star, color: AppColors.kSkyBlue, size: 28),
                                  SizedBox(width: 10),
                                  Text("5.0", style: AppTypography.kBold18.copyWith(color: Colors.white)),
                                           ],

                              ),
                             
                                  Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                            
                                    children: [
                                      Text("Overall rating", style: AppTypography.kLight14.copyWith(color: Colors.white)),
                                    ],
                                  ),
                       
                            ],
                          ),
                        ),

                        SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Buttons
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: AppColors.kDarkBlue,
                padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.02),
                child: Row(
                  children: [
                  
                     Expanded(
                       child: OutlinedButton(
                                   onPressed: () {},
                                   style: OutlinedButton.styleFrom(
                                     side: const BorderSide(color: AppColors.kSkyBlue),
                                     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                   ),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                        const SizedBox(width: 8),
                                       Text(
                                         'Save',
                                         style: AppTypography.kBold17.copyWith(color: AppColors.kSkyBlue),
                                       ),
                                        SizedBox(width: Get.width * 0.02),
                     
                                        Image.asset(
                                    'assets/icon/save.png',
                                    // width: width * 0.6,
                                    fit: BoxFit.cover,
                                    color: AppColors.kSkyBlue
                                  ), 
                                     ],
                                   ),
                                 ),
                     ),
                        SizedBox(width: Get.width * 0.02),
                     
                     Expanded(
                       child: ElevatedButton(
                         onPressed: () {
                              showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const HireGuardConfirmationBottomSheet(),
                        );     
                               }
                             ,
                         style: ElevatedButton.styleFrom(
                           backgroundColor: AppColors.kSkyBlue,
                           padding: const EdgeInsets.symmetric(vertical: 14),
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                           disabledBackgroundColor: AppColors.kSkyBlue.withOpacity(0.3),
                         ),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text(
                               'Hire Me',
                               style: AppTypography.kBold18.copyWith(color: AppColors.kBlack),
                             ),
                             SizedBox(width: Get.width * 0.02),
                             Image.asset(
                                             'assets/icon/hire.png',
                                            //  width: width * 0.6,
                                             fit: BoxFit.cover,
                                               color: AppColors.kBlack
                                           ),        ],
                         ),
                       ),
                     ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.kLight12.copyWith(color: AppColors.kgrey)),
          SizedBox(height: 4),
          Text(value, style: AppTypography.kBold12.copyWith(color: Colors.white)),
        ],
      ),
    );
  }

 Widget _tagChip(String title) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.kinput.withOpacity(0.3),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: AppTypography.kBold12.copyWith(color:AppColors.kgrey),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(width: 2),
        Icon(Icons.check, size: 16, color: AppColors.kgrey),
      ],
    ),
  );
}

Widget _experienceSection() {
  final List<Map<String, dynamic>> experience = [
    {
      "rating": 5.0,
      "text": "John was professional and handled the security escort perfectly.",
      "date": "10 Mar 25 - 25 Mar 25",
      "title": "Security Escort for Actor – Airport to Residence"
    },
    {
      "rating": 4.7,
      "text": "John was professional and handled the security escort perfectly.",
      "date": "10 Mar 25 - 25 Mar 25",
      "title": "Security Escort for Actor – Airport to Residence"
    },
    {
      "rating": 3.0,
      "text": "John was professional and handled the security escort perfectly.",
      "date": "10 Mar 25 - 25 Mar 25",
      "title": "Security Escort for Actor – Airport to Residence"
    },
  ];

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.kinput.withOpacity(0.5),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Experience", style: AppTypography.kBold14.copyWith(color: Colors.white)),
        const SizedBox(height: 12),
        ...experience.map((e) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e["title"], style: AppTypography.kBold12.copyWith(color: Colors.white)),
                const SizedBox(height: 4),
                Text(e["date"], style: AppTypography.kLight12.copyWith(color: AppColors.kgrey)),
                const SizedBox(height: 6),
                Text(e["text"], style: AppTypography.kLight12.copyWith(color: Colors.white)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.star, color: AppColors.kSkyBlue, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      e["rating"].toString(),
                      style: AppTypography.kBold12.copyWith(color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          );
        }).toList(),
        GestureDetector(
          onTap: () {
            // Add your "See more" logic here
          },
          child: Text(
            "See more",
            style: AppTypography.kBold12.copyWith(color: AppColors.kSkyBlue),
          ),
        ),
      ],
    ),
  );
}

}
