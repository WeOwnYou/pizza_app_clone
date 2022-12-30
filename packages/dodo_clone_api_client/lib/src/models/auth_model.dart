// /*
// {
//     "status": "ok",
//     "info": "Код выслан в СМС на указанный номер",
//     "expire": 60
// }
//  */
//
// class AuthModel {
//   final String status;
//   final String info;
//   final int expire;
//
//   const AuthModel({
//     required this.status,
//     required this.info,
//     required this.expire,
//   });
//
//   factory AuthModel.fromJson(Map<String, dynamic> json) {
//     return AuthModel(
//       status: json['status'],
//       info: json['info'],
//       expire: json['expire'],
//     );
//   }
// }
//
// /*
// {
//     "code": "e53334630058d46e0052232e00000e6b00000318ed9afaef2d0dd41dc072d0f99eda54",
//     "state": "",
//     "domain": "oauth.bitrix.info",
//     "member_id": "9c69be6f883daf9af8e859f43eb0f4f8",
//     "scope": "mailservice,lists,forum,landing,cashbox,faceid,department,contact_center,crm,task,user,sonet_group,documentgenerator,timeman,disk,calendar,delivery,pay_system,tasks_extended,bizproc,vedita:buyer,userconsent,smile,imopenlines,placement,user_brief,user_basic,user.userfield,log,entity,pull,pull_channel,mobile,messageservice,im,imbot,catalog,iblock,intranet,userfieldconfig,rpa,sale,salescenter,socialnetwork,tasks",
//     "redirect_uri": "http://keuneshop.6hi.ru"
// }
//  */
// class VerificationModel {
//   final String code;
//   final String state;
//   final String domain;
//   final String memberId;
//   final String scope;
//   final String redirectUri;
//
//   const VerificationModel({
//     required this.code,
//     required this.state,
//     required this.domain,
//     required this.memberId,
//     required this.scope,
//     required this.redirectUri,
//   });
//
//   factory VerificationModel.fromJson(Map<String, dynamic> json) {
//     return VerificationModel(
//       code: json['code'],
//       state: json['state'],
//       domain: json['domain'],
//       memberId: json['member_id'],
//       scope: json['scope'],
//       redirectUri: json['redirect_uri'],
//     );
//   }
// }
