#!/bin/bash
set -e

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
  cat > .env << EOL

# Elasticsearch Settings
ELASTIC_PASSWORD=elastic123!
ELASTICSEARCH_USERNAME=elastic
ELASTICSEARCH_PASSWORD=elastic123!

# Grafana Settings
GF_SECURITY_ADMIN_PASSWORD=admin
GF_SECURITY_ADMIN_USER=admin

# MariaDB Settings
MYSQL_ROOT_PASSWORD=root_password
MYSQL_DATABASE=appwrite
MYSQL_USER=appwrite
MYSQL_PASSWORD=appwrite_password
EOL
fi

# Start everything up
docker-compose pull
docker-compose up -d

# Wait for services to be ready
echo "Waiting for services to be ready..."
sleep 30

# Test connections
echo "Testing Elasticsearch connection..."
curl -u elastic:elastic123! http://localhost:9200

echo "Testing Prometheus connection..."
curl http://localhost:9090/-/healthy

echo "Testing Grafana connection..."
curl http://localhost:3000/api/health

echo "Testing Violations Service connection..."
curl http://localhost:8000/health

echo """
🎉 Setup complete! Access your services at:

📊 Monitoring:
   - Grafana: http://localhost:3000 (admin/admin)
   - Prometheus: http://localhost:9090
   - Kibana: http://localhost:5601 (elastic/elastic123!)

🔍 Services:
   - Violations Service: http://localhost:8000
   - Elasticsearch: http://localhost:9200
   - Kafka: localhost:9092
   - Appwrite: http://localhost (check Appwrite docs for ports)

💡 Useful commands:
   - View logs: docker-compose logs -f [service_name]
   - Restart service: docker-compose restart [service_name]
   - Stop everything: docker-compose down
   - Start everything: docker-compose up -d
"""