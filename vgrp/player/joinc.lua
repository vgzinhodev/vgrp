local firstDownload = false
addEventHandler("onClientTransferBoxVisibilityChange", root, function(visivel)
    if not visivel and not firstDownload then 
        triggerServerEvent("vgrp:PlayerJoin", localPlayer)
        firstDownload = true
    end
end)