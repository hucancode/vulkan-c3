module mj::animation::keyframe (<Type>);
struct Keyframe {
    float time;
    Type value;
}

struct Sample {
    float a_weight;
    Type a;
    float b_weight;
    Type b;
}

fn Sample sample(Keyframe[] channel, float t) {
    if (channel.len == 0) return { 0, 0, 0 };
    if (t <= channel[0].time) return channel[0].value;
    if (t >= channel[channel.len - 1].time) return channel[channel.len - 1].value;
    usz index = binarysearch(channel, t, fn int(Keyframe kf, float time) {
        if (kf.time < time) return -1;
        if (kf.time > time) return 1;
        return 0;
    });
    usz next_idx = index;
    usz prev_idx = next_idx - 1;
    float prev_time = channel[prev_idx].time;
    float next_time = channel[next_idx].time;
    float alpha = (t - prev_time) / (next_time - prev_time);
    Type a = channel[prev_idx].value;
    Type b = channel[next_idx].value;
    return Sample {
        .a = a,
        .b = b,
        .a_weight = alpha,
        .b_weight = 1 - alpha,
    };
}

module mj;
import std::math::quaternion;
import std::sort;
import mj::animation::keyframe;

def PositionKeyframe = Keyframe(<Vec3f>);
def PositionSample = Sample(<Vec3f>);
def RotationKeyframe = Keyframe(<Quaternion>);
def RotationSample = Sample(<Quaternion>);
def ScaleKeyframe = Keyframe(<Vec3f>);
def ScaleSample = Sample(<Vec3f>);

struct Animation {
    NodeHandle target;
    PositionKeyframe[] positions;
    RotationKeyframe[] rotations;
    ScaleKeyframe[] scales;
}

fn void updateAnimationTrack(Animation[] track, float t, ResourceManager* resource_manager) {
    foreach (track : tracks) {
        updateAnimation(track, t, resource_manager);
    }
}

fn void updateAnimation(Animation animation, float t, ResourceManager* resource_manager) {
    Node* target = resource_manager.nodes.get(animation.target);
    PositionSample p = sample(<Vec3f>)(animation.positions, t);
    RotationSample r = sample(<Quaternion>)(animation.rotations, t);
    ScaleSample s = sample(<Vec3f>)(animation.scales, t);
    target.position = p.a * p.a_weight + p.b * p.b_weight;
    // target.rotation = r.a * r.a_weight + r.b * r.b_weight; // sample quarternion
    target.scale = s.a * s.a_weight + s.b * s.b_weight;
}
