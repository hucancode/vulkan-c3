module mj::animation::keyframe (<Type>);
struct Keyframe {
    float time;
    Type value;
}

struct Sample {
    float alpha;
    Type a;
    Type b;
}

fn Sample sample(Keyframe[] channel, float t) {
    if (channel.len == 0) return { 0, 0, 0 };
    if (t <= channel[0].time) {
        return {
            .a = channel[0].value,
            .alpha = 0,
        };
    }
    if (t >= channel[channel.len - 1].time) {
        return {
            .a = channel[channel.len - 1].value,
            .alpha = 0,
        };
    }
    usz index = binarysearch(channel, t, fn int(Keyframe kf, float time) {
        if (kf.time < time) return -1;
        if (kf.time > time) return 1;
        return 0;
    });
    usz next_idx = index;
    usz prev_idx = next_idx - 1;
    float prev_time = channel[prev_idx].time;
    float next_time = channel[next_idx].time;
    return Sample {
        .a = channel[prev_idx].value,
        .b = channel[next_idx].value,
        .alpha = (t - prev_time) / (next_time - prev_time),
    };
}

module mj;
import std::math::quaternion;
import std::sort;
import mj::animation::keyframe;

def PositionKeyframe = Keyframe(<Position>);
def PositionSample = Sample(<Position>);
def RotationKeyframe = Keyframe(<Quaternion>);
def RotationSample = Sample(<Quaternion>);
def ScaleKeyframe = Keyframe(<Scale>);
def ScaleSample = Sample(<Scale>);

struct Animation {
    NodeHandle target;
    PositionKeyframe[] positions;
    RotationKeyframe[] rotations;
    ScaleKeyframe[] scales;
}

fn void updateAnimationTrack(Animation[] track, float t, ResourceManager* resource_manager) {
    for (uint i = 0; i < track.len; i++) {
        updateAnimation(&track[i], t, resource_manager);
    }
}

fn void updateAnimation(Animation* animation, float t, ResourceManager* resource_manager) {
    Node* target = resource_manager.nodes.get(animation.target);
    if (animation.positions.len > 0) {
        PositionSample p = sample(<Position>)(animation.positions, t);
        target.position = p.a * p.alpha + p.b * (1.0f - p.alpha);
    }
    if (animation.rotations.len > 0) {
        RotationSample r = sample(<Quaternion>)(animation.rotations, t);
        target.rotation = r.a.slerp(r.b, r.alpha);
    }
    if (animation.scales.len > 0) {
        ScaleSample s = sample(<Scale>)(animation.scales, t);
        target.scale = s.a * s.alpha + s.b * (1.0f - s.alpha);
    }
}
