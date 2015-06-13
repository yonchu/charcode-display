CharcodeDisplayView = require '../lib/charcode-display-view'

describe "CharcodeDisplayView", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('charcode-display')

  describe "when initialized", ->
    beforeEach ->
      waitsForPromise ->
        atom.packages.activatePackage('status-bar')
      waitsForPromise ->
        activationPromise

    it "shows '' in textContent", ->
      runs ->
        charcodeDisplayElement = workspaceElement.querySelector('.charcode-display')
        expect(charcodeDisplayElement.textContent).toEqual ''

    it "shows 'NUL' in textContent", ->
      waitsForPromise ->
        atom.workspace.open()
      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText('')
        editor.setCursorBufferPosition([0, 0])
        charcodeDisplayElement = workspaceElement.querySelector('.charcode-display')
        expect(charcodeDisplayElement.textContent).toEqual 'NUL'

  describe "when insert a character and set cursor on it", ->
    beforeEach ->
      waitsForPromise ->
        atom.packages.activatePackage('status-bar')
      waitsForPromise ->
        activationPromise
      waitsForPromise ->
        atom.workspace.open()

    it "shows ''a': 0x0061 (U+0061)'' in textContent", ->
      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText('a')
        editor.setCursorBufferPosition([0, 0])
        charcodeDisplayElement = workspaceElement.querySelector('.charcode-display')
        expect(charcodeDisplayElement.textContent).toEqual "'a': 0x0061 (U+0061)"

    it "shows ''あ': 0xE38182 (U+3042)' in textContent", ->
      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText('あ')
        editor.setCursorBufferPosition([0, 0])
        charcodeDisplayElement = workspaceElement.querySelector('.charcode-display')
        expect(charcodeDisplayElement.textContent).toEqual "'あ': 0xE38182 (U+3042)"

    it "shows ''尾': 0xE5B0BE (U+5C3E)' in textContent", ->
      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText('尾')
        editor.setCursorBufferPosition([0, 0])
        charcodeDisplayElement = workspaceElement.querySelector('.charcode-display')
        expect(charcodeDisplayElement.textContent).toEqual "'尾': 0xE5B0BE (U+5C3E)"

    it "shows ''𠀋': 0xF0A0808B (U+2000B)' in textContent", ->
      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText('𠀋')
        editor.setCursorBufferPosition([0, 0])
        charcodeDisplayElement = workspaceElement.querySelector('.charcode-display')
        expect(charcodeDisplayElement.textContent).toEqual "'𠀋': 0xF0A0808B (U+2000B)"

  describe "when insert a character, set encoding to sjis and set cursor on it", ->
    beforeEach ->
      waitsForPromise ->
        atom.packages.activatePackage('status-bar')
      waitsForPromise ->
        activationPromise
      waitsForPromise ->
        atom.workspace.open()

    it "shows ''a': 0x0061 (U+0061)'' in textContent", ->
      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editor.setEncoding 'ShiftJis'
        editor.insertText('a')
        editor.setCursorBufferPosition([0, 0])
        charcodeDisplayElement = workspaceElement.querySelector('.charcode-display')
        expect(charcodeDisplayElement.textContent).toEqual "'a': 0x0061 (U+0061)"

    it "shows ''あ': 0x82A0 (U+3042)' in textContent", ->
      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editor.setEncoding 'ShiftJis'
        editor.insertText('あ')
        editor.setCursorBufferPosition([0, 0])
        charcodeDisplayElement = workspaceElement.querySelector('.charcode-display')
        expect(charcodeDisplayElement.textContent).toEqual "'あ': 0x82A0 (U+3042)"

  describe "when insert a character, set encoding to eucjp and set cursor on it", ->
    beforeEach ->
      waitsForPromise ->
        atom.packages.activatePackage('status-bar')
      waitsForPromise ->
        activationPromise
      waitsForPromise ->
        atom.workspace.open()

    it "shows ''a': 0x0061 (U+0061)'' in textContent", ->
      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editor.setEncoding 'EUC-JP'
        editor.insertText('a')
        editor.setCursorBufferPosition([0, 0])
        charcodeDisplayElement = workspaceElement.querySelector('.charcode-display')
        expect(charcodeDisplayElement.textContent).toEqual "'a': 0x0061 (U+0061)"

    it "shows ''あ': 0xA4A2 (U+3042)' in textContent", ->
      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editor.setEncoding 'EUC-JP'
        editor.insertText('あ')
        editor.setCursorBufferPosition([0, 0])
        charcodeDisplayElement = workspaceElement.querySelector('.charcode-display')
        expect(charcodeDisplayElement.textContent).toEqual "'あ': 0xA4A2 (U+3042)"
