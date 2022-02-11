FROM python:3.8

LABEL Author="mprasoon"

ENV PYTHONBUFFERED 1

RUN mkdir /tradeapp

WORKDIR /tradeapp

COPY . /tradeapp

RUN pip install -r requirements.txt