## THREAT HUNT: Suddent Network Slowdowns

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

I pivoted to the DeviceProcessEvent table to see if I could see anything that was suspicious around the time the port scan started. 
I noticed a PowerShell script named portscan.ps1 launching at 2026-05-08T21:18:02.1769434Z.

    let VM = "samtargetmachin";  
    let specificTime = datetime(2026-05-08T21:18:13.4416262Z);  
    DeviceProcessEvents  
    |where Timestamp between ((specificTime - 10m) .. (specificTime + 10m))  
    |where DeviceName == VM  
    |order by Timestamp asc   
    |project Timestamp, FileName, InitiatingProcessCommandLine  

<img width="591" height="250" alt="Screenshot 2026-05-09 102221" src="https://github.com/user-attachments/assets/2ec066e2-7ea3-4646-bad9-a7ff1f6bba0c" />

I logged into the suspected computer and observed the Powershell script that was used to conduct the port scan.

<img width="1256" height="445" alt="image" src="https://github.com/user-attachments/assets/0b099ea2-900e-4c7c-a3a3-5ff99d32bbce" />

I observed the port scan script and found that it was launched by the local admin account, samtarget. This was not a planned event, so I isolated the device and ran a malware scan.

**Relevant MITRE ATT&CK TTPs**  

    T1046: Network Service Scanning
    T1059.001: Command and Scripting Interpreter
    TA0004: Priviledge Escalation
    T1049: System Network Connections Discovery
    
*Continued remediation is required*
