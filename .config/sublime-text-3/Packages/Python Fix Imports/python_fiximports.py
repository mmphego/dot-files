# -*- coding: utf-8 -*-

# Copyright 2012-2013 Stéphane Bunel
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from __future__ import absolute_import

import os
import sublime
import sublime_plugin
import sys

debug = False


def printDebug(text, *args):
    if debug:
        print("[Python Fix Imports] " + text, args)

PPA_PATH = list()
PYMAMI = '{0}{1}'.format(*sys.version_info[:2])
ST_VERSION = 3000 if sublime.version() == '' else int(sublime.version())
PLUGIN_NAME = "Python Fix Imports"
package_name = PLUGIN_NAME
SETTINGS_FILE = 'python_fiximports.sublime-settings'

if sublime.platform() == 'windows':
    USER_CONFIG_NAME = 'python_fiximports.sublime-settings'
else:
    USER_CONFIG_NAME = 'python_fiximports.sublime-settings'

try:
    from .libs import fiximports
    from .libs import MergeUtils
except:
    sublime.error_message(
        '{0}: import error: {1}'.format(PLUGIN_NAME, sys.exc_info()[1]))
    raise

override_enable_python_auto_fiximports = None
disable_python_autofix_for_files = set()
enable_python_autofix_for_files = set()


def load_python_fiximports_settings(name, default):
    view = sublime.active_window().active_view()
    project_config = view.settings().get('python_fiximports', {}) if view else {}
    global_config = sublime.load_settings(USER_CONFIG_NAME)

    return project_config.get(name, global_config.get(name, default))


def get_current_filename():
    view = sublime.Window.active_view(sublime.active_window())
    return os.path.abspath(view.file_name())


class PythonFiximportsCommand(sublime_plugin.TextCommand):

    def run(self, edit):
        syntax = self.view.settings().get('syntax')
        if 'python' not in syntax.lower():
            return
        replace_region = self.view.line(sublime.Region(0, self.view.size()))
        source = self.view.substr(replace_region)

        printDebug("Reorganizing file ")
        split_import_statements = load_python_fiximports_settings("split_import_statements", False)
        sort_import_statements = load_python_fiximports_settings("sort_import_statements", False)
        printDebug("Options")
        printDebug("split_import_statements = {!r}".format(split_import_statements))
        printDebug("sort_import_statements = {!r}".format(sort_import_statements))

        _res, fixed = fiximports.FixImports().sortImportGroups(
            "filename", source,
            splitImportStatements=split_import_statements,
            sortImportStatements=sort_import_statements)
        _is_dirty, err = MergeUtils.merge_code(self.view, edit, source, fixed)
        if err:
            sublime.error_message(
                "%s: Merge failure: '%s'" % (PLUGIN_NAME, err))
            raise


class EnablePythonFiximportsCommand(sublime_plugin.TextCommand):

    def run(self, edit):
        global override_enable_python_auto_fiximports
        printDebug("EnablePythonFiximportsCommand")
        override_enable_python_auto_fiximports = True


class DisablePythonFiximportsCommand(sublime_plugin.TextCommand):

    def run(self, edit):
        global override_enable_python_auto_fiximports
        printDebug("DisablePythonFiximportsCommand")
        override_enable_python_auto_fiximports = False


class DisablePythonFiximportsForFileCommand(sublime_plugin.TextCommand):

    def run(self, edit):
        printDebug("DisablePythonFiximportsForFileCommand")
        f = get_current_filename()
        disable_python_autofix_for_files.add(f)
        if f in enable_python_autofix_for_files:
            enable_python_autofix_for_files.remove(f)


class EnablePythonFiximportsForFileCommand(sublime_plugin.TextCommand):

    def run(self, edit):
        printDebug("enable_python_autofix_for_files")
        f = get_current_filename()
        enable_python_autofix_for_files.add(f)
        if f in disable_python_autofix_for_files:
            disable_python_autofix_for_files.remove(f)


class PythonFiximportsBackground(sublime_plugin.EventListener):

    def on_pre_save(self, view):
        syntax = view.settings().get('syntax')
        if 'python' not in syntax.lower():
            printDebug("Not a python file. Don't try to autofix")
            return

        f = get_current_filename()

        if f in enable_python_autofix_for_files:
            printDebug("Current file in list of forced autofix. Do autofix")
            view.run_command('python_fiximports')
            return

        if not load_python_fiximports_settings('autofix_on_save', False):
            printDebug("Auto fix on save is Disabled. Do not autofix")
            return

        if f in disable_python_autofix_for_files:
            printDebug("Current file in list of disabled autofix. Don't autofix")
            return

        if override_enable_python_auto_fiximports is False:
            printDebug("Temporary override of autofix import set to Disabled. Do not autofix")
            return

        printDebug("Nominal case: do autofix")
        view.run_command('python_fiximports')
