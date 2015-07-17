app = angular.module("Todo", ["ngResource", "ui.bootstrap", 'templates', "xeditable"])

app.run ["editableOptions", (editableOptions) ->
  editableOptions.theme = "bs3"
  return
]
app.factory "Task", ["$resource" , ($resource) ->
  $resource("/tasks/:id.json", {id: "@id"}, {update: {method: "PUT"}, query:  {method: 'GET', isArray: true}})

]

app.factory "SubTask", ["$resource" , ($resource) ->
  $resource("/tasks/:task_id/sub_tasks/:id.json", {id: "@id", task_id: "@task_id"}, {update: {method: "PUT"}, query:  {method: 'GET', isArray: true}})

]

app.factory "Bug", ["$resource", ($resource) ->
  $resource("/bugs/:id.json", {id: @id}, {update: {method: "PUT"}, query: {method: 'GET', isArray: true}})

]

app.controller('ModalInstanceCtrl',["$scope", "$filter", "Task", "$modal" , 'task', '$modalInstance', "SubTask",  ($scope, $filter, Task, $modal, task, $modalInstance, SubTask) ->
  orderBy = $filter('orderBy');
  
  $scope.today = ->
    date = new Date()
    return date.getDay() + "/" + (date.getMonth() + 1) + "/" + date.getFullYear()

  $scope.task = task
  $scope.subTask = new SubTask({task_id: $scope.task.id, completed: false, due_date: $scope.today() });

  $scope.close = ->    
    $modalInstance.dismiss('cancel')

  $scope.removeSubTask = (subTask) ->
    $scope.task.sub_tasks.splice( $scope.task.sub_tasks.indexOf(subTask), 1 )
    subTask = new SubTask(subTask);
    subTask.$delete()
    
  $scope.toggleCompleted = (subTask) ->
    subTask.completed = ! subTask.completed
    subTask = new SubTask(subTask);
    subTask.$update()


  $scope.saveSubTask = ->
    $scope.subTask.$save()
    unless $scope.task.sub_tasks?
      $scope.task.sub_tasks = []
    $scope.task.sub_tasks.push($scope.subTask)
    $scope.task.sub_tasks = orderBy($scope.task.sub_tasks, 'sort_order', true)
    $scope.subTask = new SubTask({task_id: $scope.task.id, completed: false, due_date: $scope.today()})

  $scope.checkBody = (data) ->
    if data.length < 1 || data.length > 254
      "Task can't be blank!"

  $scope.updateSubTask = (subTask) ->
    subTask = new SubTask(subTask)
    subTask.$update()
])

app.controller('TaskCtrl',["$scope", "$filter", "Task", "$modal" ,  ($scope, $filter, Task, $modal) ->
  $scope.tasks = Task.query()
  orderBy = $filter('orderBy')

  $scope.addTask = ->
    task = Task.save($scope.newTask)
    $scope.tasks.push(task)
    $scope.tasks = orderBy($scope.tasks, 'sort_order', true)
    $scope.newTask = {}
    
  $scope.removeTask = (task) ->    
    task.$delete()
    $scope.tasks.splice( $scope.tasks.indexOf(task), 1 )
    
  $scope.checkBody = (data) ->
    if data.length < 1 || data.length > 254
      "Task can't be blank!"

  $scope.saveTask = (task) ->
    task.$update()
    
    

  $scope.editModal = (task) ->
    modalInstance = $modal.open(
      templateUrl: 'modal.html',
      controller: 'ModalInstanceCtrl',
      resolve:
        task: ->
          task      
    )
    modalInstance.result.then ((task) ->
    ), ->
      task.$update()
      

])

app.controller('BugController',["$scope", "$filter", "Bug", "$modal" ,  ($scope, $filter, Bug, $modal) ->
  $scope.bugs = Bug.query()
  orderBy = $filter('orderBy')

  $scope.newBug = ->
    $scope.bug = { priority: "HIGH" }

  $scope.addBug = ->
    bug = Bug.save($scope.bug)
    $scope.bugs.push(bug)
    $scope.bug = {}
])