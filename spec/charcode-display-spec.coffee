CharcodeDisplay = require '../lib/charcode-display'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "CharcodeDisplay", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('charcode-display')

  describe "when this package is activated", ->
    it "shows CharactercodeDisplayView", ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.charcode-display')).not.toExist()

      waitsForPromise ->
        atom.packages.activatePackage('status-bar')

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        charcodeDisplayElement = workspaceElement.querySelector('.charcode-display')
        expect(charcodeDisplayElement).toExist()
        expect(charcodeDisplayElement.parentNode).toBeVisible()
