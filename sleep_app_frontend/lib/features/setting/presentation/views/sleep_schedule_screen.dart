import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/app/widget/primary_button.dart';
import '../viewmodels/schedule_vm.dart';

class SleepScheduleScreen extends StatelessWidget {
  const SleepScheduleScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ScheduleViewModel()
            ..loadSchedule(),
      child: const _SleepScheduleView(),
    );
  }
}

class _SleepScheduleView
    extends StatefulWidget {
  const _SleepScheduleView();

  @override
  State<_SleepScheduleView> createState() =>
      _SleepScheduleViewState();
}

class _SleepScheduleViewState
    extends State<_SleepScheduleView> {
  Future<void> _selectBedtime(
    BuildContext context,
    ScheduleViewModel vm,
  ) async {
    final picked =
        await showTimePicker(
      context: context,
      initialTime: vm.bedtime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme:
                const ColorScheme.dark(
              primary:
                  AppTheme.primaryColor,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      vm.setBedtime(picked);
    }
  }

  Future<void> _saveSchedule(
    BuildContext context,
    ScheduleViewModel vm,
  ) async {
    final success =
        await vm.saveSchedule();

    if (!context.mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Đã lưu lịch hẹn ngủ thành công!',
          ),
        ),
      );

      Navigator.pop(context);

      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          vm.errorMessage ??
              'Có lỗi xảy ra khi lưu!',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm =
        context.watch<
            ScheduleViewModel>();

    if (vm.isLoading) {
      return const Scaffold(
        backgroundColor:
            AppTheme.bgColor,
        body: Center(
          child:
              CircularProgressIndicator(
            color:
                AppTheme.primaryColor,
          ),
        ),
      );
    }

    final days = [
      'T2',
      'T3',
      'T4',
      'T5',
      'T6',
      'T7',
      'CN',
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color:
                AppTheme.textMuted,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'LỊCH HẸN NGỦ',
          style: TextStyle(
            color:
                AppTheme.textMuted,
            fontSize: 12,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor:
            AppTheme.bgColor,
        elevation: 0,
      ),
      body: Container(
        decoration:
            const BoxDecoration(
          gradient:
              AppTheme.bgGradient,
        ),
        child: SafeArea(
          child:
              SingleChildScrollView(
            padding:
                const EdgeInsets.all(
              24,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                // ============================================
                // GIỜ ĐI NGỦ
                // ============================================

                const Text(
                  'Giờ đi ngủ mục tiêu',
                  style: TextStyle(
                    color:
                        AppTheme.textLight,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                GestureDetector(
                  onTap: () {
                    _selectBedtime(
                      context,
                      vm,
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration:
                        BoxDecoration(
                      color: AppTheme
                          .cardLightColor,
                      borderRadius:
                          BorderRadius
                              .circular(
                        16,
                      ),
                      border:
                          Border.all(
                        color: Colors
                            .white
                            .withValues(
                          alpha: 0.05,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        Text(
                          vm.bedtime
                              .format(
                            context,
                          ),
                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                            fontSize: 32,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                        const Icon(
                          Icons.edit,
                          color: AppTheme
                              .textMuted,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                // ============================================
                // NGÀY ÁP DỤNG
                // ============================================

                const Text(
                  'Áp dụng vào',
                  style: TextStyle(
                    color:
                        AppTheme.textLight,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                  children:
                      List.generate(
                    7,
                    (index) {
                      final day =
                          index + 1;

                      final isSelected =
                          vm.activeDays
                              .contains(
                        day,
                      );

                      return GestureDetector(
                        onTap: () {
                          vm.toggleDay(
                            day,
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment:
                              Alignment
                                  .center,
                          decoration:
                              BoxDecoration(
                            color: isSelected
                                ? AppTheme
                                    .primaryColor
                                : AppTheme
                                    .cardLightColor,
                            shape:
                                BoxShape
                                    .circle,
                          ),
                          child: Text(
                            days[index],
                            style:
                                TextStyle(
                              color: isSelected
                                  ? Colors
                                      .white
                                  : AppTheme
                                      .textMuted,
                              fontSize:
                                  12,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                // ============================================
                // NHẮC NHỞ
                // ============================================

                const Text(
                  'Nhắc nhở trước khi ngủ',
                  style: TextStyle(
                    color:
                        AppTheme.textLight,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration:
                      BoxDecoration(
                    color: AppTheme
                        .cardLightColor,
                    borderRadius:
                        BorderRadius
                            .circular(
                      16,
                    ),
                  ),
                  child:
                      DropdownButtonHideUnderline(
                    child:
                        DropdownButton<
                            int>(
                      value: vm
                          .reminderOffsetMinutes,
                      isExpanded: true,
                      dropdownColor:
                          AppTheme
                              .cardColor,
                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                        fontSize: 16,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 0,
                          child: Text(
                            'Đúng giờ',
                          ),
                        ),
                        DropdownMenuItem(
                          value: 15,
                          child: Text(
                            'Trước 15 phút',
                          ),
                        ),
                        DropdownMenuItem(
                          value: 30,
                          child: Text(
                            'Trước 30 phút',
                          ),
                        ),
                        DropdownMenuItem(
                          value: 60,
                          child: Text(
                            'Trước 1 giờ',
                          ),
                        ),
                      ],
                      onChanged:
                          (value) {
                        if (value ==
                            null) {
                          return;
                        }

                        vm.setReminderOffset(
                          value,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                // ============================================
                // THÔNG BÁO
                // ============================================

                SwitchListTile(
                  contentPadding:
                      EdgeInsets.zero,
                  title: const Text(
                    'Bật thông báo nhắc nhở',
                    style: TextStyle(
                      color: AppTheme
                          .textLight,
                      fontSize: 16,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),
                  subtitle:
                      const Text(
                    'Nhận thông báo trước giờ đi ngủ đã đặt.',
                    style: TextStyle(
                      color: AppTheme
                          .textMuted,
                      fontSize: 13,
                    ),
                  ),
                  value: vm
                      .notificationsEnabled,
                  // ignore: deprecated_member_use
                  activeColor:
                      AppTheme
                          .primaryColor,
                  onChanged: (
                    value,
                  ) {
                    vm.setNotificationsEnabled(
                      value,
                    );
                  },
                ),

                const SizedBox(
                  height: 40,
                ),

                // ============================================
                // ERROR
                // ============================================

                if (vm.errorMessage !=
                    null) ...[
                  Container(
                    width:
                        double.infinity,
                    padding:
                        const EdgeInsets
                            .all(
                      12,
                    ),
                    decoration:
                        BoxDecoration(
                      color: Colors
                          .redAccent
                          .withValues(
                        alpha: 0.1,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),
                    ),
                    child: Text(
                      vm.errorMessage!,
                      style:
                          const TextStyle(
                        color: Colors
                            .redAccent,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],

                // ============================================
                // WARNING
                // ============================================

                if (vm.warningMessage !=
                    null) ...[
                  Container(
                    width:
                        double.infinity,
                    padding:
                        const EdgeInsets
                            .all(
                      12,
                    ),
                    decoration:
                        BoxDecoration(
                      color: Colors
                          .orangeAccent
                          .withValues(
                        alpha: 0.1,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),
                    ),
                    child: Text(
                      vm.warningMessage!,
                      style:
                          const TextStyle(
                        color: Colors
                            .orangeAccent,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],

                // ============================================
                // SAVE BUTTON
                // ============================================

                vm.isSaving
                    ? const Center(
                        child:
                            CircularProgressIndicator(
                          color: AppTheme
                              .primaryColor,
                        ),
                      )
                    : PrimaryButton(
                        text:
                            'Lưu lịch hẹn',
                        onPressed: () {
                          _saveSchedule(
                            context,
                            vm,
                          );
                        },
                      ),

                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}