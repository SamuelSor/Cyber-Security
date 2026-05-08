**THREAT HUNT: Devices exposed to Internet**

*Device Name: samTargetMachine*

This device experience multiple failed log on attempts from a variety of remote IP addresses.

    DeviceLogonEvents  
    |where DeviceName contains "samTarget"  
    |where ActionType == "LogonFailed" or ActionType == "LogonAttempted"  
    |summarize Attempts = count() by RemoteIP, ActionType, DeviceName  
    |order by Attempts

Several bad actors have been discovered attempting to log into the virtual machine

<img width="693" height="365" alt="Screenshot 2026-05-07 212600" src="https://github.com/user-attachments/assets/fb583fde-cd00-4e83-a3ad-e3d0cbc4efd0" />
