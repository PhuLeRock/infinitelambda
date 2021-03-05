FROM ubuntu:20.04

#ENV AWS_ACCESS_KEY_ID=$KEY_ID
#ENV AWS_SECRET_ACCESS_KEY=$ACCESS_KEY
#ENV AWS_DEFAULT_REGION=$REGION
#RUN export AWS_DEFAULT_OUTPUT=text
#RUN echo "Asia/Ho_Chi_Minh" > /etc/timezone
RUN ln -fs /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
#RUN dpkg-reconfigure -f noninteractive tzdata
RUN apt-get -y update
RUN apt install -y build-essential libpq-dev
RUN apt install -y postgresql-client-12 postgresql-contrib 
RUN apt-get install -y python3-pip

RUN pip3 install  awsebcli --upgrade
RUN pip3 install  --upgrade awscli
RUN pip3 install psycopg2

ADD pyapp.py /src/
CMD /usr/bin/python3 /src/pyapp.py

