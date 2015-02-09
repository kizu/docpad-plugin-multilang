# Multilang Plugin for [DocPad](http://docpad.org)

[![Build Status](https://secure.travis-ci.org/kizu/docpad-plugin-multilang.png?branch=master)](http://travis-ci.org/kizu/docpad-plugin-multilang "Check this project's build status on TravisCI")
[![NPM version](https://badge.fury.io/js/docpad-plugin-multilang.png)](https://npmjs.org/package/docpad-plugin-multilang "View this project on NPM")
[![Flattr donate button](https://raw.github.com/balupton/flattr-buttons/master/badge-89x18.gif)](http://flattr.com/thing/344188/balupton-on-Flattr "Donate monthly to this project using Flattr")
[![PayPayl donate button](https://www.paypalobjects.com/en_AU/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QB8GQPZAH84N6 "Donate once-off to this project using Paypal")

Adds support for the multilanguage pages
to [DocPad](https://docpad.org)



## Install

```
docpad install multilang
```



## Usage

The plugin doesn't do anything by default.

For enabling it you should add some languages to config, like this:

``` coffee
docpadConfig = {
    plugins:
        multilang:
            languages: ['en', 'ru']
}
module.exports = docpadConfig
```

Doing so would make DocPad to understand language “postfixes” for documents in a way it would rewrite the URLs for them in a nice way.

The following tree:

```
src/
    documents/
        index_en.html
        index_ru.html
        posts/
            foo_ru/
                index.html
                bar.txt
            foo_en.html
```

would be transformed to

```
out/
    ru/
        index.html
        posts/
            foo/
                bar.txt
                index.html
    en/
        index.html
        posts/
            foo/
                index.html
```

You can see that you can add `_en` or `_ru` to both file names and directory names, and the plugin would automatically prettify such urls, so you would always would get `filename/index.html` in the output.



## Configuration

There are several keys for configuration, the default values for them are:

```
    languages: []
    defaultLanguage: null
    omitDefaultFolder: true
    prettifyURL: true
```


### `languages` setting

`languages` setting should be an array consisting of two letter language strings, for example `['en', 'ru']`.

The plugin would then automatically route all the documents with the postfixes containing those languages to the appropriate directories as shown at the usage example above.

Also, the plugin would fill the default metadata for those documents with `lang` key set to the lang's string, so you could then use it in your layouts like `document.lang`.


### `defaultLanguage` setting

`defaultLanguage` setting is optional and can be a string equal to one of the languages from the `languages` array.

If it is present, then the `omitDefaultFolder` setting would be applied and the metadata of all the pages that don't have a language postfix would be set to this default language.


### `omitDefaultFolder` setting

`omitDefaultFolder` setting is optional, enabled by default , but would work only if `defaultLanguage` is set. When it is set to `true`, the plugin would omit the language directory for the given `defaultLanguage`, so all the corresponding files would be placed at the root of the site.

For example, the file system from the usage example, using the following settings:

``` coffee
docpadConfig = {
    plugins:
        multilang:
            languages: ['en', 'ru']
            defaultLanguage: 'en'
}
module.exports = docpadConfig
```

would result in the following tree:

```
out/
    index.html
    posts/
        foo/
            index.html
    ru/
        index.html
        posts/
            foo/
                bar.txt
                index.html
```


### `prettifyURL` setting

`prettifyURL` setting is set to `true` by default and would convert `something_en.html` to `something/index.html` etc. This is made so you would have consistent trees as a result even if you'd have different notations for source documents.

If you'd set this option to `false`, you would get the original filenames, just without the language postfix.



## History

You can discover the history inside the `History.md` file



## License

Licensed under the incredibly [permissive](http://en.wikipedia.org/wiki/Permissive_free_software_licence) [MIT license](http://creativecommons.org/licenses/MIT/)

Copyright &copy; 2015 Roman Komarov <kizmarh@ya.ru> (http://kizu.ru/en/)
