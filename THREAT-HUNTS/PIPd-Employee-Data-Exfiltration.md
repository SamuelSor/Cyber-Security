## THREAT HUNT: PIPd Employee Data Exfiltration

An employee was recently placed on a performance improvement plan and reportedly threw a fit. Management placed a flag on him because they believe he may try to exfilitrate proprietary company data before quitting.
Upon inspecting the DeviceFileEvents table, there was some suspicious activity coming from the employee's computer, under his account.

    DeviceFileEvents  
    |where DeviceName == "samtargetmachin"  
    |where InitiatingProcessAccountName == "samtarget"  
    |where FileName has_any ("7z", "zip")  
    |order by TimeGenerated desc  
    |project TimeGenerated, ActionType, FileName, FolderPath, InitiatingProcessFileName

<img width="1459" height="331" alt="Screenshot 2026-05-09 125711" src="https://github.com/user-attachments/assets/e5b668ce-b0e3-4d2c-99dc-a3e50be53e8c" />

Following the trail of compressed files, the employee seems to have deployed a malicious PowerShell script to exfiltrate data.

    DeviceProcessEvents  
    |where DeviceName == "samtargetmachin"  
    |where InitiatingProcessAccountName == "samtarget"  
    |where ProcessCommandLine has_any ("7z", ".ps1", "powershell")  
    |order by TimeGenerated desc  
    |project TimeGenerated, ActionType, FileName, ProcessCommandLine

<img width="1263" height="165" alt="Screenshot 2026-05-09 125826" src="https://github.com/user-attachments/assets/29e2d8a9-4f49-45ce-aec7-24442096103c" />

