# CloudByte Solutions: Linux SysAdmin Project

A Linux system administration project, built first on a local VM
and later deployed to AWS EC2. The scenario is CloudByte Solutions, a
fictional 12-person startup that needs a properly configured multi-user
Linux server: user accounts, group-based file access, automated backups,
log analysis, and system health reporting.

## Section 1: Server Foundations

Built the core of the server: four groups (`engineering`, `marketing`,
`operations`, `admins`), twelve user accounts, and a directory tree under
`/shared` with group-based access control.

### Groups and users

| Group | Members |
|---|---|
| `engineering` | alice, bob, carol, dave |
| `marketing` | emma, frank, grace |
| `operations` | henry, iris, jack, kate, leo |
| `admins` | kate, leo |

### Directory structure

| Path | Group | Mode |
|---|---|---|
| `/shared/engineering` | engineering | `770` |
| `/shared/marketing` | marketing | `770` |
| `/shared/operations` | operations | `770` |
| `/shared/company-docs` | admins | `775` |
| `/logs/reports` | admins | `775` |

### Verification

`verify-foundations.sh` checks the groups, users, directories and setup
log in one go. Run it on the VM with:

    # Track 1 (Vagrant): repo is mounted at /vagrant
    bash /vagrant/verify-foundations.sh

    # Track 2 (Lima): repo is mounted at /host inside the VM
    bash /host/verify-foundations.sh


### Permissions

| User  | Action                                              | Expected | Observed |
|-------|-----------------------------------------------------|----------|----------|
| alice | touch in /shared/engineering                        | allow    | allow; file tagged group engineering (setgid) |
| bob   | touch in /shared/engineering                        | allow    | allow; file tagged group engineering (setgid) |
| -     | find /shared/engineering -type f -group engineering | all files| all files listed (setgid propagated) |
| emma  | ls /shared/dropbox                                  | deny     | deny     |
| emma  | echo > /shared/dropbox/emma-note.txt                | allow    | allow    |
| emma  | cat /shared/dropbox/bob-note.txt (known path)       | allow    | allow; caveat: dropbox blocks listing, not reading by known path |
| emma  | rm /shared/dropbox/bob-note.txt                     | deny     | deny (sticky bit) |
| kate  | ls /shared/dropbox                                  | allow    | allow    |
| kate  | cat /shared/dropbox/emma-note.txt                   | allow    | allow    |


## Section 2: File Management and Permissions

Hardened the team folders and added a shared dropbox. Setgid makes team
ownership reliable; the sticky bit makes the dropbox tamper-resistant.
A permissions test report records what was attempted and what happened.

### Updated directory modes

| Path | Owner:Group | Mode | What's special |
|---|---|---|---|
| `/shared/engineering` | `root:engineering` | `2770` | setgid set |
| `/shared/marketing` | `root:marketing` | `2770` | setgid set |
| `/shared/operations` | `root:operations` | `2770` | setgid set |
| `/shared/dropbox` | `root:admins` | `1773` | sticky bit; others can write but not list |

### Verification

`verify-permissions.sh` checks the team folders, the dropbox, the sample
files, and setgid propagation. Run it on the VM with:

    # Track 1 (Vagrant): repo is mounted at /vagrant
    bash /vagrant/verify-permissions.sh

    # Track 2 (Lima): repo is mounted at /host inside the VM
    bash /host/verify-permissions.sh


### Vagrant notes
| Command | ... |
|---|---|
| vagrant up | start up |
| vagrant status | check status |
| vagrant halt | shutdown vm |
| vagrant global-status --prune | list all vms |
| vagrant destroy xxxxxxx | to remove the vm |
| vagrant ssh | connect to vm |
| exit | leave the vm |
