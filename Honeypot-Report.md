# MySQL Database Ransomware Incident Report

## Executive Summary

On **July 19, 2026**, a threat actor successfully compromised the MySQL server **corp-db01-int01** by remotely authenticating as the **root** user from the external IP address **64.89.163.178**. Within approximately two minutes, the attacker enumerated the database schema, removed foreign key constraints, deleted multiple database tables, and deployed a ransom note demanding payment in exchange for the alleged recovery of the data. To hinder recovery efforts, the attacker executed `RESET MASTER` and `PURGE BINARY LOGS` to remove MySQL binary logs, revoked administrative privileges from the remote root account, and issued a `SHUTDOWN` command to stop the database service. The rapid sequence and consistency of the commands strongly indicate the attack was performed using an automated ransomware script.

---

# Incident Details

| Item | Value |
|------|-------|
| **Affected System** | corp-db01-int01 |
| **Affected Service** | MySQL Database |
| **Severity** | Critical |
| **Attack Classification** | Database Ransomware |
| **Attack Duration** | ~2 Minutes |
| **Activity Window** | 2026-07-19T02:10:29.638707Z – 2026-07-19T02:12:07.816657Z |
| **Malicious IP** | 64.89.163.178 |
| **Organization** | Meowcore Softworks LLC |
| **Location** | Frankfurt am Main, Hessen, Germany |

---

# Summary of Events

The investigation determined that the attacker remotely accessed the MySQL service over TCP port 3306 using the **root** account. After establishing access, the attacker configured the session, enumerated the database schema through `INFORMATION_SCHEMA`, and removed foreign key constraints to facilitate deletion of database tables. Multiple tables containing sensitive information were dropped, after which the attacker created a `RECOVER_YOUR_DATA` table containing a ransomware note demanding Bitcoin payment. The attacker then attempted to prevent recovery by deleting MySQL binary logs, revoking administrative privileges from the remote root account, and shutting down the MySQL service.

---

# Timeline of Events

| Time (UTC) | Event | Description |
|------------|-------|-------------|
| **2026-07-18T14:58:01Z** | Failed Authentication | Failed MySQL root login observed from **64.89.163.148**. |
| **2026-07-19T02:10:12.599Z** | Network Connection | External IP **64.89.163.178** connected directly to MySQL over TCP port 3306. |
| **2026-07-19T02:10:29.638Z** | Initial Access | Successful MySQL authentication as `root@64.89.163.178`. |
| **2026-07-19T02:10:30.675Z** | Session Initialization | SQL mode set to permissive behavior (`SET @@SQL_MODE=''`). |
| **2026-07-19T02:10:36Z** | Database Enumeration | Queried `INFORMATION_SCHEMA` to enumerate tables, tablespaces, and storage metadata. |
| **2026-07-19T02:10:41.651Z** | Foreign Key Removal | Removed foreign key constraint from the `credentials` table. |
| **2026-07-19T02:10:42.182Z** | Data Destruction | Deleted the `credentials` table along with multiple additional tables. |
| **2026-07-19T02:10:42.422Z** | Ransom Note | Inserted ransom instructions into the `RECOVER_YOUR_DATA` table. |
| **2026-07-19T02:12:06.200Z** | Recovery Inhibition | Executed `RESET MASTER` to remove binary log history. |
| **2026-07-19T02:12:06.825Z** | Recovery Inhibition | Executed `PURGE BINARY LOGS` to delete remaining binary logs. |
| **2026-07-19T02:12:07.323Z** | Privilege Modification | Revoked `INSERT`, `UPDATE`, `DELETE`, `DROP`, and `CREATE` privileges from `root@'%'`. |
| **2026-07-19T02:12:07.817Z** | Service Shutdown | Executed MySQL `SHUTDOWN` command. |

---

# Technical Findings

## Initial Access

The attacker authenticated remotely using the MySQL **root** account.

```sql
2026-07-19T02:10:29.638707Z    74 Connect    root@64.89.163.178 on using TCP/IP
```

---

## Database Enumeration

The attacker queried several `INFORMATION_SCHEMA` tables to identify the physical layout and structure of the database before modifying it.

Examples included:

- `INFORMATION_SCHEMA.FILES`
- `INFORMATION_SCHEMA.PARTITIONS`

