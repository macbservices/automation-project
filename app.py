cat <<EOF > app.py
from flask import Flask, request, jsonify
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from PIL import Image
import time, os, smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.image import MIMEImage

app = Flask(__name__)

@app.route('/youtube', methods=['POST'])
def watch_youtube():
    data = request.json
    link = data['link']
    browsers = data['browsers']

    chrome_options = Options()
    chrome_options.add_argument('--headless')  # Ocultar janelas do navegador
    chrome_options.add_argument('--disable-gpu')
    chrome_options.add_argument('--no-sandbox')

    for _ in range(browsers):
        driver = webdriver.Chrome(options=chrome_options)
        driver.get(link)
        time.sleep(60)  # Assistir ao vídeo por 60 segundos
        driver.quit()

    return jsonify({"status": "Success", "message": "YouTube videos watched"})

@app.route('/maps', methods=['POST'])
def rate_google_maps():
    data = request.json
    link = data['link']
    comment = data['comment']
    star_rating = data['stars']
    email = data['email']

    # Simulação de avaliação
    screenshot_path = "/var/www/automation/screenshot.png"

    chrome_options = Options()
    chrome_options.add_argument('--headless')
    chrome_options.add_argument('--disable-gpu')
    chrome_options.add_argument('--no-sandbox')

    driver = webdriver.Chrome(options=chrome_options)
    driver.get(link)
    time.sleep(5)  # Esperar carregamento

    # Capturar screenshot
    driver.save_screenshot(screenshot_path)
    driver.quit()

    # Enviar e-mail
    send_email(email, screenshot_path, comment)

    return jsonify({"status": "Success", "message": "Rating completed"})

def send_email(email, screenshot_path, comment):
    sender = "tiktokmacb@gmail.com"
    password = "your-email-password"  # Substitua pela senha do e-mail
    receiver = email

    msg = MIMEMultipart()
    msg['From'] = sender
    msg['To'] = receiver
    msg['Subject'] = "Google Maps Review Screenshot"

    text = MIMEText(f"Review submitted with comment: {comment}")
    msg.attach(text)

    with open(screenshot_path, 'rb') as f:
        img_data = f.read()
    image = MIMEImage(img_data, name=os.path.basename(screenshot_path))
    msg.attach(image)

    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as server:
        server.login(sender, password)
        server.sendmail(sender, receiver, msg.as_string())

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF
