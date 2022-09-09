import 'dart:async';

enum FormType { login, register, forgotPassword }

class AuthScreenBloc {
  StreamController<FormType> controller = StreamController<FormType>();
  Stream<FormType> get stream => controller.stream;

  get dispose => controller.close();

  void update(FormType formType) {
    controller.sink.add(formType);
  }
}
