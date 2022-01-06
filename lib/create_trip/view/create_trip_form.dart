import 'dart:developer';

import 'package:corremundos/common/widgets/base_page.dart';
import 'package:corremundos/create_trip/cubit/create_trip_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CreateTripForm extends BasePage {
  const CreateTripForm({Key? key}) : super(key);

  @override
  String title(BuildContext context) => 'Create Trip';

  @override
  Widget? floatingActionButton(BuildContext context) => null;

  @override
  Widget widget(BuildContext context) {
    return BlocBuilder<CreateTripCubit, CreateTripState>(
      builder: (context, state) {
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
                        'New Trip',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _TripNameInput(),
                  const SizedBox(height: 8),
                  _TripInitDatePicker(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
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
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextButton(
          onPressed: () {
            DatePicker.showDatePicker(
              context,
              onChanged: (date) {
                log('change $date');
              },
              onConfirm: (date) {
                context.read<CreateTripCubit>().initDateChanged(date);
              },
              currentTime: DateTime.now(),
            );
          },
          // TODO: add init date format like input text
          // TODO: add end date
          child: RichText(
            text: const TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.date_range_rounded,
                    color: Color.fromRGBO(90, 23, 238, 1),
                  ),
                ),
                TextSpan(
                  text: 'Init date',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(90, 23, 238, 1),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// TODO: load unsplash image, update it to firebase
// TODO: set field as text + button inline
class _ImageUrlInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    return BlocBuilder<CreateTripCubit, CreateTripState>(
      buildWhen: (previous, current) => previous.imageUrl != current.imageUrl,
      builder: (context, state) {
        return TextField(
          focusNode: focusNode,
          key: const Key('newTripForm_imageUrlInput_textField'),
          style: const TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(90, 23, 238, 1),
          ),
          onChanged: (name) =>
              context.read<CreateTripCubit>().nameChanged(name),
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            labelStyle: TextStyle(
              color: focusNode.hasFocus
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            labelText: 'Trip image',
            prefix: const Padding(
              padding: EdgeInsets.only(top: 2.5, right: 2.5),
            ),
            prefixIcon: const Icon(
              Icons.image_rounded,
              color: Color.fromRGBO(90, 23, 238, 1),
            ),
          ),
        );
      },
    );
  }
}
