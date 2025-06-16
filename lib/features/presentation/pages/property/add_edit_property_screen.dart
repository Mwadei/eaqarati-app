import 'package:eaqarati_app/core/utils/constants.dart';
import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:eaqarati_app/features/domain/entities/property_entity.dart';
import 'package:eaqarati_app/features/presentation/blocs/property/property_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class AddEditPropertyScreen extends HookWidget {
  final PropertyEntity? property;
  const AddEditPropertyScreen({this.property, super.key});

  String _getPropertyTypeLocaleName(PropertyType type, BuildContext context) {
    return 'add_edit_property_screen.propertyType_${type.name}'.tr();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final isEditMode = useState(property != null);

    // For form
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameController = useTextEditingController(text: property?.name ?? '');
    final addressController = useTextEditingController(
      text: property?.address ?? '',
    );
    final notesController = useTextEditingController(
      text: property?.notes ?? '',
    );
    final selectedPropertyType = useState<PropertyType?>(property?.type);

    final isLoading = useState(false);

    useEffect(() {
      if (property != null && selectedPropertyType.value == null) {
        selectedPropertyType.value = property!.type;
      }

      return null;
    }, [property]);

    void saveProperty() async {
      if (formKey.currentState!.validate()) {
        if (selectedPropertyType.value == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('add_edit_property_screen.error_select_type'.tr()),
            ),
          );
          return null;
        } else {
          isLoading.value = true;

          final propertyToSave = PropertyEntity(
            propertyId: property?.propertyId,
            name: nameController.text.trim(),
            address: addressController.text.trim(),
            type: selectedPropertyType.value!,
            notes: notesController.text.trim(),
            createdAt: property?.createdAt ?? DateTime.now(),
          );

          if (isEditMode.value) {
            context.read<PropertyBloc>().add(
              UpdateExistingProperty(propertyToSave),
            );
          } else {
            context.read<PropertyBloc>().add(AddNewProperty(propertyToSave));
          }
        }
      }
    }

    return BlocListener<PropertyBloc, PropertyState>(
      listener: (context, state) {
        if (state is PropertyAddedSuccess || state is PropertyUpdateSuccess) {
          isLoading.value = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditMode.value
                    ? 'add_edit_property_screen.success_update'.tr()
                    : 'add_edit_property_screen.success_add'.tr(),
              ),
              backgroundColor: Colors.green,
            ),
          );
          if (context.canPop()) {
            context.pop(true);
          }
        } else if (state is PropertyError) {
          isLoading.value = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
            onPressed: () => context.pop(),
          ),
          title: Text(
            isEditMode.value
                ? 'add_edit_property_screen.title_edit'.tr()
                : 'add_edit_property_screen.title_add'.tr(),
            style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(kPagePadding),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property Name
                Text(
                  'add_edit_property_screen.name_label'.tr(),
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: kVerticalSpaceSmall),
                TextFormField(
                  controller: nameController,
                  style: textTheme.titleSmall,
                  decoration: InputDecoration(
                    hintText: 'add_edit_property_screen.name_hint'.tr(),
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.secondary,
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'add_edit_property_screen.error_name_required'
                          .tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: kVerticalSpaceMedium),

                // Address
                Text(
                  'add_edit_property_screen.address_label'.tr(),
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: kVerticalSpaceSmall),
                TextFormField(
                  controller: addressController,
                  style: textTheme.titleSmall,
                  decoration: InputDecoration(
                    hintText: 'add_edit_property_screen.address_hint'.tr(),
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.secondary,
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  // Address can be optional based on your needs
                ),
                const SizedBox(height: kVerticalSpaceMedium),

                // Property Type
                Text(
                  'add_edit_property_screen.type_label'.tr(),
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: kVerticalSpaceSmall),
                DropdownButtonFormField<PropertyType>(
                  value: selectedPropertyType.value,
                  style: textTheme.titleSmall,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  hint: Text('add_edit_property_screen.type_hint'.tr()),
                  isExpanded: true,
                  items:
                      PropertyType.values.map((PropertyType type) {
                        return DropdownMenuItem<PropertyType>(
                          value: type,
                          child: Text(
                            _getPropertyTypeLocaleName(type, context),
                          ),
                        );
                      }).toList(),
                  onChanged: (PropertyType? newValue) {
                    selectedPropertyType.value = newValue;
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'add_edit_property_screen.error_type_required'
                          .tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: kVerticalSpaceMedium),

                // Notes
                Text(
                  'add_edit_property_screen.notes_label'.tr(),
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: kVerticalSpaceSmall),
                TextFormField(
                  controller: notesController,
                  style: textTheme.titleSmall,
                  decoration: InputDecoration(
                    hintText: 'add_edit_property_screen.notes_hint'.tr(),
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.secondary,
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: 4,
                  minLines: 3,
                ),
                const SizedBox(height: kVerticalSpaceMedium * 2),

                // Save Button
                ElevatedButton.icon(
                  icon:
                      isLoading.value
                          ? Container(
                            width: 20,
                            height: 20,
                            padding: const EdgeInsets.all(2.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : Icon(Icons.save_outlined, color: Colors.white),
                  label: Text(
                    isEditMode.value
                        ? 'common.save_changes'.tr()
                        : 'add_edit_property_screen.save_button'.tr(),
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: isLoading.value ? null : saveProperty,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: kVerticalSpaceSmall * 2),

                // Cancel Button
                OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: BorderSide(
                      color: colorScheme.outline.withOpacity(0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    backgroundColor: colorScheme.surface, // Match image
                  ),
                  child: Text(
                    'common.cancel'.tr(),
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: kVerticalSpaceMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
