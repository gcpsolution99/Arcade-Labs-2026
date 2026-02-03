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
gcloud auth login --quiet
export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")

export REGION=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-region])")

gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

gcloud compute instances create lab-1 --zone $ZONE --machine-type=e2-standard-2

export NEWZONE=$(gcloud compute zones list --filter="name~'^$REGION'" \
  --format="value(name)" | grep -v "^$ZONE$" | head -n 1)

gcloud config set compute/zone $NEWZONE

function check_progress {
    while true; do
        echo
        echo -n "${BOLD}${YELLOW}Have you checked your progress for Task 1 ? (Y/N): ${RESET}"
        read -r user_input
        if [[ "$user_input" == "Y" || "$user_input" == "y" ]]; then
            echo
            echo "${BOLD}${GREEN}Great! Proceeding to the next steps...${RESET}"
            echo
            break
        elif [[ "$user_input" == "N" || "$user_input" == "n" ]]; then
            echo
            echo "${BOLD}${RED}Please check your progress for Task 1 and then press Y to continue.${RESET}"
        else
            echo
            echo "${BOLD}${MAGENTA}Invalid input. Please enter Y or N.${RESET}"
        fi
    done
}
check_progress
gcloud config configurations create user2 --quiet

gcloud auth login --no-launch-browser --quiet
gcloud config set project $(gcloud config get-value project --configuration=default) --configuration=user2
gcloud config set compute/zone $(gcloud config get-value compute/zone --configuration=default) --configuration=user2
gcloud config set compute/region $(gcloud config get-value compute/region --configuration=default) --configuration=user2
gcloud config configurations activate default
sudo yum -y install epel-release
sudo yum -y install jq

echo
get_and_export_values() {

echo -n "Enter the PROJECTID2: "
read PROJECTID2
echo

echo -n "Enter the USERID2: "
read USERID2
echo

echo -n "Enter the ZONE2: "
read ZONE2
echo

  export PROJECTID2
  export USERID2
  export ZONE2

  echo "export PROJECTID2=$PROJECTID2" >> ~/.bashrc
  echo "export USERID2=$USERID2" >> ~/.bashrc
  echo "export ZONE2=$ZONE2" >> ~/.bashrc
}

get_and_export_values

echo

. ~/.bashrc
gcloud projects add-iam-policy-binding $PROJECTID2 --member user:$USERID2 --role=roles/viewer

gcloud config configurations activate user2

gcloud config set project $PROJECTID2
gcloud config configurations activate default
gcloud iam roles create devops --project $PROJECTID2 --permissions "compute.instances.create,compute.instances.delete,compute.instances.start,compute.instances.stop,compute.instances.update,compute.disks.create,compute.subnetworks.use,compute.subnetworks.useExternalIp,compute.instances.setMetadata,compute.instances.setServiceAccount"
gcloud projects add-iam-policy-binding $PROJECTID2 --member user:$USERID2 --role=roles/iam.serviceAccountUser
gcloud projects add-iam-policy-binding $PROJECTID2 --member user:$USERID2 --role=projects/$PROJECTID2/roles/devops
gcloud config configurations activate user2
gcloud compute instances create lab-2 --zone $ZONE2 --machine-type=e2-standard-2
gcloud config configurations activate default
gcloud config set project $PROJECTID2
gcloud iam service-accounts create devops --display-name devops
SA=$(gcloud iam service-accounts list --format="value(email)" --filter "displayName=devops")
gcloud projects add-iam-policy-binding $PROJECTID2 --member serviceAccount:$SA --role=roles/iam.serviceAccountUser
gcloud projects add-iam-policy-binding $PROJECTID2 --member serviceAccount:$SA --role=roles/compute.instanceAdmin
gcloud compute instances create lab-3 --zone $ZONE2 --machine-type=e2-standard-2 --service-account $SA --scopes "https://www.googleapis.com/auth/compute"

echo

cd

remove_files() {
    # Loop through all files in the current directory
    for file in *; do
        # Check if the file name starts with "gsp", "arc", or "shell"
        if [[ "$file" == gsp* || "$file" == arc* || "$file" == shell* ]]; then
            # Check if it's a regular file (not a directory)
            if [[ -f "$file" ]]; then
                # Remove the file and echo the file name
                rm "$file"
                echo "File removed: $file"
            fi
        fi
    done
}

remove_files
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
