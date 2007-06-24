function popup_login_redbox(a) {
  new Ajax.Updater(
    'hidden_redbox_content',
    '/login?url=' + escape(a.href),
    {
      method:'get',
      asynchronous:true,
      evalScripts:true,
      onComplete:function(request) { RedBox.addHiddenContent('hidden_redbox_content'); },
      onLoading:function(request) {RedBox.loading(); }
    }
  );
  return false;
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
  $$('fieldset.tabbed').each(function(fs) {
    if (fs.id == id) {
      Element.show(fs);      
    } else {
      Element.hide(fs);
    }
  });
}
