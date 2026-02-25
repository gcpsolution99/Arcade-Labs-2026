
# Please like share & subscribe to [Abhi arcade solution](http://www.youtube.com/@Abhi_Arcade_Solution)

#### ⚠️ Disclaimer :
- **This script is for the educational purposes just to show how quickly we can solve lab. Please make sure that you have a thorough understanding of the instructions before utilizing any scripts. We do not promote cheating or  misuse of resources. Our objective is to assist you in mastering the labs with efficiency, while also adhering to both 'qwiklabs' terms of services and YouTube's community guidelines.**

## Run in CloudShell and follow video:

```
gcloud auth list
export PROJECT_ID=$(gcloud config get-value project)
export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")
gcloud iam service-accounts create my-sa-123 --display-name "Service Account for BigQuery Demo"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member serviceAccount:my-sa-123@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
  --role roles/editor

gcloud iam service-accounts create bigquery-qwiklab \
  --description="Service account for BigQuery operations" \
  --display-name="bigquery-qwiklab"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member="serviceAccount:bigquery-qwiklab@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/bigquery.dataViewer"

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member="serviceAccount:bigquery-qwiklab@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/bigquery.user"

gcloud compute instances create bigquery-instance \
  --project=$DEVSHELL_PROJECT_ID \
  --zone=$ZONE \
  --machine-type=e2-medium \
  --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
  --metadata=enable-oslogin=true \
  --maintenance-policy=MIGRATE \
  --provisioning-model=STANDARD \
  --service-account=bigquery-qwiklab@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
  --scopes=https://www.googleapis.com/auth/cloud-platform \
  --create-disk=auto-delete=yes,boot=yes,device-name=bigquery-instance,image=projects/debian-cloud/global/images/debian-11-bullseye-v20231010,mode=rw,size=10,type=projects/$DEVSHELL_PROJECT_ID/zones/$ZONE/diskTypes/pd-balanced \
  --no-shielded-secure-boot \
  --shielded-vtpm \
  --shielded-integrity-monitoring \
  --labels=goog-ec-src=vm_add-gcloud \
  --reservation-affinity=any

cat > cp_disk.sh <<'EOF_CP'
#!/bin/bash

sudo apt-get update -qq
sudo apt-get install -y -qq git python3-pip

pip3 install --quiet --upgrade pip
pip3 install --quiet google-cloud-bigquery pyarrow pandas db-dtypes

cat > query.py <<'EOF_PY'
from google.auth import compute_engine
from google.cloud import bigquery
import pandas as pd

credentials = compute_engine.Credentials(
    service_account_email='YOUR_SERVICE_ACCOUNT')

query = '''
SELECT
  year,
  COUNT(1) as num_babies
FROM
  publicdata.samples.natality
WHERE
  year > 2000
GROUP BY
  year
ORDER BY
  year
'''

client = bigquery.Client(
    project='PROJECT_ID',
    credentials=credentials)

df = client.query(query).to_dataframe()

print(df.to_string(index=False))
EOF_PY

sed -i -e "s/PROJECT_ID/$(gcloud config get-value project)/g" query.py
sed -i -e "s/YOUR_SERVICE_ACCOUNT/bigquery-qwiklab@$(gcloud config get-value project).iam.gserviceaccount.com/g" query.py

python3 query.py
EOF_CP

gcloud compute scp cp_disk.sh bigquery-instance:/tmp \
  --project=$DEVSHELL_PROJECT_ID \
  --zone=$ZONE \
  --quiet

gcloud compute ssh bigquery-instance \
  --project=$DEVSHELL_PROJECT_ID \
  --zone=$ZONE \
  --quiet \
  --command="chmod +x /tmp/cp_disk.sh && /tmp/cp_disk.sh"
```

## ©Credit :
- All rights and credits goes to original content of Google Cloud [Google Cloud SkillBoost](https://www.cloudskillsboost.google/) 

## Congratulations !!

### ** Join us on below platforms **

- <img width="25" alt="image" src="https://github.com/user-attachments/assets/171448df-7b22-4166-8d8d-86f72fb78aff"> [Telegram Discussion Group](https://t.me/+HiOSF3PxrvFhNzU1)
- <img width="25" alt="image" src="https://github.com/user-attachments/assets/0ebd7e7d-6f9b-41e9-a241-8483dca9f3f1"> [Telegram Channel](https://t.me/abhiarcadesolution)
- <img width="25" alt="image" src="https://github.com/user-attachments/assets/dc326965-d4fa-4f1b-87f1-dbad6e3a7259"> [Abhi Arcade Solution](https://www.youtube.com/@Abhi_Arcade_Solution)
- <img width="26" alt="image" src="https://github.com/user-attachments/assets/d9070a07-7fce-47c5-8626-7ea98ccc46e3"> [WhatsApp](https://whatsapp.com/channel/0029VakEGSJ0VycJcnB8Fn3z)
- <img width="23" alt="image" src="https://github.com/user-attachments/assets/ce0916c3-e5f9-4709-afbd-e67bd42d1c57"> [LinkedIn](https://www.linkedin.com/in/abhi-arcade-solution-9b8a15319/)
