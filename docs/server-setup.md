This is a learning project regarding working with Amazon Linux 2023 and configuring a simulated 
Linux server.

The server got 4 groups: 
- engineering
- marketing
- operations
- admins

All groups got in total up to 4 users. 2 Users are in 2 groups (operations nad admins).
There is a total of 12 users with permissions configured.
Folders have adjusted permissions based on groups.

drwxrwxr-x. root admins       /logs/reports
drwxrwxr-x. root admins       /shared/company-docs
drwxrwx---. root engineering  /shared/engineering
drwxrwx---. root marketing    /shared/marketing
drwxrwx---. root operations   /shared/operations

Other comments: