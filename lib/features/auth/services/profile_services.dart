// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:whisp/core/network/api_client.dart';
// import 'package:whisp/core/network/api_endpoints.dart';
// import 'package:whisp/core/network/api_exception.dart';

// class ProfileService {
//   final ApiClient _apiClient = ApiClient();

//   Future<dynamic> updateProfile({
//     File? avatar,
//     required String gender,
//     required String dateOfBirth,
//     required String country,
//   }) async {
//     try {
//       FormData formData = FormData.fromMap({
//         "gender": gender,
//         "dateOfBirth": dateOfBirth,
//         "country": country,
//         if (avatar != null)
//           "avatar": await MultipartFile.fromFile(
//             avatar.path,
//             filename: avatar.path.split('/').last,
//           ),
//       });

//       final response = await _apiClient.put(
//         ApiEndpoints.updateProfile,
//         data: formData,
//         isFormData: true,
//       );

//       return response;
//     } catch (e) {
//       throw ApiException.handleError(e);
//     }
//   }
// }

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:whisp/core/network/api_client.dart';
import 'package:whisp/core/network/api_endpoints.dart';

class ProfileService {
  final ApiClient _apiClient = ApiClient();

  Future<dynamic> updateProfile({
    File? avatar,
    String? gender,
    String? dateOfBirth,
    String? country,
  }) async {
    try {
      final formData = FormData();

      if (avatar != null) {
        formData.files.add(
          MapEntry(
            'avatar',
            await MultipartFile.fromFile(
              avatar.path,
              filename: avatar.path.split('/').last,
            ),
          ),
        );
      }
      if (gender?.isNotEmpty == true) {
        formData.fields.add(MapEntry('gender', gender!));
      }
      if (dateOfBirth?.isNotEmpty == true) {
        formData.fields.add(MapEntry('dateOfBirth', dateOfBirth!));
      }
      if (country?.isNotEmpty == true) {
        formData.fields.add(MapEntry('country', country!));
      }

      final response = await _apiClient.put(
        ApiEndpoints.updateProfile,
        data: formData,
        isFormData: true,
      );

      return response.data;
    } catch (e) {
      throw Exception("Update failed: $e");
    }
  }
}
