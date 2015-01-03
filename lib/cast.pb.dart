///
//  Generated code. Do not modify.
///
library extensions.api.cast_channel;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

class CastMessage_ProtocolVersion extends ProtobufEnum {
  static const CastMessage_ProtocolVersion CASTV2_1_0 = const CastMessage_ProtocolVersion._(0, 'CASTV2_1_0');

  static const List<CastMessage_ProtocolVersion> values = const <CastMessage_ProtocolVersion> [
    CASTV2_1_0,
  ];

  static final Map<int, CastMessage_ProtocolVersion> _byValue = ProtobufEnum.initByValue(values);
  static CastMessage_ProtocolVersion valueOf(int value) => _byValue[value];

  const CastMessage_ProtocolVersion._(int v, String n) : super(v, n);
}

class CastMessage_PayloadType extends ProtobufEnum {
  static const CastMessage_PayloadType STRING = const CastMessage_PayloadType._(0, 'STRING');
  static const CastMessage_PayloadType BINARY = const CastMessage_PayloadType._(1, 'BINARY');

  static const List<CastMessage_PayloadType> values = const <CastMessage_PayloadType> [
    STRING,
    BINARY,
  ];

  static final Map<int, CastMessage_PayloadType> _byValue = ProtobufEnum.initByValue(values);
  static CastMessage_PayloadType valueOf(int value) => _byValue[value];

  const CastMessage_PayloadType._(int v, String n) : super(v, n);
}

class CastMessage extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CastMessage')
    ..e(1, 'protocolVersion', GeneratedMessage.QE, () => CastMessage_ProtocolVersion.CASTV2_1_0, (var v) => CastMessage_ProtocolVersion.valueOf(v))
    ..a(2, 'sourceId', GeneratedMessage.QS)
    ..a(3, 'destinationId', GeneratedMessage.QS)
    ..a(4, 'namespace', GeneratedMessage.QS)
    ..e(5, 'payloadType', GeneratedMessage.QE, () => CastMessage_PayloadType.STRING, (var v) => CastMessage_PayloadType.valueOf(v))
    ..a(6, 'payloadUtf8', GeneratedMessage.OS)
    ..a(7, 'payloadBinary', GeneratedMessage.OY)
  ;

  CastMessage() : super();
  CastMessage.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CastMessage.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CastMessage clone() => new CastMessage()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CastMessage create() => new CastMessage();
  static PbList<CastMessage> createRepeated() => new PbList<CastMessage>();

  CastMessage_ProtocolVersion get protocolVersion => getField(1);
  void set protocolVersion(CastMessage_ProtocolVersion v) { setField(1, v); }
  bool hasProtocolVersion() => hasField(1);
  void clearProtocolVersion() => clearField(1);

  String get sourceId => getField(2);
  void set sourceId(String v) { setField(2, v); }
  bool hasSourceId() => hasField(2);
  void clearSourceId() => clearField(2);

  String get destinationId => getField(3);
  void set destinationId(String v) { setField(3, v); }
  bool hasDestinationId() => hasField(3);
  void clearDestinationId() => clearField(3);

  String get namespace => getField(4);
  void set namespace(String v) { setField(4, v); }
  bool hasNamespace() => hasField(4);
  void clearNamespace() => clearField(4);

  CastMessage_PayloadType get payloadType => getField(5);
  void set payloadType(CastMessage_PayloadType v) { setField(5, v); }
  bool hasPayloadType() => hasField(5);
  void clearPayloadType() => clearField(5);

  String get payloadUtf8 => getField(6);
  void set payloadUtf8(String v) { setField(6, v); }
  bool hasPayloadUtf8() => hasField(6);
  void clearPayloadUtf8() => clearField(6);

  List<int> get payloadBinary => getField(7);
  void set payloadBinary(List<int> v) { setField(7, v); }
  bool hasPayloadBinary() => hasField(7);
  void clearPayloadBinary() => clearField(7);
}

