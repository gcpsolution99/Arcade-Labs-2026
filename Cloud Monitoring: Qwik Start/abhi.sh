#!/bin/bash
YELLOW='\033[0;33m'
NC='\033[0m' 
pattern=(
"**********************************************************"
"**                 S U B S C R I B E  TO                **"
"**                 ABHI ARCADE SOLUTION                 **"
"**                                                      **"
"**********************************************************"
)
for line in "${pattern[@]}"
do
    echo -e "${YELLOW}${line}${NC}"
done

echo "Enter Zone:"
read -r ZONE
export ZONE

gcloud compute instances create lamp-1-vm \
    --project=$DEVSHELL_PROJECT_ID \
    --zone=$ZONE \
    --machine-type=e2-small \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
    --metadata=enable-oslogin=true \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --tags=http-server \
    --create-disk=auto-delete=yes,boot=yes,device-name=lamp-1-vm,image=projects/debian-cloud/global/images/debian-12-bookworm-v20240709,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any

gcloud compute firewall-rules create allow-http \
    --project=$DEVSHELL_PROJECT_ID \
    --direction=INGRESS \
    --priority=1000 \
    --network=default \
    --action=ALLOW \
    --rules=tcp:80 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=http-server

sleep 10

gcloud compute config-ssh --project "$DEVSHELL_PROJECT_ID" --quiet

gcloud compute ssh lamp-1-vm --project "$DEVSHELL_PROJECT_ID" --zone $ZONE --command "sudo sed -i '/buster-backports/d' /etc/apt/sources.list && sudo apt-get update && sudo apt-get install apache2 php7.3 -y && sudo service apache2 restart"

sleep 10

INSTANCE_ID="$(gcloud compute instances describe  lamp-1-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --format='value(id)')"

gcloud monitoring uptime create lamp-uptime-check \
  --resource-type="gce-instance" \
  --resource-labels=project_id=$DEVSHELL_PROJECT_ID,instance_id=$INSTANCE_ID,zone=$ZONE

pattern=(
"**********************************************************"
"**                 S U B S C R I B E  TO                **"
"**                 ABHI ARCADE SOLUTION                 **"
"**                                                      **"
"**********************************************************"
)
for line in "${pattern[@]}"
do
    echo -e "${YELLOW}${line}${NC}"
done
