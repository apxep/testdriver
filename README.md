Tools to accelerate the Test Drive environment.  

1. ssh to the Linux VM and install git: 
     sudo dnf install -y git
2. Clone this repo to the Linux VM (use regular user, not root, unless specified):
     git clone https://github.com/apxep/testdriver
4. Run the linux_prep.bash script.
5. Execute the windows_prep.ps1 commands on the Windows VM.
6. Run the demo_prep.bash script - note that it will require input.
7. Run playbooks:
       ansible-playbook -i demo.inv -e @vars.yml -e volname=vol1 -e size=100G demo.yaml -K
   

