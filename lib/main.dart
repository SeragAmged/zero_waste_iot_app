import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_waste_iot_app/modules/home_screen.dart';
import 'package:zero_waste_iot_app/shared/cubit/app_cubit.dart';
import 'package:zero_waste_iot_app/shared/cubit/app_states.dart';
import 'package:zero_waste_iot_app/shared/helpers/camera/camera_helper.dart';
// import 'package:zero_waste_iot_app/shared/data/dio_helper.dart';

import 'shared/bloc_observer.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  // DioHelper.init();
 await CameraHelper .init();
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => MaterialApp(
          title: 'Zero Waste IoT',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
// camera_cubit.dart
// import 'package:bloc/bloc.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class CameraState {
//   final List<CameraDescription> cameras;
//   final CameraController? controller;
//   final bool isInitialized;
//   final String? error;

//   CameraState({
//     required this.cameras,
//     this.controller,
//     this.isInitialized = false,
//     this.error,
//   });

//   CameraState copyWith({
//     List<CameraDescription>? cameras,
//     CameraController? controller,
//     bool? isInitialized,
//     String? error,
//   }) {
//     return CameraState(
//       cameras: cameras ?? this.cameras,
//       controller: controller ?? this.controller,
//       isInitialized: isInitialized ?? this.isInitialized,
//       error: error ?? this.error,
//     );
//   }
// }

// class CameraCubit extends Cubit<CameraState> {
//   CameraCubit() : super(CameraState(cameras: []));

//   Future<void> initializeCameras() async {
//     try {
//       final cameras = await availableCameras();
//       emit(state.copyWith(cameras: cameras));
//       await initializeCameraController(cameras[1]);
//     } catch (e) {
//       emit(state.copyWith(error: e.toString()));
//     }
//   }

//   Future<void> initializeCameraController(
//       CameraDescription cameraDescription) async {
//     final controller =
//         CameraController(cameraDescription, ResolutionPreset.high);
//     try {
//       await controller.initialize();
//       emit(state.copyWith(controller: controller, isInitialized: true));
//     } catch (e) {
//       emit(state.copyWith(error: e.toString()));
//     }
//   }

//   @override
//   Future<void> close() {
//     state.controller?.dispose();
//     return super.close();
//   }
// }
// // main.dart

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: BlocProvider(
//         create: (_) => CameraCubit()..initializeCameras(),
//         child: const CameraPage(),
//       ),
//     );
//   }
// }

// class CameraPage extends StatelessWidget {
//   const CameraPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Camera Page')),
//       body: BlocBuilder<CameraCubit, CameraState>(
//         builder: (context, state) {
//           if (state.error != null) {
//             return Center(child: Text('Error: ${state.error}'));
//           }

//           if (!state.isInitialized) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           return CameraPreview(state.controller!);
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.camera),
//         onPressed: () async {
//           final cubit = context.read<CameraCubit>();
//           if (cubit.state.isInitialized && cubit.state.controller != null) {
//             try {
//               final image = await cubit.state.controller!.takePicture();
//               // Do something with the picture
//             } catch (e) {
//               print(e);
//             }
//           }
//         },
//       ),
//     );
//   }
// }
