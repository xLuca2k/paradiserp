function convertTZ(date, tzString) {
    return new Date((typeof date === "string" ? new Date(date) : date).toLocaleString("en-US", {timeZone: tzString}));   
}

window.addEventListener("message",function(evt){ 
    var data = evt.data;

    switch(data["event"]){
        case "sendAdminAnnouncment":
            switch(data["sendAdminAnnouncment"]){
                case "DA":
                    this["document"]["getElementById"]("adminAnnouncementContainer")["style"]["display"] = "block";
                    this["document"]["getElementById"]("admAnnName")["innerHTML"] = data["admAnnName"];
                    this["document"]["getElementById"]("admAnnId")["innerHTML"] = data["admAnnId"];
                    this["document"]["getElementById"]("admAnnMessage")["innerHTML"] = data["admAnnMessage"];
                    this["setTimeout"](function(){
                        $("#adminAnnouncementContainer")["fadeOut"](1500);
                    }, 10000);
                break
            }
        break

        case "sendEventAnnouncement":
            switch(data["sendEventAnnouncement"]){
                case "DA":
                    this["document"]["getElementById"]("eventAnnouncementContainer")["style"]["display"] = "block";
                    this["document"]["getElementById"]("evtAnnName")["innerHTML"] = data["evtAnnName"];
                    this["document"]["getElementById"]("evtAnnId")["innerHTML"] = data["evtAnnId"];
                    this["document"]["getElementById"]("evtAnnMessage")["innerHTML"] = data["evtAnnMessage"];
                    this["setTimeout"](function(){
                        $("#eventAnnouncementContainer")["fadeOut"](1500);
                    }, 10000);
                break
            }
        break

        case "announcement":
            switch(data["announcement"]){
                case "DA":
                    this["document"]["getElementById"]("announcement")["style"]["display"] = "block";
                    this["document"]["getElementById"]("annSenderphone")["innerHTML"] = data["annSenderphone"];
                    this["document"]["getElementById"]("annMessage")["innerHTML"] = data["annMessage"];
                    this["setTimeout"](function(){
                        $("#announcement")["fadeOut"](1500);
                    }, 10000);
                break
            }
        break

        case "updateHud":
            switch(data["updateHud"]){
                case "DA":
                    var element = document.getElementById(data["cemodifica"]);
if (element) {
    element.innerHTML = data["valoare"];
}

                break
            }
        break
    }
});