docker-up:
	docker compose --profile db up -d
	docker compose --profile pulsar up -d


docker-down:
	docker compose --profile db down -v
	docker compose --profile pulsar down -v

PYTHON ?= venv/bin/python

install:
	$(PYTHON) -m pip install -r requirements.txt

run:
	BROKER_HOST=localhost && PULSAR_ENV=localhost && FLASK_APP=src/aeroalpes/api flask run

activate:
	source run.sh; activate


run-bff:
	$(PYTHON) -m uvicorn bff_web.main:app --app-dir src --host localhost --port 8003 --reload