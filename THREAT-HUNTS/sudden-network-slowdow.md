**THREAT HUNT: Suddent Network Slowdowns**

samTargetMachine was found failing serveral connection request against itself and other host on the same network:

    DeviceNetworkEvents  
    |where ActionType == "ConnectionFailed"  
    |summarize failedConnections = count() by DeviceName, ActionType, LocalIP  
    |order by failedConnections  


<img width="632" height="164" alt="Screenshot 2026-05-09 091522" src="https://github.com/user-attachments/assets/f0464bb4-e345-4208-9d44-48eb7a0b7b2d" />

Further investigation of the failed connections, in chronological order, to the suspected host(10.3.0.45) show signs of a port scanner taking place. This is evident in the sequential scanning of well known ports. Multiple port scans were being conducted:

    let IP = "10.3.0.45";  
    DeviceNetworkEvents  
    |where ActionType == "ConnectionFailed"  
    |where LocalIP == IP  
    |order by Timestamp desc  

<img width="1119" height="361" alt="Screenshot 2026-05-09 094051" src="https://github.com/user-attachments/assets/3cbe365c-576a-440f-939e-c954f54ba335" />  

Scans began on May 8, 2026 5:17:47 PM EST  

