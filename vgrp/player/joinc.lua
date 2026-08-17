local firstDownload = false
addEventHandler("onClientTransferBoxVisibilityChange", root, function(visivel)
    if not visivel and not firstDownload then 
        iprint("Trigando a primeira vezz")
        triggerServerEvent("vgrp:PlayerJoin", localPlayer)
        firstDownload = true
    end
end)