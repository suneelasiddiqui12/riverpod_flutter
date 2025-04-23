import 'package:flutter/material.dart';
import 'package:riverpod_flutter/extensions/context_extensions.dart';
import 'package:riverpod_flutter/extensions/datetime_extensions.dart';
import 'package:riverpod_flutter/extensions/list_extensions.dart';
import 'package:riverpod_flutter/extensions/string_extensions.dart';
import 'package:riverpod_flutter/extensions/textstyle_extensions.dart';
import 'package:riverpod_flutter/extensions/theme_extensions.dart';

class ExtensionsDemoScreen extends StatelessWidget {
  const ExtensionsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String email = "john.doe@gmail.com";
    String name = "flutter";
    DateTime today = DateTime.now();
    List<String> items = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Extensions Demo"),
        backgroundColor: context.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// StringExtensions
            Text("String Extensions:", style: Theme.of(context).textTheme.titleLarge?.bold()),
            Text("Original name: $name"),
            Text("Capitalized: ${name.capitalize()}"),
            Text("Is valid email ($email): ${email.isValidEmail}"),
            const SizedBox(height: 16),

            /// DateTimeExtensions
            Text("DateTime Extensions:", style: Theme.of(context).textTheme.titleLarge?.bold()),
            Text("Today: ${today.formatted}"),
            Text("Is weekend: ${today.isWeekend}"),
            const SizedBox(height: 16),

            /// ContextExtensions
            Text("Context Extensions:", style: Theme.of(context).textTheme.titleLarge?.bold()),
            Text("Screen width: ${context.screenWidth.toStringAsFixed(1)}"),
            Text("Screen height: ${context.screenHeight.toStringAsFixed(1)}"),
            ElevatedButton(
              onPressed: () => context.showSnackBar("Snackbar from extension!"),
              child: const Text("Show SnackBar"),
            ),
            const SizedBox(height: 16),

            /// ListUtils
            Text("List Extensions:", style: Theme.of(context).textTheme.titleLarge?.bold()),
            Text("Is items list null or empty? ${items.isNullOrEmpty}"),
            Text("Safe first item: ${items.safeFirst?.toString() ?? "null"}"),
            const SizedBox(height: 16),

            /// TextStyleExtensions
            Text(
              "Styled using extensions",
              style: Theme.of(context).textTheme.bodyLarge?.bold().italic().size(18),
            ),
            const SizedBox(height: 16),

            /// ThemeExtensions
            Container(
              height: 40,
              width: double.infinity,
              color: context.primaryColor,
              alignment: Alignment.center,
              child: const Text(
                "Container with Primary Color from Theme",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
