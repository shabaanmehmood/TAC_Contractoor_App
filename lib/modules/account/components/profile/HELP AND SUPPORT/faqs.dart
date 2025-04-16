import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';

class FaqScreen extends StatelessWidget {
  final List<Map<String, String>> faqData = [
    {
      'question': 'How do I reset my password?',
      'answer': 'Go to settings > change password > follow steps.'
    },
    {
      'question': 'How can I cancel my subscription?',
      'answer': 'You can cancel your subscription from account settings.'
    },
    {
      'question': 'What payment methods do you accept?',
      'answer': 'We accept Visa, MasterCard, PayPal and more.'
    },
    {
      'question': 'How can I contact customer support?',
      'answer': 'Contact us via the Help Center or email support.'
    },
    {
      'question': 'What is your refund policy?',
      'answer': 'Refer to our Terms of Service for detailed policy.'
    },
  ];

  FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        title: Text("FAQ", style: TextStyle(color: AppColors.kinput)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
          onPressed: () => Get.back(),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColors.kinput.withOpacity(0.2),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            "Frequently Asked Questions",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          ...faqData.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ExpansionTile(
                  collapsedIconColor: AppColors.kSkyBlue,
                  iconColor: AppColors.kSkyBlue,
                  collapsedBackgroundColor: AppColors.kJobCardColor,
                  backgroundColor: AppColors.kJobCardColor,
                  tilePadding: EdgeInsets.symmetric(horizontal: 12),
                  childrenPadding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                  title: Text(
                    item['question']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    Text(
                      item['answer']!,
                      style: TextStyle(color: AppColors.kinput),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
