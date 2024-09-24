// Copyright (c) 2018, codegrue. All rights reserved. Use of this source code
// is governed by the MIT license that can be found in the LICENSE file.

/// Package for building card based settings forms
library flutter_material_pickers;

import 'package:flutter/cupertino.dart';

export 'package:file_picker/file_picker.dart' show FileType;

/// Models


/// Helpers


// Constants
const double kPickerHeaderPortraitHeight = 80.0;
const double kPickerHeaderLandscapeWidth = 168.0;
const double kDialogActionBarHeight = 52.0;
const double kDialogMargin = 30.0;

// Typedefs
typedef Transformer<T> = String? Function(T item);
typedef Iconizer<T> = Icon? Function(T item);
