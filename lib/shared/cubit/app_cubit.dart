import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_waste_iot_app/shared/cubit/app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitState());

  static AppCubit get(context) => BlocProvider.of(context);
}