This activity is consistent with reconnaissance performed prior to destructive database operations.

---

## Data Destruction

To facilitate deletion of protected tables, the attacker removed foreign key constraints before issuing `DROP TABLE` commands.

Example:

```sql
ALTER TABLE credentials DROP FOREIGN KEY credentials_ibfk_1;
DROP TABLE credentials;
```

Multiple additional tables were also deleted, including the default **Sakila** sample database.

---

## Ransom Note Deployment

The attacker created a ransom table and inserted the following message:

```sql
INSERT INTO RECOVER_YOUR_DATA (text)
VALUES (
'All your data was backed up by us. You must pay 0.0131 bitcoin...
');
```

The note instructed the victim to submit Bitcoin payment in exchange for recovery of the allegedly backed-up data.

---

## Recovery Inhibition

The attacker attempted to prevent database recovery by executing:

```sql
RESET MASTER;
```

followed by:

```sql
PURGE BINARY LOGS TO 'josh-mde-lab-bin.000001';
```

These commands remove MySQL binary logs that could otherwise be used for point-in-time recovery and forensic reconstruction.

---

## Privilege Manipulation

The attacker revoked key administrative privileges from the remote root account.

```sql
REVOKE INSERT, UPDATE, DELETE, DROP, CREATE
ON *.*
FROM `root`@'%';
```

This action likely intended to delay administrative recovery efforts.

---

## Service Shutdown

The final command executed during the attack was:

```sql
SHUTDOWN;
```

This terminated the MySQL service, completing the destructive sequence.

---

# Relevant MITRE ATT&CK Techniques

| Tactic | Technique | ID | Evidence |
|--------|-----------|----|----------|
| Initial Access | External Remote Services | T1133 | Direct connection to MySQL over TCP/3306 |
| Persistence / Defense Evasion | Valid Accounts | T1078 | Authentication using the MySQL root account |
| Discovery | Database Discovery | T1046 | Enumeration of `INFORMATION_SCHEMA` metadata |
| Impact | Data Destruction | T1485 | Multiple `DROP TABLE` operations |
| Impact | Inhibit System Recovery | T1490 | `RESET MASTER` and `PURGE BINARY LOGS` |
| Persistence | Account Manipulation | T1098 | `REVOKE` privileges from `root@'%'` |

---

# Indicators of Compromise (IOCs)

## Malicious IP Address

| Indicator | Value |
|----------|-------|
| IP Address | 64.89.163.178 |
| Organization | Meowcore Softworks LLC |
| Location | Frankfurt am Main, Germany |

## Malicious Database Artifacts

- `RECOVER_YOUR_DATA`
- `RESET MASTER`
- `PURGE BINARY LOGS`
- `DROP TABLE`
- `REVOKE`
- `SHUTDOWN`

---

# Assessment

The investigation confirms a successful MySQL ransomware attack against **corp-db01-int01**. After authenticating as the root user, the attacker rapidly enumerated the database, deleted multiple tables, deployed a ransom note, removed recovery artifacts, revoked administrative privileges, and shut down the database service. The entire attack completed within approximately two minutes, strongly indicating the use of an automated ransomware script rather than manual interaction. Due to the execution of `RESET MASTER` and binary log deletion, recovery through MySQL transaction logs is unlikely without external backups or storage snapshots.

---

# Recommendations

1. Remove MySQL from direct Internet exposure.
2. Restrict TCP port **3306** using firewall allowlists or VPN access.
3. Rotate all MySQL credentials, especially privileged accounts.
4. Review MySQL user permissions and remove unnecessary remote administrative access.
5. Restore affected databases from verified backups.
6. Enable centralized logging and long-term retention for MySQL audit logs.
7. Monitor for destructive SQL commands, including:
   - `DROP TABLE`
   - `DROP DATABASE`
   - `RESET MASTER`
   - `PURGE BINARY LOGS`
   - `GRANT`
   - `REVOKE`
   - `SHUTDOWN`
8. Investigate additional systems for credential reuse or signs of lateral movement.

---

# Final Assessment

**Confirmed MySQL ransomware attack resulting in database destruction, deployment of a ransom note, removal of recovery artifacts, administrative privilege modification, and service shutdown.**
