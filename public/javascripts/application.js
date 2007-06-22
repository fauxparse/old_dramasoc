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
