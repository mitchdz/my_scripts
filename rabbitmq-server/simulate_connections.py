#!/usr/bin/python3

import pika
import threading

# RabbitMQ connection parameters
rabbitmq_params = pika.ConnectionParameters(host='localhost', port=5672, virtual_host='/', credentials=pika.PlainCredentials('guest', 'guest'))

# Number of connections to simulate
num_connections = 2048

def create_connection():
    connection = pika.BlockingConnection(parameters=rabbitmq_params)
    print(f"Connection created: {connection}")
    # Keep the connection open (optional)
    # connection.ioloop.start()

# Create threads for each connection
threads = []
for _ in range(num_connections):
    thread = threading.Thread(target=create_connection)
    threads.append(thread)
    thread.start()

# Wait for all threads to complete
for thread in threads:
    thread.join()
