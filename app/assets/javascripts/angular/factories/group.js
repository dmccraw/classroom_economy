app.factory("Group", ['$resource',
  function($resource) {
    function Group() {
      this.service = $resource("/v1/groups/:groupId", {
        groupId: "@id"
      });
    }

    Group.prototype.all = function() {
      return this.service.query();
    };

    Group.prototype.delete = function(groupId) {
      this.service.remove({
        groupId: groupId
      });
    };

    return new Group;
  }
]);