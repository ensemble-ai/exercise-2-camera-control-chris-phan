# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* [Cory Pham] 
* *email:* [corpham@ucdavis.edu]

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [ ] Perfect
- [ ] Great
- [x] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The crosshair is correctly drawn and sticks to the vessel as intended, providing a visual indicator of the target's position. However, the camera does not maintain proper centering around the vessel and crosshair. As a result, the view does not follow the vessel as it moves, which deviates from the assignment's goal for Stage 1, where the camera should always be centered on the vessel. This lack of centering limits the functionality and usability of the controller in tracking the vessel's movement dynamically.
### Stage 2 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The implementation for Stage 2 is fully aligned with the specified requirements. The camera correctly auto-scrolls at a constant speed along the X and Z axes, maintaining smooth movement. Additionally, when the vessel lags behind and touches the edge of the frame border box, it is accurately pushed forward by the box edge, as outlined in the directions. The frame border box is also drawn correctly, providing clear visual feedback on the boundary limits. Overall, the functionality meets the objectives perfectly for this stage.
___
### Stage 3 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The implementation for Stage 3 is mostly correct, with a few minor issues. The crosshair is drawn accurately, and the vessel correctly leads the crosshair, with the crosshair following the vessel’s movement as intended. However, the crosshair is not position-locked to the center of the camera, which slightly detracts from the expected behavior for this stage. Despite this minor issue, the primary functionality—where the camera follows the vessel with a slight lag—works well. The implementation is close to perfect but falls short due to the lack of camera-centered positioning for the crosshair.
### Stage 4 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [x] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The implementation for Stage 4 meets some aspects of the requirements but falls short in key areas, preventing it from fully realizing the desired functionality. While the crosshair is drawn, it is not position-locked at the center of the camera, which is essential for maintaining consistent visual tracking. The crosshair does lead the vessel's movement as specified, but when the vessel reaches the boundary of its allowed movement, the crosshair re-centers on the vessel, creating an unintended "lagging" effect rather than smoothly leading and maintaining a consistent offset. Additionally, the maximum allowable distance (leash distance) between the vessel and the center of the camera is not functioning correctly, as the camera does not maintain the intended gap before catching up. This results in inconsistent behavior that deviates from the expected dynamic of the camera leading the vessel with a smooth follow-back when it stops. The crosshair should lead without abruptly returning, and the camera should maintain a smooth, delayed follow-up when the vessel stops, which is not fully achieved here
___
### Stage 5 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [x] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
While the boundaries are correctly drawn, with the vessel constrained within the outer box and the crosshair within the inner box, the core behavior required for Stage 5 is not fully implemented. The camera does not dynamically adjust its speed or direction based on the vessel's position within the push zones, which is essential for this stage. Specifically, the camera should move at a speed determined by the push_ratio when the vessel is near the edge of the outer pushbox, responding differently to movement in the X and Y directions. Since this behavior is missing, the current output does not fully meet the requirements.
___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the dotnet style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####

Student did a good job following most of the GD style guide, there were only a few rules that were broken.

This line is [too long and should use double indents and be continued on multiple lines](https://github.com/ensemble-ai/exercise-2-camera-control-corypham/blob/ccc36d8c3ec939a53507d8380247534026eaa506/Obscura/scripts/camera_controllers/lock_lerp.gd#L30)

The 4 variables starting on this line are all private variables used only within the class for calculating the logic, [all private variables should precede with an underscore](https://github.com/ensemble-ai/exercise-2-camera-control-corypham/blob/ccc36d8c3ec939a53507d8380247534026eaa506/Obscura/scripts/camera_controllers/target_focus.gd#L9C1-L12C83) according to GD naming conventions

[Functions should be wrapped with 2 empty lines](https://github.com/ensemble-ai/exercise-2-camera-control-corypham/blob/ccc36d8c3ec939a53507d8380247534026eaa506/Obscura/scripts/camera_controllers/target_focus.gd#L72)

#### Style Guide Exemplars ####

Did a good job following [the correct order of the variables](https://github.com/ensemble-ai/exercise-2-camera-control-corypham/blob/ccc36d8c3ec939a53507d8380247534026eaa506/Obscura/scripts/camera_controllers/target_focus.gd#L4C1-L12C83)

Good job using correct formatting for [one liner if/else statement](https://github.com/ensemble-ai/exercise-2-camera-control-corypham/blob/ccc36d8c3ec939a53507d8380247534026eaa506/Obscura/scripts/camera_controllers/push_zone.gd#L60)
___
#### Put style guide infractures ####

___

# Best Practices #

### Description ###

If the student has followed best practices (Unity coding conventions from the StyleGuides document) then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####

[Using variables for constants like 2.5](https://github.com/ensemble-ai/exercise-2-camera-control-corypham/blob/ccc36d8c3ec939a53507d8380247534026eaa506/Obscura/scripts/camera_controllers/lock_lerp.gd#L59) will help someone reading the code understand the value, and will make it easier in case the value needs to be tweaked.

[Remove any unused commented lines of code](https://github.com/ensemble-ai/exercise-2-camera-control-corypham/blob/ccc36d8c3ec939a53507d8380247534026eaa506/Obscura/scripts/camera_controllers/position_lock.gd#L12)

There should be [no export variables for the position lock stage](https://github.com/ensemble-ai/exercise-2-camera-control-corypham/blob/ccc36d8c3ec939a53507d8380247534026eaa506/Obscura/scripts/camera_controllers/position_lock.gd#L4) as specified in the instructions


#### Best Practices Exemplars ####

The student did a great job [commenting all significant chunks of code with an explanation of what those lines of code are doing.](https://github.com/ensemble-ai/exercise-2-camera-control-corypham/blob/ccc36d8c3ec939a53507d8380247534026eaa506/Obscura/scripts/camera_controllers/target_focus.gd#L42) This really helped understand the flow of the logic. The permalink is one example of where they did this, but the student was very consistent with commenting throughout all their files.
