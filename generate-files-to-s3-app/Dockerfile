FROM python:3.6.10-slim-buster
WORKDIR /app
COPY requirements.txt ./
RUN pip install -r requirements.txt
COPY *.py ./
ENTRYPOINT ["python", "main.py"]