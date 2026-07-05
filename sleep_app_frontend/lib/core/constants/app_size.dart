import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSizes {
  // ==================== 1. PADDING & MARGIN (KHOẢNG CÁCH) ====================
  // Sử dụng .r (radius/adapt) là cách an toàn nhất cho cả khoảng cách ngang và dọc
  static double get p4 => 4.r;
  static double get p8 => 8.r;
  static double get p12 => 12.r;
  static double get p16 =>
      16.r; // Mức mặc định chuẩn cho viền màn hình (Padding toàn cục)
  
  static double get p24 => 24.r;
  static double get p32 => 32.r;
    static double get p64 => 64.r;


  // ==================== 2. RADIUS (BO GÓC) ====================
  static double get r4 => 4.r;
  static double get r8 => 8.r; // Bo góc nhẹ (Nút bấm, ô nhập liệu)
  static double get r12 => 12.r; // Bo góc vừa (Thẻ card bài hát, hộp ngủ)
  static double get r16 => 16.r; // Bo góc lớn (Khung hình lớn, Bottom Sheet)
  static double get r24 => 24.r;
  static double get rCircular =>
      999.r; // Dùng để bo tròn hoàn toàn (Avatar, Nút tròn)

  // ==================== 3. FONT SIZE (CỠ CHỮ) ====================
  // Bắt buộc dùng .sp để chữ tự động co giãn theo cài đặt hệ thống của user
  static double get f10 => 10.sp;
  static double get f12 => 12.sp; // Chữ nhỏ (Chú thích, thời lượng bài hát)
  static double get f14 => 14.sp; // Chữ body tiêu chuẩn
  static double get f16 => 16.sp; // Chữ body lớn / Tiêu đề nhỏ
  static double get f18 => 18.sp; // Tiêu đề vừa (Tên bài hát, tên tính năng)
  static double get f20 => 20.sp;
  static double get f24 => 24.sp; // Tiêu đề lớn (Màn hình chào, Tên app)
  static double get f32 => 32.sp;

  // ==================== 4. SIZEDBOX (KHOẢNG TRỐNG NHANH) ====================
  // Viết sẵn các khoảng trống hay dùng để đỡ phải gõ SizedBox(height: ...) nhiều lần
  // Dùng .h cho chiều dọc, .w cho chiều ngang

  // Khoảng trống chiều dọc
  static double get vGap4 => 4.h;
  static double get vGap8 => 8.h;
  static double get vGap12 => 12.h;
  static double get vGap16 => 16.h;
  static double get vGap24 => 24.h;
  static double get vGap32 => 32.h;

  // Khoảng trống chiều ngang
  static double get hGap4 => 4.w;
  static double get hGap8 => 8.w;
  static double get hGap12 => 12.w;
  static double get hGap16 => 16.w;
  static double get hGap24 => 24.w;
}
