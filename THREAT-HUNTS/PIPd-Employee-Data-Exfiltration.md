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


<img width="1257" height="298" alt="image" src="https://github.com/user-attachments/assets/84c8577a-2220-4ce8-bc33-d79d976d9ded" />
