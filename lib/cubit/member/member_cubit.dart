import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wru_fe/models/user.model.dart';

part 'member_state.dart';

class MemberCubit extends Cubit<MemberState> {
  MemberCubit() : super(MemberInitial());
}
