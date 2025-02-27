# EE552-NOC-SNN-accelerator
This project is part of the EE552 class and explores the implementation of a Network-on-Chip (NoC) based Spiking Neural Network (SNN) accelerator using SystemVerilog. Inspired by industrial neuromorphic architectures like IBM's TrueNorth and Intel's Loihi, this design focuses on traditional convolutional neural networks (CNNs) while analyzing their mapping to asynchronous SNNs.

Project Overview

• Hardware-based Machine Learning Accelerator: Implements an array of processing elements (PEs) communicating via a custom NoC.

• NoC Design: Adopted 2D mesh topology, deterministic routing scheme, and packet switching technique.

• Spiking Neural Network Computation: Implements a CNN-like convolution operation within an SNN framework.

• Asynchronous Design: Uses handshaking protocols to improve efficiency over synchronous architectures.

• RTL Implementation & Verification: Modeled and simulated using SystemVerilog with gate-level components and performance analysis.

Key Features

• Custom NoC for scalable communication

• PEs for convolution, pooling, and summation

• Packetized data transmission with memory access

• Verification using SystemVerilog testbenches

• Performance analysis on latency, throughput, bottlenecks, and deadlock possibilities

The project includes architecture definition, micro-architecture design, RTL coding, simulation, and final verification. Future enhancements may include expanding the input feature map size, increasing parallelism by adding more sum & accumulate blocks, and exploring multi-layer implementations.
