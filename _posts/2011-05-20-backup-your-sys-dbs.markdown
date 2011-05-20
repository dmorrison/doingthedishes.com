---
layout: post
title: Please, Please Back Up Your System Databases
---

I'm just recovering from a two-day bender of re-building our production SQL Server install at work. In hindsight (of course), it seems obvious what I should have done to prevent this, and at least I learned a couple things from this freak accident.

The cause doesn't even sound that glamorous: I installed service pack 2 for SQL Server 2008. The service pack said it installed correctly, and I rebooted the machine as instructed. When I tried to connect to the server afterwards, though, I got the following error:

>Server is in script upgrade mode. Only administrator can connect at this time.

Looking in the event viewer for more details, I saw this bone-chilling message:

>Script level upgrade for database 'master' failed because upgrade step 'sqlagent100_msdb_upgrade.sql' encountered error 3602, state 126, severity 25. This is a serious error condition which might interfere with regular operation and the database will be taken offline.

...followed by:

>Cannot recover the master database. SQL Server is unable to run. Restore master from a full backup, repair it, or rebuild it.

Ouch. After seeing this and further googling and tinkering, my heart sank, and I realized we were in for an all-nighter. We couldn't manage to restore or access the master database.

 The system databases in SQL Server store a bunch of metadata including login and security information, db mail settings, jobs, and (in our case) replication settings. So, while we had regular backups of our user databases being done, we had neglected to backup the system databaess and hadn't thought through the process of rebuilding our server.

The part that really stings is that we later just added a few lines (a few measly lines!!!) to the backup script to include the system databases. But, lesson learned, and plus we got to go through an instructive (though painful) process of going through and revising our disaster recovery process.

Bottom line, please, please backup your system databases, and the next time I do a service pack install or other serious upgrade, I'm going to be sure to take a full backup of all user as well as system databases so that I can not only restore our data, but also our configuration.