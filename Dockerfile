FROM python:3.11-alpine

RUN apk add --no-cache gcc musl-dev libffi-dev
RUN pip install flask
WORKDIR /app

EXPOSE 5000

CMD ["python", "app.py"]