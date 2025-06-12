FROM python:3.11-alpine

RUN apk add --no-cache gcc musl-dev libffi-dev
RUN pip install flask
WORKDIR /app
COPY app.py /app/app.py

EXPOSE 5000

CMD ["python", "app.py"]