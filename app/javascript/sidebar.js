function filterBranches() {
  var input = document.getElementById('branchSearchInput');
  var filter = input.value.toLowerCase();
  
  var branchItems = document.getElementsByClassName('branch-item');
  
  for (var i = 0; i < branchItems.length; i++) {
    var link = branchItems[i].getElementsByTagName("a")[0];
    var txtValue = link.textContent || link.innerText;
    
    if (txtValue.toLowerCase().indexOf(filter) > -1) {
      branchItems[i].style.display = "";
    } else {
      branchItems[i].style.display = "none";
    }
  }
}
