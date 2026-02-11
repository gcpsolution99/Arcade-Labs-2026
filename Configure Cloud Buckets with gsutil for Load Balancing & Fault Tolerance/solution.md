# Please like share & subscribe to [Abhi arcade solution](http://www.youtube.com/@Abhi_Arcade_Solution)

#### ⚠️ Disclaimer :
- **This script is for the educational purposes just to show how quickly we can solve lab. Please make sure that you have a thorough understanding of the instructions before utilizing any scripts. We do not promote cheating or  misuse of resources. Our objective is to assist you in mastering the labs with efficiency, while also adhering to both 'qwiklabs' terms of services and YouTube's community guidelines.**

## Run in CloudShell and follow video:

```
PROJECT_ID=$(gcloud config get-value project)
OLD_BUCKET=${PROJECT_ID}-bucket
NEW_BUCKET=${PROJECT_ID}-new

gsutil mb gs://$NEW_BUCKET

gsutil web set -m index.html -e error.html gs://$NEW_BUCKET

gsutil iam ch allUsers:roles/storage.admin gs://$NEW_BUCKET

gsutil -m rsync -r gs://$OLD_BUCKET gs://$NEW_BUCKET

gcloud compute backend-buckets create backend-new \
  --gcs-bucket-name=$NEW_BUCKET \
  --enable-cdn

gcloud compute url-maps create website-map \
  --default-backend-bucket=backend-new

gcloud compute target-http-proxies create website-proxy \
  --url-map=website-map

gcloud compute forwarding-rules create website-rule \
  --global \
  --target-http-proxy=website-proxy \
  --ports=80
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
