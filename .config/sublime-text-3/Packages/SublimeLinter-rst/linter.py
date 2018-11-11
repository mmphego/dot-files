#
# linter.py
# Linter for SublimeLinter3, a code checking framework for Sublime Text 3
#
# Written by German M. Bravo (Kronuz)
# Copyright (c) 2013 German M. Bravo (Kronuz)
#
# License: MIT
#

"""This module exports the rst plugin linter class."""

from SublimeLinter.lint import highlight, Linter

import docutils
from docutils.nodes import Element
from docutils.parsers.rst import Parser


class Rst(Linter):

    """Provides an interface to docutils' restructuredtext checks."""

    syntax = ('restructuredtext', 'restructuredtext improved')
    cmd = None

    def run(self, cmd, code):
        """Attempt to parse code as reStructuredText."""
        # Generate a new parser
        parser = Parser()

        settings = docutils.frontend.OptionParser(
            components=(docutils.parsers.rst.Parser,)
        ).get_default_values()

        document = docutils.utils.new_document(None, settings=settings)
        document.reporter.stream = None
        document.reporter.halt_level = 5

        # Collect errors via an observer
        def error_collector(data):
            # Mutate the data since it was just generated
            data.type = data['type']
            data.level = data['level']
            data.message = Element.astext(data.children[0])
            data.full_message = Element.astext(data)

            # Save the error
            errors.append(data)

        errors = []
        document.reporter.attach_observer(error_collector)
        parser.parse(code, document)

        for data in errors:
            message = data.message.replace("\n", " ")

            if 'Unknown directive type' in message:
                continue
            if 'Unknown interpreted text role' in message:
                continue
            if 'Substitution definition contains illegal element' in message:
                # there will be error message for the contents it
                # self so let's ignore it.
                continue

            if data.level >= 3:
                error_type = highlight.ERROR
            else:
                error_type = highlight.WARNING

            line = data['line'] - 1

            self.highlight.range(line, 0, error_type=error_type)
            self.error(line, 0, message, error_type)
