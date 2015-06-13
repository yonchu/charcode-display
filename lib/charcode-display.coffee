CharcodeDisplayView = require './charcode-display-view'
{CompositeDisposable} = require 'atom'

module.exports = CharcodeDisplay =
  config:
    charcodeDisplayFormat:
      type: 'string'
      default: "'%C': %D (%P)"
      description: 'Format for the cursor position status bar element,
        where %C is the character, %D is the charcode
        and %P is the Unicode Codepoint'

  charcodeDisplayView: null
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up
    # with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    @charcodeDisplayView = new CharcodeDisplayView()
    @charcodeDisplayView.initialize()

  consumeStatusBar: (statusBar) ->
    @tile = statusBar.addLeftTile item: @charcodeDisplayView, priority: 100

  deactivate: ->
    @subscriptions.dispose()

    @charcodeDisplayView.destroy()
    @charcodeDisplayView = null

    @tile?.destroy()
    @tile = null

  serialize: ->
    charcodeDisplayViewState: @charcodeDisplayView.serialize()
