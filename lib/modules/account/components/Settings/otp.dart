import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/modules/account/components/Settings/reset.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late Timer _timer;
  int _secondsRemaining = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _secondsRemaining = 30;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void verifyOtp(String otp) {
    // Add verification logic here
    print("Entered OTP: $otp");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        title: const Text("Update Password",
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.kinput, size: 16),
          onPressed: () => Get.back(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: AppColors.kgrey, height: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(
              "Enter OTP",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter OTP received at your registered email",
              style: TextStyle(color: AppColors.kinput, fontSize: 13),
            ),
            const SizedBox(height: 24),
            PinCodeTextField(
              appContext: context,
              length: 6,
              obscureText: true,
              obscuringCharacter: '*',
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.underline,
                fieldHeight: 50,
                fieldWidth: 40,
                activeColor: AppColors.kSkyBlue,
                inactiveColor: AppColors.kinput,
                selectedColor: AppColors.kSkyBlue,
              ),
              textStyle: const TextStyle(color: Colors.white, fontSize: 20),
              cursorColor: AppColors.kSkyBlue,
              keyboardType: TextInputType.number,
              onChanged: (_) {},
              onCompleted: verifyOtp,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const ResetPasswordScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kSkyBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text("Verify Account",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: _canResend
                  ? GestureDetector(
                      onTap: () {
                        startTimer();
                      },
                      child: const Text("Resend OTP",
                          style: TextStyle(color: AppColors.kSkyBlue)),
                    )
                  : RichText(
                      text: TextSpan(
                        text: 'Re-try in ',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                        children: [
                          TextSpan(
                            text:
                                '00:${_secondsRemaining.toString().padLeft(2, '0')}',
                            style: const TextStyle(color: AppColors.kSkyBlue),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
