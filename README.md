# Inter-surface path loss modelling in 6G communications

Nowadays multiple devices need to connect to the internet. Many of them need to comunicate through wireless means and so we need to improve the quality of such communications. Additionally, Internet protocols are evolving, and 6G is now available. Μorphologies of the environment tend to reduce the performance os the wireless communication. A new technology called meta-surfaces has come to increase the reliability and security of any communication. By utilizing such meta-surfaces, the maximum distance restrictions associated with 6G can also be overcome and Non-Line of Site (NLOS) problems can be solved. 

## About The Project

This project simulates the behavior of communication between a Transmitter (Tx) and a Receiver (Rx) adding two meta-surfaces between them. The simulation uses Ray Tracing techniques to simulate the communication. The communication path begins from the Transmitter when it sends multiple rays in every direction. Then some of the rays gets reflected from the first meta-surface at the beginning and then gets reflected by the second meta-surface. Finally, the rays reache the Receiver.

At the end of simulation, useful plots data and plots are stored that presends the Path Loss between the two meta-surfaces, the RMSE and an exponent "n". 

## Meta-surfaces

Meta-surfaces refers to a kind of artificial sheet material with sub-wavelength thickness. Meta-surfaces modulate the behaviors of electromagnetic waves through specific boundary conditions. They can manage the beams of a Trasmitter and can be controlled to customise the behaviour of a wireless communication. In this project we assume that Meta-surfaces have square shape and they can reflect signals with zero loss. A group of unit cells surfaces placed in a grid, forms a meta-surface.

## Path Loss Model

In this project we assume that the communication follows the Friis equation between each stage. Because of the Meta-surfaces, the Path Loss between them is going to have strange behavior and that is what this project is looking for. In general form of Path Loss equation, is an exponent "n" which is typically equals to 2 in Free Space Path Loss but using Meta-surfaces this exponent tends to be differend. 

## Ray Tracing

Ray Tracing tenchniques are used to simulate the communication. The Meta-surfaces are have square shape and for this reason we use a script for Ray Tracing specifically for squares. (An inmplementaion for rectangles will also to the job but decreases the performance). GPU is being used to increase the overal performance.

### Execution

The project is implemented in Matlab. The user need to run the startProgram.m file. A GUI will pop-up and user can change multiple parameters to his needs.

## Contact

Georgoulas Dimosthenis - dimosgeo99@gmail.com - dgeorgoulas@cs.uoi.gr

Project Link: <a>https://github.com/dimosgeo/Inter-surface-Path-Loss-Modeling</a>
