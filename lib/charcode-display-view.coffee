iconv = require 'iconv-lite'

class CharcodeDisplayView extends HTMLElement
  initialize: ->
    # Add CSS class to this element.
    @classList.add 'charcode-display', 'inline-block'

    # The content to display in this element.
    @textContent = ''

    # The character informaton under the current curosr position.
    @character = null
    @charcode = null
    @codepoint = null

    @formatString = atom.config.get 'charcode-display.charcodeDisplayFormat'

    # Subscription viriables.
    @cursorSubscription = null
    @configSubscription = null
    @activeItemSubscription = atom.workspace.onDidChangeActivePaneItem (activeItem) =>
      @subscribeToActiveTextEditor()

    # Initialize.
    @subscribeToConfig()
    @subscribeToActiveTextEditor()

    @tooltip = atom.tooltips.add(this, title: ->
      "Char: '#{@character}', Charcode: #{@charcode}, Codepoint: #{@codepoint}")

  subscribeToActiveTextEditor: ->
    @cursorSubscription?.dispose()
    @cursorSubscription = @getActiveTextEditor()?.onDidChangeCursorPosition =>
      @updateCharcode()
    @updateCharcode()

  subscribeToConfig: ->
    @configSubscription?.dispose()
    @configSubscription = atom.config.observe 'charcode-display.charcodeDisplayFormat', (value) =>
      @formatString = value
      @updateCharcode()

  getActiveTextEditor: ->
    atom.workspace.getActiveTextEditor()

  updateCharcode: ->
    editor = @getActiveTextEditor()
    unless encoding = editor?.getEncoding()
      @textContent = null
      return
    cursor = editor?.getLastCursor()
    column = cursor?.getBufferColumn()
    code = cursor?.getCurrentBufferLine().codePointAt column
    if code
      @character = String.fromCodePoint code
      @charcode = @getCharcode @character, encoding
      @codepoint = @getUnicodeCodePoint code
      @textContent = @formatString.replace('%C', @character)
        .replace('%D', @charcode).replace('%P', @codepoint)
    else
      @textContent = 'NUL'

  getCharcode: (char, encoding) ->
    rtn = ''
    for c in iconv.encode(char, encoding)
      rtn += c.toString(16).toUpperCase()
    if rtn.length < 1
      rtn = '0000'
    else if rtn.length < 4
      rtn = ('000' + rtn).slice(-4)
    return '0x' + rtn

  getUnicodeCodePoint: (code) ->
    rtn = ''
    unless isNaN(code)
      rtn = code.toString(16).toUpperCase()
    if rtn.length < 1
      rtn = '0000'
    else if rtn.length < 4
      rtn = ('000' + rtn).slice(-4)
    return 'U+' + rtn

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @cursorSubscription?.dispose()
    @configSubscription?.dispose()
    @activeItemSubscription.dispose()
    @tooltip.dispose()

module.exports = document.registerElement('charcode-display',
  prototype: CharcodeDisplayView.prototype, extends: 'div')
