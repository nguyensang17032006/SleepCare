import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';

class CountryPicker extends StatefulWidget {
  const CountryPicker({super.key});

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  // Biến lưu mã vùng và cờ (Mặc định là Việt Nam)
  String _countryCode = '+84';
  String _countryFlag = '🇻🇳';

  @override
  Widget build(BuildContext context) {
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. NÚT NHẤN ĐỂ CHỌN MÃ QUỐC GIA
        InkWell(
          onTap: () {
            showCountryPicker(
              context: context,
              showPhoneCode: true,
              countryListTheme: CountryListThemeData(
                backgroundColor: Colors.grey[900],
                textStyle: const TextStyle(color: Colors.white),
                bottomSheetHeight: 500,
              ),
              onSelect: (Country country) {
                setState(() {
                  _countryCode = '+${country.phoneCode}';
                  _countryFlag = country.flagEmoji;
                });
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, 
              children: [
                Text(_countryFlag, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  _countryCode,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppTheme.textMuted,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 10),

        // 2. Ô NHẬP SỐ ĐIỆN THOẠI
        const Expanded(
          child: TextField(
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'XXX-XXX-XXXX',
              hintStyle: TextStyle(color: AppTheme.textMuted),
              
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: Colors.grey),
              ),
              
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 19),
            ),
          ),
        ),
      ],
    );
  }
}