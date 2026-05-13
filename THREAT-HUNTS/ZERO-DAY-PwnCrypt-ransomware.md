## THREAT HUNT: ZERO DAY PwnCrypt Ransomware

Following the outbreak of a zero day called PwnCrypt, the CISO is concerned about the ransomware making in onto the company's corporate network. A clear indicator of compromise (IoCs) for this zero day are ".pwncrypt." files.

##

To begin checking the network for the zero day I will be using Microsoft Defender to query DeviceFileEvents table for any files containing ".pwncrypt.". It was apparent that the ransomware had made it onto the network.

    DeviceFileEvents  
    |where FileName contains "pwncrypt"


<img width="1241" height="523" alt="Screenshot 2026-05-13 120836" src="https://github.com/user-attachments/assets/f0dd9860-ad54-43c8-ae94-6f9c376a3643" />

Looking closer at the DeviceFileEvents logs for a specific machine, shows that the ransomware was deployed from a PowerShell script called pwncrypt.ps1. 

    DeviceFileEvents  
    |where FileName contains "pwncrypt"  
    |where DeviceName contains "samtargetmachin"  
    |project Timestamp, ActionType, FileName, InitiatingProcessCommandLine

<img width="1169" height="272" alt="Screenshot 2026-05-13 122204" src="https://github.com/user-attachments/assets/84af95ba-6b8b-4094-8234-f5254226aa7b" />

I then looked at the DeviceProcessEvents table for processes initiated around the time ransomware files were created to see what may have initiated the PowerShell script. It seems the script was deployed by an 
internal account and also initated a command line script.

    let specificTime = datetime(2026-05-13T15:55:35.1057977Z);
    DeviceProcessEvents
    |where DeviceName == "samtargetmachin"
    |where Timestamp  between ((specificTime - 2m) .. (specificTime + 2m))
    |where ProcessCommandLine contains "pwncrypt"
    |sort by Timestamp desc
    |project Timestamp, ActionType, AccountName, FileName, ProcessCommandLine

<img width="1300" height="107" alt="Screenshot 2026-05-13 134814" src="https://github.com/user-attachments/assets/cb912af1-91aa-4918-915b-6d6d07de789f" />


**Relevant MITRE ATT&CK TTPs**

    T1190: Zero-day exploit  
    T1078: Initial Access with valid credentials  
    T1059.001: Malicious PowerShell script execution  
    T1057: Obfuscated files or information
    T1486: Data encrypted for impact
    
