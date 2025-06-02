import 'package:flutter/material.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';

class ReportIssueScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        title: Text(
          'Report an Issue',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: AppColors.kinput, height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Details",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                  SizedBox(height: 16),
                  buildTextField(Icons.warning_amber_rounded, "Subject"),
                  SizedBox(height: 16),
                  buildTextField(Icons.calendar_month_rounded, "Issue Date"),
                  SizedBox(height: 16),
                  buildTextArea(Icons.edit_note_rounded,
                      "Please describe your issue in detail. Include any error messages or specific steps to reproduce the problem."),
                  SizedBox(height: 24),
                  Text("Supporting Documents",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.kinput),
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.kDarkestBlue,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Attach Doc  ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Optional",
                                    style: TextStyle(
                                      color: AppColors.kalert,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Text(
                              "Browse",
                              style: TextStyle(
                                color: AppColors.kSkyBlue,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Min 10MB, Upload only PDF, DOC, DOCX, JPG, PNG",
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.kinput,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: AppColors.kinput, height: 1),
          Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 24),
            color: AppColors.kDarkestBlue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: true,
                      onChanged: (value) {},
                      activeColor: AppColors.kSkyBlue,
                    ),
                    Expanded(
                      child: Text(
                        "I confirm that all information provided is accurate and true to the best of my knowledge",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 4, // 40%
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.kSkyBlue),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.kDarkestBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          "Save as Draft",
                          style: TextStyle(
                              color: AppColors.kSkyBlue,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      flex: 6, // 60%
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.send, color: Colors.white, size: 18),
                        label: Text("Submit Issue",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kSkyBlue,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(IconData icon, String hint) {
    return TextField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.kinput),
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.kinput),
        filled: false,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kinput),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kSkyBlue),
        ),
      ),
    );
  }

  Widget buildTextArea(IconData icon, String hint) {
    return TextField(
      maxLines: 4,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(top: 12),
          child: Icon(icon, color: AppColors.kinput),
        ),
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.kinput),
        filled: false,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kinput),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kSkyBlue),
        ),
      ),
    );
  }
}
