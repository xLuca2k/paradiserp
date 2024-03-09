var select_status = false
var driver_status = false
var job_status = false
var id_status = false
var dollar_status = false
var show = undefined
var current_job = undefined

$(document).ready(() =>
{
  window.addEventListener("message", (event) => 
  {
    if (event.data.showUI == true)
    {
      $("#all").fadeIn("slow");
    }
    if (event.data.cp)
    {
      $("#iban").text("IBAN: " + event.data.cp)
    }
    if (event.data.bani)
    {
      $("#moneyt").text(event.data.bani);
    }
    if (event.data.per == 1 || event.data.cam == 1 || event.data.mot == 1)
    {
      $("#driver-license").fadeIn();
    }
    if (event.data.per == 0 && event.data.cam == 0 && event.data.mot == 0)
    {
      $("#driver-license").fadeOut();
      $("#categorii").fadeOut();
      $("#permis").fadeOut();
      $("#motor").fadeOut();
      $("#camion").fadeOut();
    }
    if (event.data.per == 1)
    {
      $("#categorii").fadeIn();
      $("#permis").fadeIn();
    }
    if (event.data.cam == 1)
    {
      $("#categorii").fadeIn();
      $("#camion").fadeIn();
    }
    if (event.data.mot == 1)
    {
      $("#categorii").fadeIn();
      $("#motor").fadeIn();
    }
    if (event.data.are >= 1)
    {
      $("#job-license").fadeIn();
    }
    if (event.data.are == 0)
    {
      $("#job-license").fadeOut();
    }
  });
});

window.addEventListener("keyup", (event) => {
  event.preventDefault();
  if (event.key == "Escape") {
    document.getElementById('all').style.display = "none"
      $.post("https://gba_wallet/close", "{}");
  }
})

function slider (v){
  if(select_status == false) {
    if(v == "dollar") {
      document.getElementById('dollar').style.top = "17.2%"
      document.getElementById('dollarflow').style.height = "30%"
    }
    if(v == "dollar_off") {
      document.getElementById('dollar').style.top = "20%"
      document.getElementById('dollarflow').style.height = "20%"
    }
    if (v == "id") {
      document.getElementById('id').style.top = "21.9%"
      document.getElementById('idflow').style.height = "25.98%"
    }
    if (v == "id_off") {
      document.getElementById('id').style.top = "22.9%"
      document.getElementById('idflow').style.height = "20%"
    }
  }
}

function select(v) {
  if(v == "dollar") {
    if(dollar_status == false){
      dollar_status = true
      select_status = true
    document.getElementById('money').style.display = "block"
      document.getElementById('dollar').style.top = "3%"
      document.getElementById('dollarflow').style.height = "73%"
      document.getElementById('dollarflow').style.transition = "0.3s"
    }
    else{
      dollar_status = false
      select_status = false
      document.getElementById('money').style.display = "none"
      document.getElementById('dollarflow').style.transition = "0.4s"
      document.getElementById('dollar').style.top = "20%"
      document.getElementById('dollarflow').style.height = "20%"
    }
  }
  if (v == "id") {
    $.post("http://gba_wallet/show", JSON.stringify({}));
    $("#all").fadeOut()
    document.getElementById('id').style.top = "22.4%"
    document.getElementById('idflow').style.height = "20%"
    select_status = false
  }
}