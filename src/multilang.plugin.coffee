# Export Plugin
module.exports = (BasePlugin) ->
    # Define Plugin
    class MultilangPlugin extends BasePlugin
        # Plugin name
        name: 'multilang'

        # Configuration
        config:
            languages: []
            defaultLanguage: null
            omitDefaultFolder: true
            prettifyURL: true

        # Render some content synchronously
        renderBefore: (opts) ->
            config = @config
            docpad = @docpad
            escapeStringRegexp = require('escape-string-regexp')
            languages = config.languages
            defaultLanguage = config.defaultLanguage
            shouldPrettifyURL = config.prettifyURL
            shouldOmitDefaultFolder = config.omitDefaultFolder

            # TODO: need better config options validation (only two letters etc.)

            # If we have no languages, then do nothing
            unless languages.length > 0
                return

            languageRegex = ///^(.+?)_(#{languages.join('|')})///
            docpad.getCollection('documents').findAllLive({relativePath: languageRegex}).forEach (document) ->
                parts = document.attributes.relativeBase.match(languageRegex)
                initialName = parts[1]
                initialNameEscaped = escapeStringRegexp(initialName)
                language = parts[2]

                addPrefixRegex = ///(#{initialNameEscaped}_#{language})///
                addPrefixReplace = "#{language}/$1"
                removePostfixRegex = ///(#{initialNameEscaped})_#{language}///
                replaceWithIndexRegex = ///(#{initialNameEscaped})\.html///
                replaceWithIndexReplace = "$1/index.html"

                if shouldOmitDefaultFolder and language == defaultLanguage
                    addPrefixReplace = "$1"

                if initialName.match(/(^|\/)index$/) or not shouldPrettifyURL
                    replaceWithIndexReplace = '$1.html'

                replacePath = (input) ->
                    input
                        .replace(addPrefixRegex, addPrefixReplace)
                        .replace(removePostfixRegex, "$1")
                        .replace(replaceWithIndexRegex, replaceWithIndexReplace)

                replaceAttibute = (attribute) ->
                    document.set attribute, replacePath document.get(attribute)

                # Change urls
                newUrl = replacePath document.get('url') # Could add `index.html` for really static env
                if not newUrl.match(/\.\w+$/)
                    newUrl = newUrl + '/'
                document.setUrl(newUrl)
                document.set('urls', [newUrl])

                # Change rel dir path
                document.set 'relativeOutDirPath', "#{language}/#{document.get('relativeOutDirPath')}"

                # Change all the other stuff
                replaceAttibute 'outPath'
                replaceAttibute 'relativeOutPath'

                # Set the document's language to the current language
                document.setMetaDefaults { lang: language }

                # TODO: find out if we need to change the below thingies

                # replaceAttibute 'outBasename'
                # replaceAttibute 'relativeOutBase'

                # document.set 'relativeOutBase', (document.get('relativeOutBase') + '/')

            # Set the default `lang` metadata of each document to the default language
            if defaultLanguage
                docpad.getCollection('documents').forEach (document) ->
                    document.setMetaDefaults { lang: defaultLanguage }

