# group10-hw-SC-musical-guacamole


# SuperCollider Didadctic Tool for Distortion Effects

The project brief is to implement a didactic tool in SuperCollider to learn and/or teach the audio effect of Distortion. We decided to design an application in SuperCollider that could be used by both Student and Teacher. 

The application features two different modes: ‘Learn’ and ‘Teach’, the user selects the mode based on what they want to use the application for. 

### Learn Mode

Learn Mode is designed to be used by a novice student who has a little to no understanding of what Distortion is or how it works.  The purpose of this mode is to introduce the student to the basic principles with a limited access of control to avoid the student being overwhelmed. 

![alt text](https://github.com/polimi-cmls-23/group10-hw-SC-musical-guacamole/blob/main/Learn_Mode.png?raw=true)

### Teach Mode

Teach Mode is designed to be used by a professor/teacher who already has a sufficient level of understanding of the distortion effect and how it is implemented. The purpose of this mode is to allow a professor to use this application to teach students how a distortion effect works, its parameters and their effect on an audio signal. For this reason, we give the Professor access to all the distortion effect’s parameters and remove the use of presets. With an extensive control of the effect and views of the Oscilloscope, Frequency Scope and Transfer Function we believe the professor can demonstrate a wide range of information clearly to a group of students. 

![alt text](https://github.com/polimi-cmls-23/group10-hw-SC-musical-guacamole/blob/main/Teach_Mode.png?raw=true)

## Block Diagram 

Below shows a block diagram of the application’s signal path. 

![alt text](https://github.com/polimi-cmls-23/group10-hw-SC-musical-guacamole/blob/main/signalchain.png?raw=true)

The signal path for the application is the same for both Learn and Teach mode. It is only the GUI that changes. 
