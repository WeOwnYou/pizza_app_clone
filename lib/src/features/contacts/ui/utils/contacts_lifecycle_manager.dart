import 'package:dodo_clone/src/features/contacts/bloc/contacts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsLifecycleManager extends StatefulWidget {
  final Widget child;
  const ContactsLifecycleManager({Key? key, required this.child})
      : super(key: key);
  @override
  State<ContactsLifecycleManager> createState() =>
      _ContactsLifecycleManagerState();
}

class _ContactsLifecycleManagerState extends State<ContactsLifecycleManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final contactsCubit = context.read<ContactsCubit>();
    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        try {
          late final ChatState chatState;
          if (contactsCubit.state.chatState == ChatState.active) {
            chatState = ChatState.paused;
          } else {
            chatState = ChatState.disabled;
          }
          contactsCubit.onDisposed(chatState: chatState);
        } on Exception {
          break;
        }
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: widget.child,
    );
  }
}
