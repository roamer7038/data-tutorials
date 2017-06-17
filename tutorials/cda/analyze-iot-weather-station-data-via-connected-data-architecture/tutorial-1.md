---
title: Analyze IoT Weather Station Data via Connected Data Architecture
tutorial-id: 820
platform: hdp-2.6.0
tags: [nifi, minifi, raspberry pi, connected data architecture, hbase, iot, weather]
---

# IoT and Connected Data Architecture Concepts

## Introduction

Anytime there are at least two platforms connected: HDF and HDP, that environment is called Connected Data Architecture. For this tutorial, we are building a Connected Data Architecture that incorporates: MiNiFi based at the Raspberry Pi, HDF docker sandbox and HDP docker sandbox both located within the docker engine. The purpose of the concepts section is to dive into each tool that is used within this tutorial.

Apache NiFi is a dataflow engine that makes it possible to ingest data from any data source and transport it to any destination, so that developers can focus on data processing implementation. We will use Apache MiNiFi to ingest the sensor readings from the R-Pi and transport that data to NiFi to send to HBase. HBase is a noSQL database and we will use it because it’s efficient at storing unstructured data. We will use Apache Phoenix to map to the HBase table and Perform SQL queries against the HBase table. Apache Zeppelin will be the business reporting tool to visualize these queries we perform against the HBase table.

In the concepts tutorial, the goal is to give you information on the background of each hardware/software tool used to build this Connected Data Architecture System for use cases, such as the IoT Weather Station.

## Prerequisites

-   Introduction

## Outline

-   What is a Raspberry Pi?
-   Internet of Things on R-Pi
-   Sense HAT Sensor Functionality
-   Docker
-   HDF Sandbox Docker Container
-   Apache NiFi
-   Apache MiNiFi
-   HDP Sandbox Docker Container
-   Apache HBase
-   Apache Phoenix
-   Apache Zeppelin

## What is a Raspberry Pi?

The Raspberry Pi (R-Pi) 3 is a microprocessor or computer with an open-source platform commonly used for beginners learning to code to practitioners building Internet of Things (IoT) related Applications. This embedded device has a 1.2 GHz ARMv8 CPU, 1GB of memory, integrated Wi-Fi and Bluetooth. The R-Pi comes with various General Purpose Input Output (GPIO) pins, input/output ports for connecting the device to external peripherals, such as sensors, keyboards, mouses and other peripherals. As can be seen in Figure 1, the R-Pi is connected to the internet via Ethernet port, a monitor via HDMI port, keyboard and mouse via USB port and powered by 12V power supply. This device has the capability to run various operating systems, such as Linux. Additionally, it can run an instance of Apache NiFi and for embedded devices that have a limited amount of memory, we can run Apache MiNiFi.


![raspberry_pi](assets/tutorial2/Raspberry-Pi-3-Flat-Top.jpg)

## Internet of Things on R-Pi

