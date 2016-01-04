angular.module('app.controllers', ['ngCordova'])


.controller('loginCtrl', ($scope)->
)

.controller('signupCtrl', ($scope)->
)

.controller('pageCtrl', ($scope)->
)

.controller('homeCtrl', ($scope, $state, $http, $timeout, $ionicModal,
    $ionicSideMenuDelegate, $ionicListDelegate, Projects, Camera) ->
    $scope.shouldShowDelete = false;
    $scope.shouldShowReorder = false;
    $scope.listCanSwipe = true

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
#        $scope.modal.hide()
        if !$scope.activeProject or !task
            return
        $scope.activeProject.tasks.push title: task.title, description: task.description
        $scope.taskModal.hide()
        Projects.save $scope.projects
        task.title = ''
        task.description = ''
        task.finished = false

    $scope.newTask = ->
#    $state.go 'newTask'
        $scope.shouldShowReorder = false
        $scope.shouldShowDelete = false
        $scope.taskModal.show()

    $scope.toggleProjects = ->
        $ionicSideMenuDelegate.toggleLeft()

    $scope.onTaskEdit = (item) ->
        return

    $scope.onTaskShare = (item) ->
        alert('Share Item: ' + item.id);

    $scope.moveTask = (item, fromIndex, toIndex) ->
        $scope.items.splice(fromIndex, 1);
        $scope.items.splice(toIndex, 0, item);

    $scope.onTaskDelete = (task) ->
        $scope.activeProject.tasks.splice($scope.activeProject.tasks.indexOf(task), 1);

        $scope.projects[Projects.getLastActiveIndex()] = $scope.activeProject
        Projects.save $scope.projects

    $scope.onTaskHold = (item)->
        $scope.shouldShowReorder = true
        $scope.shouldShowDelete = true

    $scope.onTaskSwipeRight = (task)->
# finish task
        task.finished = true

    $scope.showDeviceMotionTest = ->
        $state.go 'deviceMotionTest'

    $scope.items = [
        {id: 0},
        {id: 1},
        {id: 2},
        {id: 43},
        {id: 44},
        {id: 45},
        {id: 46},
        {id: 47},
        {id: 48},
        {id: 49},
        {id: 50}
    ];

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

.controller('deviceMotionTestCtrl', ($scope, $state, $cordovaDeviceMotion)->
    $scope.position = {}

    $scope.goHome = ->
        $state.go 'home'

    options = frequency: 200
    document.addEventListener('deviceready', ->
        watch = $cordovaDeviceMotion.watchAcceleration(options)
        watch.then(
            null
            (err)->
                return
            (result)->
                console.log result
                $scope.position = result
        )
#        watch.clearWatch()
# OR
#        $cordovaDeviceMotion.clearWatch(watch).then(
#            (result)->
#                return
#            (err)->
#                return
#        )
    )
)


