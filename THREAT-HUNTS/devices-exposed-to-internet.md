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

Of all the remote IPs discovered to fail or attempt a login only one IP was successful in logging in.

    let SuspiciousRemoteIPs = dynamic(["45.92.176.166", "95.143.190.123", "188.68.217.132", "95.143.190.130", "185.151.241.134", "95.213.184.95", "212.41.9.236", "45.142.193.145", "96.255.84.17"]);  
    DeviceLogonEvents  
    |where ActionType == "LogonSuccess"  
    |where RemoteIP has_any (SuspiciousRemoteIPs)  

<img width="560" height="114" alt="image" src="https://github.com/user-attachments/assets/c4c9e89f-688b-4051-8a90-fd4a9a432185" />

After further investigation this successful login was confirmed to be from an authorized user that successfully logged in 3 times.


