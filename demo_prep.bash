[[ -z "$DEMODIR" ]] && DEMODIR=~/demo

[[ -x $DEMODIR ]] || mkdir $DEMODIR

cd $DEMODIR
ansible-galaxy collection install purestorage.flasharray

#git clone https://github.com/PureStorage-OpenConnect/ansible-playbook-examples

# requires password input
TOKEN1=$(sshpass -p "pureuser" ssh pureuser@flasharray1.testdrive.local -o StrictHostKeyChecking=No "pureadmin list --api-token --expose" | awk '/local/ {print $3}')
[[ -z $TOKEN1 ]] && TOKEN1=$(sshpass -p "pureuser" ssh pureuser@flasharray1.testdrive.local -o StrictHostKeyChecking=No "pureadmin create --api-token" | awk '/local/ {print $3}')

# requires password input
TOKEN2=$(sshpass -p "pureuser" ssh pureuser@flasharray2.testdrive.local -o StrictHostKeyChecking=No "pureadmin list --api-token --expose" | awk '/local/ {print $3}')
[[ -z $TOKEN2 ]] && TOKEN2=$(sshpass -p "pureuser" ssh pureuser@flasharray2.testdrive.local -o StrictHostKeyChecking=No "pureadmin create --api-token" | awk '/local/ {print $3}')


echo $TOKEN1 > $DEMODIR/flasharray1.token
echo $TOKEN2 > $DEMODIR/flasharray2.token

ssh-keygen -t rsa -b 2048 -f  ~/.ssh/rsa -N "" -q

sshpass -p "pureuser" ssh-copy-id linux1.testdrive.local

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
