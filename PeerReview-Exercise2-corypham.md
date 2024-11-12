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

### Style Guide Infractions ###


1. **Excessive Use of Comments for Obvious Code**  
   Some comments describe what each line is doing, even for straightforward operations. Over-commenting can clutter the code and make it harder to read. Reserve comments for complex logic or unexpected behavior, not for trivial assignments or straightforward conditions.  
   - **Example**: In `PositionLockLerpSmoothingCamera`, comments on line 47 ("Move towards the target's position") explain something self-evident, which can be inferred directly from the code itself.  
   - [PositionLockLerpSmoothingCamera line 47](https://github.com/ensemble-ai/exercise-2-camera-control-chris-phan/blob/97d3f7fee93fad4502171c919dfe9ef966225cb1/Obscura/scripts/camera_controllers/position_lock_lerp_smoothing_camera.gd#L46)

2. **Inconsistent Use of Private Helper Functions**  
   There is inconsistency in breaking down complex logic into private helper functions. For example, `SpeedupPushZoneCamera` has redundant logic across `_handle_left`, `_handle_right`, `_handle_up`, and `_handle_down` for boundary handling and speed adjustment. Moving these to a helper function could significantly improve readability and maintainability.  
   - **Example**: The boundary check and movement code could be encapsulated in a helper function.  
   - [SpeedupPushZoneCamera lines 67-140](https://github.com/ensemble-ai/exercise-2-camera-control-chris-phan/blob/97d3f7fee93fad4502171c919dfe9ef966225cb1/Obscura/scripts/camera_controllers/speedup_push_zone_camera.gd#L67)

3. **Redundant Code in Signal Connections**  
   In `LerpSmoothingTargetFocusCamera` and `PositionLockLerpSmoothingCamera`, the connection of signals is repeated in multiple functions. This could be streamlined into a single function or a utility method, enhancing code reusability.  
   - **Example**: Signal connections like `SignalBus.vessel_stopped.connect(_handle_stopped_moving)` could be moved to a helper method that can be reused across similar controllers.  
   - [LerpSmoothingTargetFocusCamera line 20](https://github.com/ensemble-ai/exercise-2-camera-control-chris-phan/blob/97d3f7fee93fad4502171c919dfe9ef966225cb1/Obscura/scripts/camera_controllers/lerp_smoothing_target_focus_camera.gd#L20)

### Style Guide Exemplars ###

1. **Clear Separation of Camera Logic and Movement Logic**  
   The separation of logic into `_physics_process` for movement and `draw_logic` for rendering in each camera controller improves the structure of the code. This separation makes each function more concise and focused on a single responsibility, which is a good design choice for maintainability and readability.  
   - **Example**: `AutoScrollCamera` has a dedicated `_physics_process` that only handles movement, keeping movement logic separate from the camera drawing logic.  
   - [AutoScrollCamera line 24](https://github.com/ensemble-ai/exercise-2-camera-control-chris-phan/blob/97d3f7fee93fad4502171c919dfe9ef966225cb1/Obscura/scripts/auto_scroll_camera.gd#L24)

2. **Consistent Parameterization with Exported Variables**  
   Each script makes consistent use of `@export` variables, allowing customization through the editor without modifying the script directly. This approach shows consideration for flexibility and configurability in a way that adheres to good coding practices.  
   - **Example**: In `SpeedupPushZoneCamera`, properties like `push_ratio`, `pushbox_top_left`, and `pushbox_bottom_right` are exposed via `@export`, which makes the camera behavior easily customizable.  
   - [SpeedupPushZoneCamera line 4](https://github.com/ensemble-ai/exercise-2-camera-control-chris-phan/blob/97d3f7fee93fad4502171c919dfe9ef966225cb1/Obscura/scripts/camera_controllers/speedup_push_zone_camera.gd#L4)

---

# Best Practices #

### Best Practices Infractions ###

1. **Inefficient Use of Signal Handling**  
   In `LerpSmoothingTargetFocusCamera`, signals are connected to methods that contain minimal logic. This could be refactored by consolidating similar signal handling across controllers, especially if the logic is reused. Reducing these redundant signal handlers would simplify the code and improve efficiency.  
   - **Example**: Consolidate `_handle_stopped_moving` and `_handle_moved` across similar controllers.  
   - [LerpSmoothingTargetFocusCamera line 20](https://github.com/ensemble-ai/exercise-2-camera-control-chris-phan/blob/97d3f7fee93fad4502171c919dfe9ef966225cb1/Obscura/scripts/camera_controllers/lerp_smoothing_target_focus_camera.gd#L20)

2. **Limited Use of Helper Functions for Repeated Logic**  
   Repeated code, especially in the directional handling functions in `SpeedupPushZoneCamera`, should be moved to helper functions to improve modularity. For example, boundary checking and applying `push_ratio` could be made into a generic helper function to eliminate repetition.  
   - **Example**: Refactor `_handle_left`, `_handle_right`, `_handle_up`, and `_handle_down` into a shared helper function that takes direction as a parameter.  
   - [SpeedupPushZoneCamera lines 67-140](https://github.com/ensemble-ai/exercise-2-camera-control-chris-phan/blob/97d3f7fee93fad4502171c919dfe9ef966225cb1/Obscura/scripts/camera_controllers/speedup_push_zone_camera.gd#L67)


### Best Practices Exemplars ###

1. **Use of Timers for Delayed Actions**  
   In `LerpSmoothingTargetFocusCamera`, the `Timer` is used effectively to implement `catchup_delay_duration`, which enhances the camera’s responsiveness and smooth movement. This technique showcases a strong understanding of game programming principles.  
   - [LerpSmoothingTargetFocusCamera line 87](https://github.com/ensemble-ai/exercise-2-camera-control-chris-phan/blob/97d3f7fee93fad4502171c919dfe9ef966225cb1/Obscura/scripts/camera_controllers/lerp_smoothing_target_focus_camera.gd#L87)

2. **Encapsulation of Mesh Drawing into a Separate Function**  
   The modular approach to drawing logic (such as drawing boxes or crosshairs) in a separate `draw_logic` function across different scripts is a best practice for modularity and reuse. It reduces clutter in the main logic and improves readability.  

3. **Effective Use of Lerp for Smooth Camera Movement**  
   In `PositionLockLerpSmoothingCamera`, `lerpf` is used effectively for smooth transitions between positions. This technique is beneficial for creating smooth camera motion without abrupt changes, demonstrating thoughtful application of linear interpolation.  
   - [PositionLockLerpSmoothingCamera line 41](https://github.com/ensemble-ai/exercise-2-camera-control-chris-phan/blob/97d3f7fee93fad4502171c919dfe9ef966225cb1/Obscura/scripts/camera_controllers/position_lock_lerp_smoothing_camera.gd#L41)