The R-Pi is not just a platform for building IoT projects, it is a super platform for learning about IoT. R-Pi is a great way to gain practical experience with IoT. According to [IBM Watson Internet of Things](http://www.ibm.com/internet-of-things/partners/raspberry-pi/), the R-Pi IoT platform can be used for the factory, environment, sports, vehicles, buildings, home and retail. All these R-Pi IoT platform use cases have in common that data is processed, which can result in augmented productivity in factories, enhanced environmental stewardship initiatives, provided winning strategies in sports, enhanced driving experience, better decision making, enhanced resident safety and security and customized and improved shopping experience in retail.

## Sense HAT Functionality

![sense-hat-pins](assets/tutorial2/sense-hat-pins.jpg)

The Sense HAT comes with an 8x8 LED Matrix, five-button joystick and the following sensors: gyroscope, accelerometer, magnetometer, temperature, barometric pressure and humidity.

### What exactly does the Sense HAT Sensor Measure?

The Sense HAT sensors enable users to measure orientation via an 3D accelerometer, 3D gyroscope and 3D magnetometer combined into one chip LSM9DS1. The Sense HAT also functions to measure air pressure and temperature via barometric pressure and temperature combined into the LPS25H chip. The HAT can monitor the percentage of humidity in correlation with temperature in the air via humidity and temperature sensor HTS221. All three of the these sensors are I2C.

### How does the Sense HAT Sensor Transfer Data to the R-Pi?

The Sense HAT sensor uses I2C, a communication protocol, to transfer data to the R-Pi and other devices. I2C requires two shared lines: serial clock signal (SCL) and bidirectional data transfers (SDA). Every I2C device uses a 7-bit address, which allows for more than 120 devices sharing the bus, and freely communicate with them one at a time on as-needed basis.

### What is an Advantage of I2C Sensors?

I2C makes it possible to have multiple devices in connection with the R-Pi, each having a unique address and can be set by updating the settings on the Pi. It will be easier to verify everything is working because one can see all the devices connected to the Pi.

## Docker

Docker is a an open source platform for developers and sysadmins to develop, ship, and run applications. Docker provides faster delivery of applications, allows users to deploy and scale easily, which results in easier maintenance. This platform includes a [Docker Engine](https://docs.docker.com/engine/), which is a lightweight and powerful open source containerization technology. This technology incorporates work flow for building and containerizing your applications. Docker containerization incorporates Docker images and containers. Docker images contain applications or services that can easily deploy an application into a testing, staging and production environment known as containers. For instance, with one Docker image, you can deploy multiple containers of that Docker image instance. Containers are a way to package and run an application, such as a framework: Hadoop, Spark, NiFi in an isolated environment. Containers are different from virtual machine because they do not need the extra layer of a hypervisor, instead they run directly on the host machine's kernel. Users are able to share their docker images and containers through the Docker Hub.

![docker_architecture](assets/tutorial1/docker_architecture.png)

In the docker architecture above, Docker registry are services used for storing Docker images, such as Docker Hub. Docker Host is the computer Docker runs on. Diving deeper into the host, you can see the Docker Daemon, which is used to create and manage Docker objects, such as images, containers, networks and volumes. The user or client is able to interact with Docker daemon via Client Docker CLI. Additionally, the CLI are scripts or direct commands entered by the user. The Docker daemon is a long-running program also known as a server. The CLI utilizes Docker's REST API to interact with the Docker daemon. As you can observe, the Docker Engine is a client-server application comprised of Client Docker CLI, REST API and Docker daemon.

You will use Docker as the backbone to deploy the Connected Data Architecture: IoT Devices, HDF Sandbox Container and HDP Sandbox Container.

![connected_data_architecture](assets/tutorial1/connected_data_architecture.png)

In the Connected Data Architecture, the Sense HAT and Raspberry Pi will be located in the Internet of Anything (alias Internet of Things), HDF Sandbox Container and HDP Sandbox Container will run in their own containers connected in a simulated network by Docker's default network feature known as Bridge.

## HDF Sandbox Docker Container

HDF Sandbox comes in different flavors: VirtualBox, VMware and Docker. You will be using the HDF Sandbox Docker container to build this IoT Weather Station via Connected Data Architecture. Hortonworks DataFlow (HDF) Sandbox is a way to deploy HDF into an isolated environment for testing, staging and sometimes production. [HDF is a application stack framework](https://hortonworks.com/products/data-center/hdf/) used to process data-in-motion. HDF comes with frameworks: Zookeeper, Storm, Ambari Infra, Ambari Metrics, Kafka, Log Search, Ranger and NiFi.

### Apache NiFi

NiFi is a robust and secure framework for ingesting data from various sources, performing simple transformations on that data and transporting it across a multitude of systems. The NiFi UI provides flexibility to allow teams to simultaneously change flows on the same machine. NiFi uses SAN or RAID storage for the data it ingests and the provenance data manipulation events it generates. Provenance is a record of events in the NiFi UI that shows how data manipulation occurs while data flows throughout the components, known as processors, in the NiFi flow. NiFi, program sized at approximately 800MB, has over 190 processors for custom integration with various systems and operations.

### Apache MiNiFi

MiNiFi was built to live on the edge for ingesting data at the central location of where it is born, then transport that data to your data center where NiFi lives. MiNiFi comes in two flavors Java or C++ agent. These agents access data from IoT and Desktop level devices. The idea behind MiNiFi is to be able to get as close to the data as possible from any particular location no matter how small the footprint on a particular embedded device.

## Visualization of MiNiFi and NiFi Place in IoT

![nifi-minifi-place-iot](assets/tutorial1/nifi-minifi-place-in-iot.png)

## HDP Sandbox Docker Container

HDP Sandbox comes in different flavors: VirtualBox, VMware and Docker. You will be using the HDP Sandbox Docker container to build this IoT Weather Station via Connected Data Architecture. Hortonworks Data Platform (HDP) Sandbox is a way to deploy HDP into an isolated environment for testing, staging and sometimes production. [HDP is a application stack framework](https://hortonworks.com/products/data-center/hdp/) used to process data-at-rest. HDP comes with various frameworks: HDFS, Yarn + MapReduce2, HBase, Phoenix, Zeppelin, etc.

## Apache HBase

Apache HBase is a noSQL database programmed in Java, but unlike other noSQL databases, it provides strong data consistency on reads and writes. HBase is a column-oriented key/value data store implemented to run on top of Hadoop Distributed File System (HDFS). HBase scales out horizontally in distributed compute clusters and supports rapid table-update rates. HBase focuses on scale, which enables it to handle very large database tables. Common scenarios include HBase tables that hold billions of rows and millions of columns. Another example is Facebook utilizes HBase as a structured data handler for its messaging infrastructure.

Critical part of the HBase architecture is utilization of the master nodes to manage region servers that distribute and process parts of data tables. HBase is part of the Hadoop ecosystem along with other services such as Zookeeper, Phoenix, Zeppelin.

## Apache Phoenix

Apache Phoenix provides the flexibility of late-bound, schema-on-read capabilities from NoSQL technology by leveraging HBase as its backing store. Phoenix has the power of standard SQL and JDBC APIs with full ACID transaction capabilities. Phoenix also enables online transaction processing (OLTP) and operational analytics in Hadoop specifically for low latency applications. Phoenix comes fully integrated to work with other products in the Hadoop ecosystem, such as Spark and Hive.

## Apache Zeppelin

Apache Zeppelin is a data science notebook that allows users to use interpreters to visualize their data with line, bar, pie, scatter charts and various other visualizations. One particular interpreter we will utilize is Phoenix that way we can visualize our weather data.

## Summary

Congratulations, you've finished the concepts tutorial! Now you are familiar with the technologies you will be utilizing in the tutorial series and will have a better understanding of each tools purpose in deploying this IoT Weather Station by way of Connected Data Architecture.

## Further Reading

- [Docker Overview](https://docs.docker.com/engine/docker-overview/)
- [Docker Engine Documentation](https://docs.docker.com/engine/)
- [Hortonworks DataFlow](https://hortonworks.com/products/data-center/hdf/)
- [Hortonworks Data Platform](https://hortonworks.com/products/data-center/hdp/)
- [Rasbperry Pi Overview](https://www.raspberrypi.org/documentation/)
- [Internet of Things 101: Getting Started w/ Raspberry Pi](https://www.pubnub.com/blog/2015-05-27-internet-of-things-101-getting-started-w-raspberry-pi/)
- [Sense HAT Documentation](https://www.raspberrypi.org/documentation/hardware/sense-hat/)
- [Apache NiFi Overview](https://hortonworks.com/apache/nifi/)
- [MiNiFi Overview](https://hortonworks.com/blog/edge-intelligence-iot-apache-minifi/)
- [Apache HBase Overview](https://hortonworks.com/apache/hbase/)
- [Apache Phoenix Overview](https://hortonworks.com/apache/phoenix/)
- [Apache Zeppelin Overview](https://hortonworks.com/apache/zeppelin/)
