angular.module('app.routes', [])

.config(($stateProvider, $urlRouterProvider)->
    $urlRouterProvider.otherwise('/')

    $stateProvider
    .state('home', {
        url: '/',
        templateUrl: 'templates/home.html',
        controller: 'homeCtrl'
    })

    .state('login', {
        url: '/login',
        templateUrl: 'templates/login.html',
        controller: 'loginCtrl'
    })

    .state('menu', {
        url: '/menu',
        abstract: true,
        templateUrl: 'templates/menu.html'
    })

    .state('signup', {
        url: '/signup',
        templateUrl: 'templates/signup.html',
        controller: 'signupCtrl'
    })

    .state('newTask', {
        url: '/newTask',
        templateUrl: 'templates/newTask.html',
        controller: 'newTaskCtrl'
    })

    .state('deviceMotionTest', {
        url: '/deviceMotionTest',
        templateUrl: 'templates/deviceMotionTest.html',
        controller: 'deviceMotionTestCtrl'
    })
)
