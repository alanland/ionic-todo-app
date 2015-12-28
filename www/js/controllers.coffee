angular.module('app.controllers', [])


.controller('loginCtrl', ($scope)->
)

.controller('signupCtrl', ($scope)->
)

.controller('pageCtrl', ($scope)->
)

.controller('homeCtrl', ($scope, $state, $http, $timeout, $ionicModal, $ionicSideMenuDelegate, Projects, Camera) ->
  createProject = (projectTitle) ->
    newProject = Projects.newProject(projectTitle)
    $scope.projects.push newProject
    Projects.save $scope.projects
    $scope.selectProject newProject, $scope.projects.length - 1

  $scope.projects = Projects.all()
  $scope.activeProject = $scope.projects[Projects.getLastActiveIndex()]

  $scope.doRefresh = ->
    $scope.createTask(title: 'Incoming todo ' + Date.now())
    $scope.$broadcast('scroll.refreshComplete');
  #    $scope.$apply()

  $scope.doRefresh2 = ->
    $http.get('/new-items').success((newItems)->
      $scope.items = newItems
    ).finally(->
      $scope.$broadcast 'scroll.refreshComplete'
    )

  $scope.getPhoto = ->
    Camera.getPicture().then (imageURI)->
      console.log 'success'
      console.log imageURI
    , (err)->
      console.log 'error'
      console.log err

  $scope.newProject = ->
    projectTitle = prompt('Project name')
    if projectTitle
      createProject projectTitle

  $scope.selectProject = (project, index) ->
    $scope.activeProject = project
    Projects.setLastActiveIndex index
    $ionicSideMenuDelegate.toggleLeft false

  # Create our modal
  $ionicModal.fromTemplateUrl 'templates/newTask.html', ((modal) ->
    $scope.taskModal = modal
  ), scope: $scope


  $scope.closeNewTask = ->
    $scope.taskModal.hide()

  $scope.createTask = (task) ->
    if !$scope.activeProject or !task
      return
    $scope.activeProject.tasks.push title: task.title
    $scope.taskModal.hide()
    Projects.save $scope.projects
    task.title = ''

  $scope.newTask = ->
#    $state.go 'newTask'
    $scope.taskModal.show()


  $scope.toggleProjects = ->
    $ionicSideMenuDelegate.toggleLeft()

  $timeout ->
    if $scope.projects.length == 0
      loop
        projectTitle = prompt('Your first project title:')
        if projectTitle
          createProject projectTitle
          break
        else
          createProject 'Test Project'
)

