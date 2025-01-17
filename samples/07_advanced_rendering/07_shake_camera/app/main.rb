# Demo of camera shake
# Hold space to shake and release to stop

class ScreenShake
  attr_gtk

  def tick
    defaults
    calc_camera

    outputs.labels << { x: 600, y: 400, text: "Hold Space!" }

    # Add outputs to :scene
    outputs[:scene].solids << [100, 100, 100, 100, 135, 206, 250]
    outputs[:scene].solids << [200, 300.from_top, 100, 100, 255, 189, 49]
    outputs[:scene].solids << [900, 200, 50, 200, 176, 101, 0]
    outputs[:scene].solids << [850, 300, 150, 100, 85, 107, 47]

    # Describe how to render :scene
    outputs.sprites << { x: 0 - state.camera.x_offset,
                         y: 0 - state.camera.y_offset,
                         w: 1280,
                         h: 720,
                         angle: state.camera.angle,
                         path: :scene }
  end

  def defaults
    state.camera.trauma ||= 0
    state.camera.angle ||= 0
    state.camera.x_offset ||= 0
    state.camera.y_offset ||= 0
  end

  def calc_camera
    if inputs.keyboard.key_held.space
      state.camera.trauma += 0.02
    end

    next_camera_angle = 180.0 / 20.0 * state.camera.trauma**2
    next_offset       = 100.0 * state.camera.trauma**2

    # Ensure that the camera angle always switches from
    # positive to negative and vice versa
    # which gives the effect of shaking back and forth
    state.camera.angle = state.camera.angle > 0 ?
                           next_camera_angle * -1 :
                           next_camera_angle

    state.camera.x_offset = next_offset.randomize(:sign, :ratio)
    state.camera.y_offset = next_offset.randomize(:sign, :ratio)

    # Gracefully degrade trauma
    state.camera.trauma *= 0.95
  end
end

def tick args
  $screen_shake ||= ScreenShake.new
  $screen_shake.args = args
  $screen_shake.tick
end
