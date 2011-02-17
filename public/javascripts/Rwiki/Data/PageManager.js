Ext.ns('Rwiki.Data');

Rwiki.Data.PageManager = Ext.extend(Ext.util.Observable, {
  constructor: function() {
    if (Rwiki.Data.PageManager.caller != Rwiki.Data.PageManager.getInstance) {
      throw new Error("There is no public constructor for Rwiki.Data.PageManager");
    }

    this.timeout = 10000;

    this.initEvents();
//    Ext.Ajax.on('requestexception', this.onAjaxException);
  },

  onAjaxException: function() {
    alert('Something went wrong...');
  },

  initEvents: function() {
    this.addEvents(
      'rwiki:beforePageLoad',
      'rwiki:pageLoaded',
      'rwiki:pageDeleted',
      'rwiki:pageCreated',
      'rwiki:pageSaved',
      'rwiki:pageRenamed',
      'rwiki:lastPageClosed'
    );
  },

  loadPage: function(path) {
    var page = new Rwiki.Data.Page({ path: path });
    this.fireEvent('rwiki:beforePageLoad', page);

    Ext.Ajax.request({
      url: '/node',
      method: 'GET',
      params: { path: path },
      scope: this,
      timeout: this.timeout,
      success: function(response) {
        var data = Ext.decode(response.responseText);
        var page = new Rwiki.Data.Page(data);
        this.fireEvent('rwiki:pageLoaded', page);
      }
    });
  },

  createPage: function(parentPath, name) {
    Ext.Ajax.request({
      url: '/node',
      type: 'POST',
      params: {
        parentPath: parentPath,
        name: name
      },
      scope: this,
      timeout: this.timeout,
      success: function(response) {
        var data = Ext.decode(response.responseText);
        var node = new Rwiki.Data.Page(data);

        this.fireEvent('rwiki:pageCreated', node);
      }
    });
  },

  savePage: function(path, rawContent) {
    Ext.Ajax.request({
      url: '/node',
      method: 'PUT',
      params: {
        path: path,
        rawContent: rawContent
      },
      scope: this,
      timeout: this.timeout,
      success: function(response) {
        var data = Ext.decode(response.responseText);
        var page = new Rwiki.Data.Page(data);
        this.fireEvent('rwiki:pageSaved', page);
      }
    });
  },

  renameNode: function(oldPath, newName) {
    Ext.Ajax.request({
      url: '/node/rename',
      method: 'POST',
      params: {
        path: oldPath,
        newName: newName
      },
      scope: this,
      timeout: this.timeout,
      success: function(response) {
        var data = Ext.decode(response.responseText);
        var page = new Rwiki.Data.Page(data);
        this.fireEvent('rwiki:pageRenamed', page);
      }
    });
  },

  deleteNode: function(path) {
    Ext.Ajax.request({
      url: '/node',
      method: 'DELETE',
      params: { path: path },
      scope: this,
      timeout: this.timeout,
      success: function(response) {
        var data = Ext.decode(response.responseText);
        this.fireEvent('rwiki:pageDeleted', data);
      }
    });
  },

  moveNode: function(path, newParentPath) {
    var self = this;
    var result = $.ajax({
      type: 'PUT',
      url: '/node/move',
      dataType: 'json',
      async: false,
      data: {
        path: path,
        newParentPath: newParentPath
      },
      timeout: this.timeout,
      success: function(data) {
        var page = new Rwiki.Data.Page(data);
        self.fireEvent('rwiki:pageRenamed', page);
      }
    });

    return Ext.util.JSON.decode(result.responseText);
  },

  isParent: function(parentPath, path) {
    var parentParts = parentPath.split('/');
    var pathParts = path.split('/');

    var result = true;
    var n = Math.min(parentParts.length, pathParts.length);
    for (var i = 0; i < n; i++) {
      if (parentParts[i] != pathParts[i]) {
        result = false;
        break;
      }
    }

    return result;
  }
});

Rwiki.Data.PageManager._instance = null;

Rwiki.Data.PageManager.getInstance = function() {
  if (this._instance == null) {
    this._instance = new Rwiki.Data.PageManager();
  }

  return this._instance;
};