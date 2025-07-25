[[ -z "$DEMODIR" ]] && DEMODIR=~/demo

[[ -x $DEMODIR ]] || mkdir $DEMODIR

cd $DEMODIR
ansible-galaxy collection install purestorage.flasharray

git clone https://github.com/PureStorage-OpenConnect/ansible-playbook-examples

# requires password input
ssh pureuser@flasharray1.testdrive.local "pureadmin create --api-token" | awk '/local/ {print $3}' > $DEMODIR/flasharray1.token

# requires password input
ssh pureuser@flasharray2.testdrive.local "pureadmin create --api-token" | awk '/local/ {print $3}' > $DEMODIR/flasharray2.token

ssh-keygen 
# requires input, <return>
ssh-copy-id linux1.testdrive.local
# requires password input, this will make ansible work with SSH keys

cat > $DEMODIR/vars.yml << EOF
fa1_url: flasharray1.testdrive.local
fa1_api: $(cat $DEMODIR/flasharray1.token)
fa2_url: flasharray2.testdrive.local
fa2_api: $(cat $DEMODIR/flasharray2.token)
EOF


## SMOKE TEST
# export PUREFA_URL=flasharray1.testdrive.local
# export PUREFA_API=”$(cat flasharray1.token)”
# ansible all -c local -i “localhost,” -m purestorage.flasharray.purefa_info
