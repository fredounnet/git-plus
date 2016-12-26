# {View} = require 'space-pen'
{ScrollView, TextEditorView, View} = require 'atom-space-pen-views'
git = require '../git'

# Store template for file?
# - Populate file with status info?
# - Don't allow saving?

# use enter key to toggle file staged status

class StatusView extends View
  @content: ->
    @div class: 'git-plus-status', =>
      @subview 'body', new TextEditorView()

  initialize: ->
    @body.set

  getURI: -> 'atom://git-plus:status'

  getTitle: -> 'git-plus: Status'

module.exports = (repo) ->
  atom.workspace.addOpener (uri) ->
    return new StatusView if uri is 'atom://git-plus:status'

  git.stagedFiles(repo).then (stagedFiles) ->
    git.unstagedFiles(repo, showUntracked: true).then (unstagedFiles) ->
      atom.workspace.open('atom://git-plus:status').then (editor) ->
        editor.insertText "Staged Files:\n"
        editor.insertText "\t#{file.path}" for file in stagedFiles
        editor.insertText "\n\n"
        editor.insertText "Unstaged Files:\n"
        editor.insertText "\t#{file.path}" for file in unstagedFiles
