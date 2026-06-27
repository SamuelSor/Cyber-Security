# THREAT HUNT REPORT- Second Vector 📨

## Platforms and Languages Leveraged
  - **Kusto Query Language (KQL)**
  - **Microsoft Sentinel** (Law-Cyber-Range)
  - **Microsoft Defender XDR**

## Scenario
`Timeframe: 2026-06-11 03:00 UTC → 2026-06-11 13:00 UTC`
`Incident ID 87241: Anonymous IP address involving one user`
`Company: Lognpacific`  

Microsoft Entra ID Protection raised an incident against a finance user's account overnight. The account was accessed by an anonymous IP address, flagged on the account `m.smith` and rated **Low**. The rating may not be accurate and needs further investigation to verify the status of the machine and account. 


## Steps Taken

### 1. Review the Incident on XDR

<img width="740" height="460" alt="Incident-87241-XDR" src="https://github.com/user-attachments/assets/ecc43f99-4d35-497a-88f3-143c9a35499a" />

The incident shows an anonymous IP (`103.69.224.136`) coming form Amsterdam that is registered under `Proton`, a trustworthy vendor that is often used for VPNs. It also inicated that the activity began at `11:13:10 on Jun 10th`.

### 2. Review the AADUserRiskEvents Table on Sentinel  

The first step is to verify if this incident was the only event logged for this user. Looking into the AADUserRiskEvents Table will display any other events that may not have triggered alerts.

<img width="967" height="510" alt="AADUserRiskEvents" src="https://github.com/user-attachments/assets/23763fdd-80f4-456b-b7a6-ea252714a2cb" />  


This incident was not an isolated event, there were six total events from the same IP address, all but one were labeled `dismissed`. Looking back toward the initial ticket, the account is still active, which means the operator did not trigger any rules to diable the account.


KQL:



    AADUserRiskEvents  
    | where TimeGenerated between (datetime(2026-06-11 03:00:00) .. datetime(2026-06-11 13:00:00))  
    | where UserPrincipalName has "m.smith"  
    | project TimeGenerated, UserPrincipalName, RiskEventType, RiskLevel, RiskState, IpAddress  
    | order by TimeGenerated asc  

### 3. Pivot to SigninLogs
Looking into =


### Summary of findings



### Response Taken



### Flags
