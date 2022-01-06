import 'package:cached_network_image/cached_network_image.dart';
import 'package:corremundos/common/widgets/base_page.dart';
import 'package:corremundos/create_trip/cubit/create_trip_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CreateTripForm extends BasePage {
  const CreateTripForm({Key? key}) : super(key);

  @override
  String title(BuildContext context) => 'Create Trip';

  @override
  Widget? floatingActionButton(BuildContext context) => null;

  @override
  List<Widget>? actions(BuildContext context) {
    final items = <Widget>[
      IconButton(
        key: const Key('editTrip_save_iconButton'),
        icon: const Icon(Icons.check),
        onPressed: () async {
          await context.read<CreateTripCubit>().saveTrip().then((value) {
            showTopSnackBar(
              context,
              const CustomSnackBar.success(
                message: 'Trip created',
                icon: Icon(null),
                backgroundColor: Color.fromRGBO(255, 88, 101, 1),
              ),
            );
          });
          Navigator.of(context).pop();
        },
      )
    ];
    return items;
  }

  @override
  Widget widget(BuildContext context) {
    return BlocBuilder<CreateTripCubit, CreateTripState>(
      builder: (context, state) {
        final imageUrl = state.imageUrl.isEmpty
            ? 'https://firebasestorage.googleapis.com/v0/b/corremundos-9203a.appspot.com/o/trip_placeholder.jpg?alt=media&token=17259183-edb0-4323-8f12-07ad1fecfdcf'
            : state.imageUrl;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Text(
                        'Your new trip',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _GetTripImageButton(imageUrl),
                  const SizedBox(height: 24),
                  _TripNameInput(),
                  const SizedBox(height: 8),
                  _TripInitDatePicker(),
                  const SizedBox(height: 8),
                  _TripEndDatePicker(),
                  const SizedBox(height: 8),
                  _SaveTrip(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GetTripImageButton extends StatelessWidget {
  const _GetTripImageButton(this.image, {Key? key}) : super(key: key);

  final String image;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200 * 1.85,
      height: 200,
      child: Card(
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 9,
        child: Ink(
          decoration: _cardDecoration(image),
        ),
      ),
    );
  }
}

Decoration _cardDecoration(String imageUrl) {
  return BoxDecoration(
    image: DecorationImage(
      fit: BoxFit.fitWidth,
      image: CachedNetworkImageProvider(imageUrl),
    ),
  );
}

class _TripNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    return BlocBuilder<CreateTripCubit, CreateTripState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextField(
          focusNode: focusNode,
          key: const Key('newTripForm_nameInput_textField'),
          style: const TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(90, 23, 238, 1),
          ),
          onChanged: (name) =>
              context.read<CreateTripCubit>().nameChanged(name),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelStyle: TextStyle(
              color: focusNode.hasFocus
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            labelText: 'Trip name',
            prefix: const Padding(
              padding: EdgeInsets.only(top: 2.5, right: 2.5),
            ),
            prefixIcon: const Icon(
              Icons.description_rounded,
              color: Color.fromRGBO(90, 23, 238, 1),
            ),
          ),
        );
      },
    );
  }
}

class _TripInitDatePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTripCubit, CreateTripState>(
      buildWhen: (previous, current) => previous.initDate != current.initDate,
      builder: (context, state) {
        final _textController = TextEditingController();
        if (state.initDate != null) {
          _textController.text =
              DateFormat('dd/MM/yyyy').format(state.initDate!);
        }
        return TextField(
          readOnly: true,
          controller: _textController,
          style: const TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(90, 23, 238, 1),
          ),
          onSubmitted: (date) => context
              .read<CreateTripCubit>()
              .initDateChanged(DateFormat('dd/MM/yyyy').parse(date)),
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            labelStyle: const TextStyle(
              color: Colors.grey,
            ),
            labelText: 'Init date',
            prefix: const Padding(
              padding: EdgeInsets.only(top: 2.5, right: 2.5),
            ),
            prefixIcon: IconButton(
              icon: const Icon(Icons.calendar_today_rounded),
              color: const Color.fromRGBO(90, 23, 238, 1),
              onPressed: () {
                FocusScope.of(context).unfocus();
                DatePicker.showDatePicker(
                  context,
                  onConfirm: (date) {
                    context.read<CreateTripCubit>().initDateChanged(date);
                  },
                  currentTime: DateTime.now(),
                );
                FocusScope.of(context).unfocus();
              },
            ),
            hintText: 'dd/MM/yyyy',
          ),
        );
      },
    );
  }
}

class _TripEndDatePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTripCubit, CreateTripState>(
      buildWhen: (previous, current) => previous.endDate != current.endDate,
      builder: (context, state) {
        final _textController = TextEditingController();
        if (state.endDate != null) {
          _textController.text =
              DateFormat('dd/MM/yyyy').format(state.endDate!);
        }
        return TextField(
          readOnly: true,
          controller: _textController,
          style: const TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(90, 23, 238, 1),
          ),
          onSubmitted: (date) => context
              .read<CreateTripCubit>()
              .endDateChanged(DateFormat('dd/MM/yyyy').parse(date)),
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            labelStyle: const TextStyle(
              color: Colors.grey,
            ),
            labelText: 'End date',
            prefix: const Padding(
              padding: EdgeInsets.only(top: 2.5, right: 2.5),
            ),
            prefixIcon: IconButton(
              icon: const Icon(Icons.calendar_today_rounded),
              color: const Color.fromRGBO(90, 23, 238, 1),
              onPressed: () {
                FocusScope.of(context).unfocus();
                DatePicker.showDatePicker(
                  context,
                  onConfirm: (date) {
                    context.read<CreateTripCubit>().endDateChanged(date);
                  },
                  currentTime: DateTime.now(),
                );
                FocusScope.of(context).unfocus();
              },
            ),
            hintText: 'dd/MM/yyyy',
          ),
        );
      },
    );
  }
}

class _SaveTrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 50,
      child: ElevatedButton(
        key: const Key('newTripForm_save_button'),
        onPressed: () {
          context.read<CreateTripCubit>().saveTrip();
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          primary: const Color.fromRGBO(90, 23, 238, 1),
        ),
        child: const Text(
          'Save',
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
