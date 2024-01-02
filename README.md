# remarkable2

Repository where I intend to collect my resources around the **remarkable2** device.

# Why

After some time having some files dangling around my laptop and having to re-install them every time an update comes up, I decided to store them in a git repo, make it public and create a script to automate the work.

# Templates

At this point of time I just use a set of 3 custom templates, which the main point is to respect the space for the floating tool bar that appears in the left:

- *Checklist w/ margin*: A checklist portait template displaced a bit to the right.
- *1:1 w/ margin*: A custom 2 checklist space portait template with some tips to hold 1:1 meetings
- *Standup w/ margin*: A custom 3 checklist space portait template to use on everyday's standups

# Script

The script in the `templates` folder is meant to automatise the installation of the templates. It has been a 20 minutes coding, so I expect everyone having a suggestion to improve it.

It expect a parameter `-i` with the IP of the device in your local network:

```
$ ./install_xavi_templates.sh -i 172.21.88.14

Will copy templates from . to root@172.21.88.14:/usr/share/remarkable/templates

Are you sure (y/n)? y
Starting...
Copying template 1: x_1o1.png
x_1o1.png                                              100%   76KB   1.4MB/s   00:00
Copying template 2: x_checklist.png
x_checklist.png                                        100%   15KB   1.1MB/s   00:00
Copying template 3: x_standup.png
x_standup.png                                          100%   40KB   1.5MB/s   00:00
Getting the template JSON file
templates.json                                         100%   13KB   1.4MB/s   00:00
Adding the templates config into the JSON FILE
Validate the JSON
Copying back the templates config into the device
templates.json                                         100%   14KB   1.3MB/s   00:00
Cleaning up
```

The only think missing at the end of the script is to reboot the system so that the templates are loaded. At this point this has to be done by ssh-ing into the device and execute the following command:

```
systemctl restart xochitl
```

Of course, it is mandatory that the device is on and connected to the local network.