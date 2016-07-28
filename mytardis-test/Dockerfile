FROM python:2
ENV PYTHONUNBUFFERED 1

MAINTAINER Ian Thomas <ianedwardthomas@gmail.com>

WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app/

RUN pip install --no-cache-dir -r requirements.txt

COPY smoke.py /usr/src/app

ENTRYPOINT ["python", "smoke.py"]
