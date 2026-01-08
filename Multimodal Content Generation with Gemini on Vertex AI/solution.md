
# Please like share & subscribe to [Abhi arcade solution](http://www.youtube.com/@Abhi_Arcade_Solution)

#### ⚠️ Disclaimer :
- **This script is for the educational purposes just to show how quickly we can solve lab. Please make sure that you have a thorough understanding of the instructions before utilizing any scripts. We do not promote cheating or  misuse of resources. Our objective is to assist you in mastering the labs with efficiency, while also adhering to both 'qwiklabs' terms of services and YouTube's community guidelines.**

## ©Credit :
- All rights and credits goes to original content of Google Cloud [Google Cloud SkillBoost](https://www.cloudskillsboost.google/)

```

import vertexai
import urllib.request
from vertexai.generative_models import GenerativeModel, Part

PROJECT_ID = ""
LOCATION = ""

vertexai.init(project=PROJECT_ID, location=LOCATION)

def load_image_from_url(prompt):
    print(f"Processing prompt: {prompt}")
    image_url = "https://storage.googleapis.com/cloud-samples-data/generative-ai/image/scones.jpg"
    
    try:
        with urllib.request.urlopen(image_url) as response:
            image_bytes = response.read()
            
        image_part = Part.from_data(
            data=image_bytes,
            mime_type="image/jpeg"
        )
        model = GenerativeModel("gemini-2.0-flash")

        response = model.generate_content(
            [image_part, prompt],
            generation_config={
                "temperature": 0.4,
                "max_output_tokens": 2048
            }
        )
        
        print("\n--- Model Response ---")
        print(response.text)
        return response.text

    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    text_prompt = "Write a descriptive caption for this image and suggest a flavor profile."
    load_image_from_url(text_prompt)
```

## Congratulations !!

### ** Join us on below platforms **

- <img width="25" alt="image" src="https://github.com/user-attachments/assets/171448df-7b22-4166-8d8d-86f72fb78aff"> [Telegram Discussion Group](https://t.me/+HiOSF3PxrvFhNzU1)
- <img width="25" alt="image" src="https://github.com/user-attachments/assets/0ebd7e7d-6f9b-41e9-a241-8483dca9f3f1"> [Telegram Channel](https://t.me/abhiarcadesolution)
- <img width="25" alt="image" src="https://github.com/user-attachments/assets/dc326965-d4fa-4f1b-87f1-dbad6e3a7259"> [Abhi Arcade Solution](https://www.youtube.com/@Abhi_Arcade_Solution)
- <img width="26" alt="image" src="https://github.com/user-attachments/assets/d9070a07-7fce-47c5-8626-7ea98ccc46e3"> [WhatsApp](https://whatsapp.com/channel/0029VakEGSJ0VycJcnB8Fn3z)
- <img width="23" alt="image" src="https://github.com/user-attachments/assets/ce0916c3-e5f9-4709-afbd-e67bd42d1c57"> [LinkedIn](https://www.linkedin.com/in/abhi-arcade-solution-9b8a15319/)
</div>
