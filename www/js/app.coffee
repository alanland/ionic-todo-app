angular.module('todo', ['ionic']).

factory('Projects', ->
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

controller 'TodoCtrl', ($scope, $timeout, $ionicModal, Projects, $ionicSideMenuDelegate) ->
  createProject = (projectTitle) ->
    newProject = Projects.newProject(projectTitle)
    $scope.projects.push newProject
    Projects.save $scope.projects
    $scope.selectProject newProject, $scope.projects.length - 1

  # Load or initialize projects
  $scope.projects = Projects.all()
  # Grab the last active, or the first project
  $scope.activeProject = $scope.projects[Projects.getLastActiveIndex()]
  # Called to create a new project

  $scope.newProject = ->
    projectTitle = prompt('Project name')
    if projectTitle
      createProject projectTitle

  $scope.selectProject = (project, index) ->
    $scope.activeProject = project
    Projects.setLastActiveIndex index
    $ionicSideMenuDelegate.toggleLeft false

  # Create our modal
  $ionicModal.fromTemplateUrl 'new-task.html', ((modal) ->
    $scope.taskModal = modal
  ), scope: $scope

  $scope.createTask = (task) ->
    if !$scope.activeProject or !task
      return
    $scope.activeProject.tasks.push title: task.title
    $scope.taskModal.hide()
    # Inefficient, but save all the projects
    Projects.save $scope.projects
    task.title = ''

  $scope.newTask = ->
    $scope.taskModal.show()

  $scope.closeNewTask = ->
    $scope.taskModal.hide()

  $scope.toggleProjects = ->
    $ionicSideMenuDelegate.toggleLeft()

  # Try to create the first project, make sure to defer
  # this by using $timeout so everything is initialized
  # properly
  $timeout ->
    if $scope.projects.length == 0
      loop
        projectTitle = prompt('Your first project title:')
        if projectTitle
          createProject projectTitle
          break
