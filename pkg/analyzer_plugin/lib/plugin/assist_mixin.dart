// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/src/dart/analysis/driver.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';
import 'package:analyzer_plugin/protocol/protocol.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:analyzer_plugin/src/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/generator.dart';

/**
 * A mixin that can be used when creating a subclass of [ServerPlugin] to
 * provide most of the implementation for handling assist requests.
 *
 * Clients may not extend or implement this class, but are allowed to use it as
 * a mix-in when creating a subclass of [ServerPlugin].
 */
abstract class AssistsMixin implements ServerPlugin {
  /**
   * Return a list containing the assist contributors that should be used to
   * create assists when used in the context of the given analysis [driver].
   */
  List<AssistContributor> getAssistContributors(
      covariant AnalysisDriverGeneric driver);

  /**
   * Return the assist request that should be passes to the contributors
   * returned from [getAssistContributors].
   */
  Future<AssistRequest> getAssistRequest(
      EditGetAssistsParams parameters, covariant AnalysisDriverGeneric driver);

  @override
  Future<EditGetAssistsResult> handleEditGetAssists(
      EditGetAssistsParams parameters) async {
    String path = parameters.file;
    ContextRoot contextRoot = contextRootContaining(path);
    if (contextRoot == null) {
      // Return an error from the request.
      throw new RequestFailure(
          RequestErrorFactory.pluginError('Failed to analyze $path', null));
    }
    AnalysisDriverGeneric driver = driverMap[contextRoot];
    AssistRequest request = await getAssistRequest(parameters, driver);
    AssistGenerator generator =
        new AssistGenerator(getAssistContributors(driver));
    GeneratorResult result = await generator.generateAssistsResponse(request);
    result.sendNotifications(channel);
    return result.result;
  }
}

/**
 * A mixin that can be used when creating a subclass of [ServerPlugin] and
 * mixing in [AssistsMixin]. This implements the creation of the assists request
 * based on the assumption that the driver being created is an [AnalysisDriver].
 *
 * Clients may not extend or implement this class, but are allowed to use it as
 * a mix-in when creating a subclass of [ServerPlugin] that also uses
 * [AssistsMixin] as a mix-in.
 */
abstract class DartAssistsMixin implements AssistsMixin {
  @override
  Future<AssistRequest> getAssistRequest(
      EditGetAssistsParams parameters, covariant AnalysisDriver driver) async {
    ResolveResult result = await driver.getResult(parameters.file);
    return new DartAssistRequestImpl(
        resourceProvider, parameters.offset, parameters.length, result);
  }
}
