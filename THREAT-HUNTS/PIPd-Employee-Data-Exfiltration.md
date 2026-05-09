## THREAT HUNT: PIP'd Employee Data Exfiltration

An employee was recently placed on a performance improvement plan and reportedly threw a fit. Management placed a flag on him because they believe he may try to exfilitrate proprietary company data before quitting.
Upon inspecting the DeviceFileEvents table with MDE, there was some suspicious activity coming from the employee's computer, under his account involving zip files.


    DeviceFileEvents  
    |where DeviceName == "samtargetmachin"  
    |where InitiatingProcessAccountName == "samtarget"  
    |where FileName has_any ("7z", "zip")  
    |order by TimeGenerated desc  
    |project TimeGenerated, ActionType, FileName, FolderPath, InitiatingProcessFileName


<img width="1459" height="331" alt="Screenshot 2026-05-09 125711" src="https://github.com/user-attachments/assets/e5b668ce-b0e3-4d2c-99dc-a3e50be53e8c" />


Following the trail of compressed files, I took the timestamp of one of the suspicious zip files being created and searched under DeviceProcessEvents for anything happening 2 minutes before and after the archive was created. I discovered two related events occuring around that time: a PowerShell script silently installing 7-Zip and using 7-Zip being used to zip up employee data into an archive.


    let specificTime = datetime(2026-05-09T16:15:58.2556091Z);  
    DeviceProcessEvents  
    |where DeviceName == "samtargetmachin"  
    |where Timestamp between ((specificTime - 2m) .. (specificTime + 2m))  
    |where InitiatingProcessAccountName == "samtarget"  
    |order by TimeGenerated desc  
    |project TimeGenerated, ActionType, FileName, FolderPath, ProcessCommandLine  

<img width="1478" height="305" alt="Screenshot 2026-05-09 131719" src="https://github.com/user-attachments/assets/68cda588-e8b2-49d6-87ec-be7e67d24be4" />

After finding that the data was being put into an archive, I wanted to check to see if the employee was exfiltrating this data beyond the network. I looked at the DeviceNetworkEvents table filtered events occuring around the same time as the initial file zip. I found that the same PowerShell script was again in use, but this time it was being used to connect to an unknown IP on the internet. This is clear evidence that this employee did exfiltrate confidential employee information from the company's network.

    let specficTime = datetime(2026-05-09T16:15:58.2556091Z);  
    DeviceNetworkEvents  
    |where DeviceName == "samtargetmachin"  
    |where Timestamp between ((specficTime - 2m) .. (specficTime + 2m))  
    |project Timestamp, ActionType, RemoteIP,  RemoteUrl, LocalPort, InitiatingProcessCommandLine  

<img width="1490" height="334" alt="Screenshot 2026-05-09 134137" src="https://github.com/user-attachments/assets/bedebb78-de0a-42a0-869f-dd5704c484db" />

*This information was relayed to the employee's manager, and the situation was escalated from there.*
