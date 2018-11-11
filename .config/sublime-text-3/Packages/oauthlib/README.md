# OAuthlib for Package Control
[![Build Status](https://travis-ci.org/packagecontrol/oauthlib.svg)](https://travis-ci.org/packagecontrol/oauthlib)


This is the *[oauthlib][]* module
bundled for usage with [Package Control][],
a package manager
for the [Sublime Text][] text editor.


this repo | pypi
---- | ----
![latest tag](https://img.shields.io/github/tag/packagecontrol/oauthlib.svg) | [![pypi](https://img.shields.io/pypi/v/oauthlib.svg)][pypi]


## How to use *oauthlib* as a dependency

In order to tell Package Control
that you are using the *oauthlib* module
in your ST package,
create a `dependencies.json` file
in your package root
with the following contents:

```js
{
   "*": {
      "*": [
         "oauthlib"
      ]
   }
}
```

If the file exists already,
add `"oauthlib"` to the every dependency list.

Then run the **Package Control: Satisfy Dependencies** command
to make Package Control
install the module for you locally
(if you don't have it already).

After all this
you can use `import oauthlib`
in any of your Python plugins.

See also:
[Documentation on Dependencies](https://packagecontrol.io/docs/dependencies)


## How to update this repository (for contributors)

1. Download the latest tarball
   from [pypi][].
2. Delete everything inside the `all/` folder.
3. Copy the `oauthlib/` folder,
   and everything related to copyright/licensing
   from the tarball
   to the `all/` folder.
4. Commit changes
   and either create a pull request
   or create a tag directly
   in the format `v<version>`
   (in case you have push access).


## License

The contents of the root folder
in this repository
are released
under the *public domain*.
The contents of the `all/` folder
fall under *their own bundled licenses*.


[oauthlib]: https://oauthlib.readthedocs.org/en/latest/
[Package Control]: http://packagecontrol.io/
[Sublime Text]: http://sublimetext.com/
[pypi]: https://pypi.python.org/pypi/oauthlib
