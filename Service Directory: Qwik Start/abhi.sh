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

read -p "Enter Location: " LOCATION

gcloud services enable servicedirectory.googleapis.com

sleep 15

 gcloud service-directory namespaces create example-namespace \
  --location $LOCATION;

gcloud service-directory services create example-service \
  --namespace example-namespace \
  --location $LOCATION; 

gcloud service-directory endpoints create example-endpoint \
  --address 0.0.0.0 \
  --port 80 \
  --service example-service \
  --namespace example-namespace \
  --location $LOCATION; 

  gcloud dns managed-zones create example-zone-name \
  --dns-name myzone.example.com \
  --description "" \
  --visibility private \
  --networks "https://www.googleapis.com/compute/v1/projects/$DEVSHELL_PROJECT_ID/global/networks/default" \
  --service-directory-namespace "https://servicedirectory.googleapis.com/v1/projects/$DEVSHELL_PROJECT_ID/locations/$LOCATION/namespaces/example-namespace"; 
  

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
