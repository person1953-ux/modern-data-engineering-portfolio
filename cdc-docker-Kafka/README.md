
"""
ONE LINE COMMAND TO RUN THE PROJECT
Set-ExecutionPolicy -Scope Process Bypass; & "C:\Users\User\nhan\cdc-demo\run-cdc.ps1" -Action all
"""


# CDC Demo (Postgres + Debezium + Kafka)

## Services
- Kafka broker: `localhost:9092`
- Kafka UI: `http://localhost:8080`
- Debezium Connect: `http://localhost:8083`
- Postgres: `localhost:5432`

## 1) Start the stack
```bash
docker compose up -d
docker compose ps
```

## 2) Register the Debezium connector
### PowerShell
```powershell
powershell -ExecutionPolicy Bypass -File .\register-connector.ps1
```

### Verify connector
```bash
curl http://localhost:8083/connectors
curl http://localhost:8083/connectors/customers-connector/status
```

## 3) Run CDC smoke tests

### Bash (Git Bash)
```bash
bash ./smoke-test-cdc.sh
```

### PowerShell
```powershell
powershell -ExecutionPolicy Bypass -File .\smoke-test-cdc.ps1
```

Both scripts validate end-to-end CDC by:
1. Inserting a unique customer row
2. Updating that row
3. Deleting that row
4. Verifying Debezium events include `op:"c"`, `op:"u"`, and `op:"d"`

## 4) Stop the stack
```bash
docker compose down
```

## Optional: one-command helpers

### Bash helper
```bash
bash ./run-cdc.sh all
```

Other actions:
```bash
bash ./run-cdc.sh up
bash ./run-cdc.sh register
bash ./run-cdc.sh smoke
bash ./run-cdc.sh status
bash ./run-cdc.sh down
```

### PowerShell helper
```powershell
powershell -ExecutionPolicy Bypass -File .\run-cdc.ps1 -Action all
```

Other actions:
```powershell
powershell -ExecutionPolicy Bypass -File .\run-cdc.ps1 -Action up
powershell -ExecutionPolicy Bypass -File .\run-cdc.ps1 -Action register
powershell -ExecutionPolicy Bypass -File .\run-cdc.ps1 -Action smoke
powershell -ExecutionPolicy Bypass -File .\run-cdc.ps1 -Action status
powershell -ExecutionPolicy Bypass -File .\run-cdc.ps1 -Action down
```

"""

Start with the compose file (as a command, not by “running” the file directly).

First: run docker compose up -d using docker-compose.yml.
Second: register connector with register-connector.ps1.
Third: validate CDC with smoke-test-cdc.sh (Bash) or smoke-test-cdc.ps1 (PowerShell).
Fastest one-command option:

Bash: bash [run-cdc.sh](http://_vscodecontentref_/4) all via run-cdc.sh
PowerShell: powershell -ExecutionPolicy Bypass -File [run-cdc.ps1](http://_vscodecontentref_/6) -Action all via run-cdc.ps1
OUTPUT

PS C:\Users\User\nhan\cdc-demo> Set-ExecutionPolicy -Scope Process Bypass; & "C:\Users\User\nhan\cdc-demo\run-cdc.ps1" -Action all
[+] up 4/4
 ✔ Container postgres Running                                                                       0.0s
 ✔ Container kafka    Running                                                                       0.0s
 ✔ Container kafka-ui Running                                                                       0.0s
 ✔ Container debezium Running                                                                       0.0s

Starting Kafka consumer for topic: dbserver1.public.customers
Producing DB changes for smoke1771700257@example.com
Results: email=smoke1771700257@example.com id=13
Counts: email_hits=4 c=1 u=1 d=1
CDC smoke test PASSED
