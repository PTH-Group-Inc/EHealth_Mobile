import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// State ở đây chỉ đơn giản là một số nguyên (int) đại diện cho tab đang chọn
@singleton
class NavigationCubit extends Cubit<int> {
  // Khởi tạo mặc định là 0 (Trang chủ)
  NavigationCubit() : super(0);

  // Hàm này để đổi tab
  void changeTab(int index) {
    emit(index); // Bắn ra số index mới, UI nghe thấy sẽ tự đổi
  }

  // Hàm reset về trang chủ khi đăng xuất
  void reset() {
    emit(0);
  }
}
