document.observe("dom:loaded", function() {  
  Event.addBehavior({
    '.popup .close:click' : function(e) { Element.closePopup($(this)); }
  });
});

document.observe("dom:loaded", function() {
  page_images = new PageImages();
  page_images.initialize();
  
  Event.addBehavior({
    '#attachment_form:submit'           : function(e) { page_images.imageSubmit() },
    '#browse_images_popup .image:click' : function(e) { page_images.imageAttach($(this)) },
    '#attachments .delete:click'        : function(e) { page_images.imageRemove($(this).up('.attachment')) },
  });
});

var PageImages = Class.create({
  
  initialize: function() {
    this.imagesSort();
  },
  
  imagesSort: function() {
    var route = '/admin/attachments/sort'
    
    Sortable.create('attachments', {
      constraint: false, 
      overlap: 'horizontal',
      containment: ['attachments'],
      onUpdate: function(element) {
        new Ajax.Request(route, {
          method: 'put',
          parameters: {
            'page_id'     : $('page_id').value,
            'attachments' : Sortable.serialize('attachments')
          }
        });
      }.bind(this)
    })
  },
  
  imageAttach: function(element) {
    var route = '/admin/attachments'
    
    showStatus('Adding Image...');
    element.hide();
    
    new Ajax.Request(route, {
      method: 'post',
      parameters: {
        'attachment[page_id]'  : $('page_id').value,
        'attachment[image_id]' : element.readAttribute('data-image_id')
      },
      onSuccess: function(data) {
        $('attachments').insert({ 'bottom' : data.responseText});
        shop_product_edit.imagesSort();
        element.remove();
      }.bind(element),
      onFailure: function() {
        element.show();
      },
      onComplete: function() {
        hideStatus();        
      }
    });
  },
  
  imageRemove: function(element) {
    var attachment_id = element.readAttribute('data-attachment_id');
    var route         = '/admin/attachments/' + attachment_id;
    
    showStatus('Removing Image...');
    element.hide();
    
    new Ajax.Request(route, { 
      method: 'delete',
      parameters: {
        'image_id' : element.readAttribute('data-image_id')
      },
      onSuccess: function(data) {
        $('images').insert({ 'bottom' : data.responseText })
        element.remove();
      }.bind(element),
      onFailure: function(data) {
        element.show();
      }.bind(element),
      onComplete: function() {
        hideStatus();        
      }
    });
  },
  
  imageSubmit: function() {
    showStatus('Uploading Image...');
  }
  
});