class AuthChallenge extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('AuthChallenge')
    ..hasRequiredFields = false
  ;

  AuthChallenge() : super();
  AuthChallenge.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AuthChallenge.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AuthChallenge clone() => new AuthChallenge()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static AuthChallenge create() => new AuthChallenge();
  static PbList<AuthChallenge> createRepeated() => new PbList<AuthChallenge>();
}

class AuthResponse extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('AuthResponse')
    ..a(1, 'signature', GeneratedMessage.QY)
    ..a(2, 'clientAuthCertificate', GeneratedMessage.QY)
  ;

  AuthResponse() : super();
  AuthResponse.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AuthResponse.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AuthResponse clone() => new AuthResponse()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static AuthResponse create() => new AuthResponse();
  static PbList<AuthResponse> createRepeated() => new PbList<AuthResponse>();

  List<int> get signature => getField(1);
  void set signature(List<int> v) { setField(1, v); }
  bool hasSignature() => hasField(1);
  void clearSignature() => clearField(1);

  List<int> get clientAuthCertificate => getField(2);
  void set clientAuthCertificate(List<int> v) { setField(2, v); }
  bool hasClientAuthCertificate() => hasField(2);
  void clearClientAuthCertificate() => clearField(2);
}

class AuthError_ErrorType extends ProtobufEnum {
  static const AuthError_ErrorType INTERNAL_ERROR = const AuthError_ErrorType._(0, 'INTERNAL_ERROR');
  static const AuthError_ErrorType NO_TLS = const AuthError_ErrorType._(1, 'NO_TLS');

  static const List<AuthError_ErrorType> values = const <AuthError_ErrorType> [
    INTERNAL_ERROR,
    NO_TLS,
  ];

  static final Map<int, AuthError_ErrorType> _byValue = ProtobufEnum.initByValue(values);
  static AuthError_ErrorType valueOf(int value) => _byValue[value];

  const AuthError_ErrorType._(int v, String n) : super(v, n);
}

class AuthError extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('AuthError')
    ..e(1, 'errorType', GeneratedMessage.QE, () => AuthError_ErrorType.INTERNAL_ERROR, (var v) => AuthError_ErrorType.valueOf(v))
  ;

  AuthError() : super();
  AuthError.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  AuthError.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  AuthError clone() => new AuthError()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static AuthError create() => new AuthError();
  static PbList<AuthError> createRepeated() => new PbList<AuthError>();

  AuthError_ErrorType get errorType => getField(1);
  void set errorType(AuthError_ErrorType v) { setField(1, v); }
  bool hasErrorType() => hasField(1);
  void clearErrorType() => clearField(1);
}

class DeviceAuthMessage extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DeviceAuthMessage')
    ..a(1, 'challenge', GeneratedMessage.OM, AuthChallenge.create, AuthChallenge.create)
    ..a(2, 'response', GeneratedMessage.OM, AuthResponse.create, AuthResponse.create)
    ..a(3, 'error', GeneratedMessage.OM, AuthError.create, AuthError.create)
  ;

  DeviceAuthMessage() : super();
  DeviceAuthMessage.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DeviceAuthMessage.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DeviceAuthMessage clone() => new DeviceAuthMessage()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DeviceAuthMessage create() => new DeviceAuthMessage();
  static PbList<DeviceAuthMessage> createRepeated() => new PbList<DeviceAuthMessage>();

  AuthChallenge get challenge => getField(1);
  void set challenge(AuthChallenge v) { setField(1, v); }
  bool hasChallenge() => hasField(1);
  void clearChallenge() => clearField(1);

  AuthResponse get response => getField(2);
  void set response(AuthResponse v) { setField(2, v); }
  bool hasResponse() => hasField(2);
  void clearResponse() => clearField(2);

  AuthError get error => getField(3);
  void set error(AuthError v) { setField(3, v); }
  bool hasError() => hasField(3);
  void clearError() => clearField(3);
}

