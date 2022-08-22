// import 'package:permission_handler/permission_handler.dart';

// export 'package:permission_handler/permission_handler.dart'
//     show PermissionGroup, PermissionStatus;

// /// Facilitates the checking and requesting of permissions from the
// /// application user.
// class Permissions {
//   /// Checks the [PermissionStatus] of the supplied [PermissionGroup].
//   ///
//   /// Returns the new [PermissionStatus].
//   static Future<PermissionStatus> checkPermission(PermissionGroup p) async {
//     PermissionStatus status =
//         await PermissionHandler().checkPermissionStatus(p);
//     return status;
//   }

//   /// Requests permission for the supplied [PermissionGroup].
//   ///
//   /// Returns true if the permission was granted.
//   static Future<bool> _requestPermission(PermissionGroup p) async {
//     // Request the permission.
//     await PermissionHandler().requestPermissions([p]);

//     // Check the new permission status
//     PermissionStatus status = await checkPermission(p);

//     // Return true if the status is granted, otherwise false.
//     return status == PermissionStatus.granted;
//   }

//   /// Checks whether a permission has been granted, and requests permission
//   /// if not.
//   ///
//   /// Returns true if the permission is granted.
//   static Future<bool> ensurePermission(PermissionGroup p) async {
//     if (await checkPermission(p) == PermissionStatus.granted) {
//       // Return true if the permission is already granted
//       return true;
//     } else {
//       // Request the permission if not already granted and return result
//       return await _requestPermission(p);
//     }
//   }
// }
