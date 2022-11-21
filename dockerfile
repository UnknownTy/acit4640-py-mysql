FROM python

RUN apt-get update -qy
RUN apt-get install -y wait-for-it
RUN apt-get install -y wget unzip
RUN pip install gunicorn

# Set the working directory to a matchin /app/ directory
RUN mkdir /backend
RUN mkdir /frontend
WORKDIR /tmp/

RUN wget https://github.com/timoguic/acit4640-py-mysql/archive/refs/heads/master.zip
RUN unzip master.zip

RUN mv /tmp/acit4640-py-mysql-master/backend /backend/src

RUN mv /tmp/acit4640-py-mysql-master/frontend/* /frontend
WORKDIR /backend/src
RUN pip install -r ./requirements.txt

COPY ./boot.sh .
EXPOSE ${BACKEND_PORT}


CMD [ "bash", "boot.sh" ]