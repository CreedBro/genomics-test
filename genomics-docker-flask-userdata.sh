#! /bin/sh
sleep 1

yum update -y
amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user
chkconfig docker on
python3 -m pip install flask
python3 -m pip install boto3


#create directory and html file and manage permissions
cd /home/ec2-user
mkdir -p app/templates && cd app
touch app.py Dockerfile requirements.txt templates/index.html
chown -R ec2-user:ec2-user app
#manage permissions
chown ec2-user:ec2-user Dockerfile
chmod g+w Dockerfile

#get image file from s3 at this point 


#code simple html file
cat > templates/index.html <<EOF 
<!DOCTYPE html>
<html>
    <body>
        <h2>Hello World!</h2>
        <img id="picture" src="data:image/png;base64,{{ img_data }}" width="500" height="600"/>
    </body>
</html>
EOF

#Change value of <BUCKET> to your s3 bucket name. A follow-up commit is set to automate this.
cat > app.py <<EOF
from flask import Flask, render_template
import boto3, botocore
import os
import io
import base64

app = Flask(__name__)

@app.route("/")
def home():
    
    s3 = boto3.resource('s3', region_name='us-east-1')
    bucket = s3.Bucket('<BUCKET>')
    object = bucket.Object('pexels-lood-goosen-1235706.jpg')

    iofile = io.BytesIO()

    object.download_fileobj(iofile)
    iofile.seek(0)

    image_memory = base64.b64encode(iofile.getvalue())

    return render_template("index.html", img_data=image_memory.decode('utf-8'))
EOF

cat > requirements.txt <<EOF
boto3==1.24.17
botocore==1.27.17
click==8.1.3
docutils==0.14
Flask==2.1.2
importlib-metadata==4.12.0
itsdangerous==2.1.2
Jinja2==3.1.2
jmespath==1.0.1
lockfile==0.11.0
MarkupSafe==2.1.1
pystache==0.5.4
python-daemon==2.2.3
python-dateutil==2.8.2
s3transfer==0.6.0
simplejson==3.2.0
six==1.16.0
typing_extensions==4.2.0
urllib3==1.26.9
Werkzeug==2.1.2
zipp==3.8.0
EOF



echo "FROM python:3.7" > Dockerfile
echo "WORKDIR /app" >> Dockerfile
echo "COPY . /app" >> Dockerfile 
echo "RUN pip install -r requirements.txt" >> Dockerfile
echo "CMD [\"flask\", \"run\", \"--host=0.0.0.0\"]" >> Dockerfile

#build container and run it
docker build -t flask-container . && docker run -p 5000:5000 flask-container






