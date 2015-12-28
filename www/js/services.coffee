angular.module('app.services', [])

.factory('BlackFactory', ->
)

.service('BlankService', ->
)

.factory('Projects', ->
  activeProject: null
  projects: []
  all: ->
    projectString = window.localStorage['projects']
    if projectString
      return angular.fromJson(projectString)
    []
  save: (projects) ->
    window.localStorage['projects'] = angular.toJson(projects)
  newProject: (projectTitle) ->
    title: projectTitle
    tasks: []
  getLastActiveIndex: ->
    parseInt(window.localStorage['lastActiveProject']) or 0
  setLastActiveIndex: (index) ->
    window.localStorage['lastActiveProject'] = index
).

factory('Camera', ['$q', ($q)->
  getPicture: (options)->
    q = $q.defer()
    navigator.camera.getPicture((result)->
      q.resolve(result)
    , (err)->
      q.reject(err)
    , options)

    return q.promise
])