FROM python:3.11-slim

RUN apt-get update &&     apt-get install -y openssh-client git &&     pip install --no-cache-dir ansible just

WORKDIR /workspace

COPY . /workspace

CMD ["just", "--choose"]