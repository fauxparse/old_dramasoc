function popup_login_redbox(a) {
  open_redbox('/login?url=' + escape(a.href));
  return false;
}

function open_redbox(url, options) {
  default_options = $H({
    method:'get',
    asynchronous:true,
    evalScripts:true,
    onComplete:function(request) { RedBox.addHiddenContent('hidden_redbox_content'); },
    onLoading:function(request) {RedBox.loading(); }
  });
  options = options ? default_options.merge(options) : default_options;
  new Ajax.Updater('hidden_redbox_content', url, options);
}

function activate_tab(tab_name) {
  id = 'form_tab_' + tab_name;
  $$('.fieldset-tabs li').each(function(fs) {
    if (fs.id == id) {
      fs.addClassName('active');      
    } else {
      fs.removeClassName('active');      
    }
  });

  id = 'fields_' + tab_name;
  $$('.tabbed').each(function(fs) {
    if (fs.id == id) {
      Element.show(fs);      
    } else {
      Element.hide(fs);
    }
  });
}

function marker_clicked(marker) {
  id = marker.name;
  b = $('show_venue_id');
  for (i = 0; i < b.options.length; i++) {
    if (b.options[i].value == id) {
      b.selectedIndex = i;
      break;
    }
  }
}

function marker_dragged(marker) {
  marker_clicked(marker);
  point = marker.getPoint();
  new Ajax.Updater('hidden_redbox_content', '/venues/' + marker.name + '.js', {
    method:'put',
    asynchronous:true,
    evalScripts:true,
    parameters:{ latitude:point.lat(), longitude:point.lng() }
  });
}

function point_clicked(point) {
  open_redbox('/venues/new', { parameters:{ latitude:point.lat(), longitude:point.lng() } });
}

function new_role(show_id, type, role, name) {
  params = 'role[type]=' + type + '&role[name]=' + name + '&role[role]=' + role;
  new Ajax.Request('/shows/' + show_id + '/roles', {
    method:'post',
    asynchronous:true,
    evalScripts:true,
    parameters:params
  });
  if (type == '') {
    type = 'acting_role';
  } else {
    type = type.replace(/Role$/, '_role').toLowerCase();
  }
  $(type + '_role').value = '';
  $(type + '_name').value = '';
  $(type + '_role').focus();
}

function redbox_visible() {
  rb = $('RB_window');
  return (rb != null) && ((rb.getOpacity() || 0.0) > 0.0);
}

Event.observe(document, 'keypress', function(e){
  var key_code = e.keyCode || e.which;
  
  if (key_code == Event.KEY_ESC && redbox_visible()){
    RedBox.close();
  }
}, false);