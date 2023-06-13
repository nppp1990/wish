import 'dart:async';

import 'package:event_bus/event_bus.dart';

final EventBus eventBus = EventBus();

class AddEvent {}

class DeleteWishEvent extends BaseEvent {
  DeleteWishEvent(super.index, super.id);

}

class UpdateWishEvent extends BaseEvent {
  UpdateWishEvent(super.index, super.id);
}
class BaseEvent {
  final int index;
  final int id;

  BaseEvent(this.index, this.id);

  @override
  String toString() {
    return 'index:$index,id:$id';
  }
}
