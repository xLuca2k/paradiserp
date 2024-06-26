$(document).ready(function(){
  window.addEventListener('message', function(event) {
      var node = document.createElement('textarea');
      if (event.data.act == 'clipboard'){ 
        var selection = document.getSelection();
        node.textContent = event.data.text;
        document.body.appendChild(node);
  
        selection.removeAllRanges();
        node.select();
        document.execCommand('copy');
  
        selection.removeAllRanges();
        document.body.removeChild(node);
      }
  });
});
