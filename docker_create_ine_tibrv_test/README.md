
# TIBCO RV Message Testing - Technical Stack & Flow
## Technical Stack
- **TIBCO Rendezvous (RV):** For reliable message publishing and receiving.
- **Docker:** Containerizes the TIBCO RV environment for isolated, repeatable testing.
- **Bash Scripts:** Automate message send/receive tests.
- **Windows Batch Scripts:** Automate directory and file structure creation.
- **Docker Compose:** Orchestrates multi-container setup for staging/production simulation.

## System Flow

1. **Directory Structure Creation**
   - Use `create_tibco_structure.bat` to generate all required folders and initial files for the project.

2. **Docker Image Build**
   - Build the Docker image for TIBCO RV using the provided Dockerfile.

3. **Staging Server Setup**
   - Use Docker Compose to start a containerized TIBCO RV instance.
   - The container is configured to use the same IP address as the production server (or a fixed IP in the Docker network).

4. **Message Testing**
   - The test script (`run_tests.sh`) starts a receiver in the container.
   - The sender (can be from host or another container) publishes a message.
   - The receiver logs the message, confirming end-to-end delivery.
## Flow Chart

Below is a high-level flow chart of the process:

```mermaid
flowchart TD
   A[Create Project Structure] --> B[Build Docker Image]
   B --> C[Start Staging Server in Docker]
   C --> D[Start RV Receiver in Container]
   D --> E[Publish Message from Sender]
   E --> F[Receiver Logs Message]
   F --> G[Verify Message Delivery]
   C -.-> H[Assign Fixed IP (Optional)]
   H -.-> D
   C -.-> I[Multi-Node/Cluster Setup (Optional)]
   I -.-> D
```
## Docker Network & Fixed IP Example
To assign a fixed IP to staging server container (matching production):
1. Create a custom Docker network:
    ```sh
    docker network create --subnet=172.28.0.0/16 my_custom_network
    ```
2. In `docker-compose.yml`, specify the network and IP:
    ```yaml
    services:
       tibco-rv:
          networks:
             my_custom_network:
                ipv4_address: 172.28.0.10
    networks:
       my_custom_network:
          external: true
    ```
3. Use this IP in sender/receiver commands for accurate simulation.

## Advanced Test Scenarios
## More RV Message Test Examples
### 1. Test with Multiple Topics
Start two receivers in different terminals or background processes:

```sh
tibrvlisten -s "tcp:localhost:7500" -t "topic_alpha" &
tibrvlisten -s "tcp:localhost:7500" -t "topic_beta" &
```

Send messages to each topic:

```sh
tibrvsend -s "tcp:localhost:7500" -t "topic_alpha" -m "Message for Alpha"
tibrvsend -s "tcp:localhost:7500" -t "topic_beta" -m "Message for Beta"
```

### 2. Test with Multiple Senders

Can run several senders in parallel to simulate load:

```sh
for i in {1..10}; do
   tibrvsend -s "tcp:localhost:7500" -t "load_test" -m "Test message $i" &
done
```

### 3. Simulate Network Partition

Stop the Docker container running the receiver, then restart it and observe if messages are missed or handled as expected:

```sh
docker stop <container_id>
# ...wait, then...
docker start <container_id>
```

### 4. Use Docker Compose for Multi-Node Simulation
Can define multiple RV nodes in `docker-compose.yml` to simulate a cluster or multi-environment setup. Example:

```yaml
services:
   rv_node1:
      build: .
      ports:
         - "7500:7500"
      networks:
         my_custom_network:
            ipv4_address: 172.28.0.10
   rv_node2:
      build: .
      ports:
         - "7501:7500"
      networks:
         my_custom_network:
            ipv4_address: 172.28.0.11
networks:
   my_custom_network:
      external: true
```
## Extending to AWS SNS and Kafka (Debezium)
This project structure and testing approach can be adapted for other messaging platforms such as AWS SNS and Kafka (including Debezium for CDC). 
Simply replace the RV message commands with the appropriate CLI or SDK calls for your target system, and adjust the Docker setup as needed for those services.
Kafka (Debezium) Message Test
### Publish a Message
```sh
kafka-console-producer --broker-list localhost:9092 --topic my_topic
# Then type message and press Enter
Hello from Kafka test!
```
### Receive a Message
```sh
kafka-console-consumer --bootstrap-server localhost:9092 --topic my_topic --from-beginning --max-messages 1
```
### Debezium CDC Example
Debezium captures changes from a database and publishes them to Kafka topics. To test, insert or update a row in your source DB, then consume from the Debezium topic:
```sh
kafka-console-consumer --bootstrap-server localhost:9092 --topic dbserver1.inventory.customers --from-beginning --max-messages 1
```
---

All message testing is isolated from production, ensuring safe validation. You can extend the setup for more advanced scenarios as needed.

---



