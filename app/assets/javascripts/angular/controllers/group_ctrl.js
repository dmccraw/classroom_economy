// angular.module('controllerAsExample', [])
//   .controller('SettingsController1', SettingsController1);
angular.module('controllerExample', [])
  .controller('GroupsController', ['$scope', "Group", '$resource', GroupsController]);


function GroupsController($scope, Group, $resource) {
  this.groups = Group.all();
  this.Group = Group;
  // $scope.groups = Group.all();

  // $scope.deleteGroup = function(id, idx) {
  //   debugger
  //   $scope.groups.splice(idx, 1);
  //   return Group.delete(id);
  // };
}

GroupsController.prototype.deleteGroup = function(id, idx) {
  this.groups.splice(idx, 1);
  return this.Group.delete(id);
};

// app.controller('GroupsController', ['$scope', "Group", '$resource',
//   function($scope, Group, $resource) {
//     $scope.groups = Group.all();

//     $scope.deleteGroup = function(id, idx) {
//       debugger
//       $scope.groups.splice(idx, 1);
//       return Group.delete(id);
//     };
//   }
// ]);



// // SettingsController1.prototype.greet = function() {
// //   alert(this.name);
// // };