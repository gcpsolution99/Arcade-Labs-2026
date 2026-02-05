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

gcloud compute instances create blue \
  --project=$DEVSHELL_PROJECT_ID \
  --zone=$ZONE \
  --machine-type=e2-micro \
  --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
  --metadata=enable-oslogin=true \
  --tags=web-server \
  --create-disk=auto-delete=yes,boot=yes,device-name=blue,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230509,mode=rw,size=10,type=pd-balanced \
  --quiet

gcloud compute instances create green \
  --project=$DEVSHELL_PROJECT_ID \
  --zone=$ZONE \
  --machine-type=e2-micro \
  --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
  --metadata=enable-oslogin=true \
  --create-disk=auto-delete=yes,boot=yes,device-name=green,image=projects/debian-cloud/global/images/debian-11-bullseye-v20230509,mode=rw,size=10,type=pd-balanced \
  --quiet

gcloud compute firewall-rules create allow-http-web-server \
  --project=$DEVSHELL_PROJECT_ID \
  --direction=INGRESS \
  --priority=1000 \
  --network=default \
  --allow=tcp:80,icmp \
  --source-ranges=0.0.0.0/0 \
  --target-tags=web-server \
  --quiet

gcloud compute instances create test-vm \
  --project=$DEVSHELL_PROJECT_ID \
  --zone=$ZONE \
  --machine-type=e2-micro \
  --subnet=default \
  --quiet

gcloud iam service-accounts create network-admin \
  --description="Service account for Network Admin role" \
  --display-name="Network-admin" \
  --quiet

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=serviceAccount:network-admin@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
  --role=roles/compute.networkAdmin \
  --quiet

gcloud iam service-accounts keys create credentials.json \
  --iam-account=network-admin@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
  --quiet

cat > bluessh.sh <<'EOF_END'
sudo apt-get update -y
sudo apt-get install nginx-light -y
sudo sed -i '14c\<h1>Welcome to the blue server!</h1>' /var/www/html/index.nginx-debian.html
sudo systemctl restart nginx
EOF_END

gcloud compute scp bluessh.sh blue:/tmp --zone=$ZONE --quiet
gcloud compute ssh blue --zone=$ZONE --quiet --command="bash /tmp/bluessh.sh"

cat > greenssh.sh <<'EOF_END'
sudo apt-get update -y
sudo apt-get install nginx-light -y
sudo sed -i '14c\<h1>Welcome to the green server!</h1>' /var/www/html/index-nginx-debian.html
sudo systemctl restart nginx
EOF_END

gcloud compute scp greenssh.sh green:/tmp --zone=$ZONE --quiet
gcloud compute ssh green --zone=$ZONE --quiet --command="bash /tmp/greenssh.sh"
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
