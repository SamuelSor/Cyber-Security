**THREAT HUNT: Suddent Network Slowdowns**

    DeviceNetworkEvents  
    |where ActionType == "ConnectionFailed"  
    |summarize failedConnections = count() by DeviceName, ActionType, LocalIP  
    |order by failedConnections  

Device: samTargetMachine
